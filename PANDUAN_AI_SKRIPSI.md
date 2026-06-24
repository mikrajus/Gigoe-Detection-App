# CONTEXT & PROMPT INJECTION: PENJELASAN HASIL PENELITIAN APLIKASI (BAB 4)
## REDESIGN APLIKASI DETEKSI KARIES GIGI BERBASIS MOBILE (CROSS-PLATFORM & OFFLINE MODE)

> **Instruksi untuk Gemini AI:**
> Fokus utama Anda adalah membantu penulis menyusun **Bab 4 (Hasil dan Pembahasan)** skripsi. Jangan membahas Bab 1 sampai Bab 3 (karena proposal penelitian telah selesai). Tugas Anda adalah menjelaskan arsitektur, kode program, alur data, serta hasil pengujian dan optimasi aplikasi **Gigoe Detection App** sebagai produk nyata (hasil penelitian) dari skripsi ini. Tulis seluruh draf dalam Bahasa Indonesia akademis standar (PUEBI/EYD) dengan istilah teknis asing dicetak miring (*italic*).

---

## 1. STRUKTUR ARSITEKTUR APLIKASI SEBAGAI HASIL REDESIGN
Aplikasi dibangun menggunakan **Flutter (Dart)** dengan pola **Clean Architecture** untuk memisahkan logika bisnis dari detail framework/UI. Arsitektur ini dibagi menjadi tiga lapisan utama:

```
┌──────────────────────────────────────────────────────────┐
│                   PRESENTATION LAYER                     │
│   (UI Pages, Custom Widgets, BLoC State Management)      │
└───────────────────────────┬──────────────────────────────┘
                            ▼
┌──────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                        │
│   (Entities, Use Cases, Repository Interfaces)           │
└───────────────────────────┬──────────────────────────────┘
                            ▼
┌──────────────────────────────────────────────────────────┐
│                       DATA LAYER                         │
│   (Repositories Implementation, Data Sources Local/Web) │
└──────────────────────────────────────────────────────────┘
```

### A. Repositori & Data Source Utama Hasil Penelitian
1.  **`LocalMLDataSource`** (`lib/features/data/datasources/local_ml_data_source.dart`):
    *   **Peran:** Jantung dari implementasi *Offline Mode*. Mengelola pemuatan model YOLOv8 TFLite (`best_float32.tflite`), prapemrosesan citra, inferensi lokal, koordinasi thread latar belakang (*Isolates*), algoritma *Non-Maximum Suppression* (NMS), dan rendering kotak pembatas (*bounding box*) pada citra gigi.
2.  **`NetworkInfo`** (`lib/core/network/network_info.dart`):
    *   **Peran:** Menggunakan paket `connectivity_plus` untuk mendeteksi status koneksi internet pengguna secara *real-time*. Jika offline, sistem membatasi fitur sinkronisasi awan namun tetap memperbolehkan deteksi karies penuh secara lokal.
3.  **`FirebaseRepositoryImpl`** & **`RemoteFirebaseDataSource`**:
    *   **Peran:** Menangani sinkronisasi riwayat pasien, data grafik statistik karies, dan autentikasi pengguna ke Firebase database saat perangkat terhubung ke internet.

### B. Mekanisme Klasifikasi Hibrida (Hybrid Online-Offline Fallback)
Untuk menjamin keandalan fungsionalitas deteksi karies dalam segala kondisi jaringan, aplikasi mengimplementasikan arsitektur klasifikasi hibrida pada [predict_repository_impl.dart](file:///c:/gigoe%20v2/Flutter-Gigoe-Detection-App/lib/features/data/repositories/predict_repository_impl.dart):
1.  **Kondisi Online (Terhubung Internet):**
    *   Aplikasi memprioritaskan pemrosesan gambar secara jarak jauh dengan mengirimkan berkas citra ke **Roboflow API** (`PredictRemoteDataSourceImpl`) via panggilan HTTP POST.
    *   **Mekanisme Fallback Otomatis:** Apabila Roboflow API gagal merespons (`ServerException`) atau koneksi terputus di tengah jalan (`SocketException`), sistem secara otomatis (tanpa disadari pengguna) langsung mengalihkan pemrosesan citra ke model lokal YOLOv8 TFLite di perangkat melalui `PredictLocalDataSourceImpl`.
2.  **Kondisi Offline (Tanpa Internet):**
    *   Aplikasi mendeteksi ketiadaan koneksi internet melalui `NetworkInfo` dan langsung **melewati** (*bypass*) panggilan API ke Roboflow.
    *   Aplikasi langsung mengeksekusi model lokal YOLOv8 TFLite di dalam perangkat menggunakan `PredictLocalDataSourceImpl` (yang membungkus `LocalMLDataSource`).

---

## 2. DETAIL IMPLEMENTASI MODEL DETEKSI KARIES OFFLINE (YOLOv8 TFLite)
Bagian ini menjelaskan bagaimana citra gigi diproses secara lokal dari awal hingga menghasilkan deteksi karies, tambalan, atau gigi hilang.

### Alur Kerja Pipelines Deteksi Citra Lokal:
1.  **Pemuatan Model secara Lokal:**
    Aplikasi memuat berkas biner model `best_float32.tflite` dari direktori aset lokal ke memori perangkat menggunakan fungsi `Interpreter.fromBuffer(modelBytes)` dari paket `tflite_flutter`.
2.  **Prapemrosesan Citra (Image Preprocessing):**
    Citra gigi masukan didekode menggunakan paket `image`. Untuk memenuhi syarat input dimensi model YOLOv8, citra asli diubah ukurannya (*resized*) menjadi **640 x 640 piksel** menggunakan algoritma interpolasi linier (`img.copyResize`).
3.  **Normalisasi Warna RGB:**
    Warna piksel citra yang bertipe integer (0-255) dinormalisasi menjadi tipe riil (`double`) dengan rentang `[0.0, 1.0]` dengan membagi setiap saluran warna dengan `255.0` (`pixel / 255.0`).
4.  **Alokasi Memori Statis (Typed List):**
    Untuk mencegah *native memory crash* (SIGSEGV) di level C++ TensorFlow Lite, memori dialokasikan secara statis (*strongly typed*) dengan mematikan sifat dinamis array (`growable: false`):
    *   **Input Array:** `List<List<List<List<double>>>>` berdimensi `[1, 640, 640, 3]`.
    *   **Output Array:** `List<List<List<double>>>` berdimensi `[1, 7, 8400]` (di mana `7` merepresentasikan koordinat `[cx, cy, w, h]` dan `3` kelas objek; sedangkan `8400` adalah jumlah total kandidat *bounding box* jangkar/anchors dari YOLOv8).
5.  **Inferensi Lokal:**
    Menjalankan proses inferensi secara sinkronus lokal pada perangkat menggunakan perintah `interpreter.run(input, output)`.
6.  **Skalasi Kotak Deteksi Dinamis (Auto-Scaling):**
    Karena model mengekspor koordinat ternormalisasi (rentang desimal `0.0` sampai `1.0`), sistem mendeteksi nilai koordinat pertama (`output[0][2][0] <= 1.5`). Jika ternormalisasi, nilai kotak pembatas akan langsung dikalikan dengan resolusi asli gambar (`originalWidth` dan `originalHeight`) agar ukurannya presisi di layar ponsel.
7.  **Penerapan Non-Maximum Suppression (NMS):**
    Semua kandidat kotak dengan nilai keyakinan di atas batas ambang `0.20` disaring. Algoritma NMS menghitung nilai tumpang-tindih *Intersection over Union* (IoU). Jika dua kotak dari kelas yang sama memiliki nilai IoU melebihi batas `0.45`, kotak dengan tingkat keyakinan lebih rendah akan dieliminasi untuk menghindari kotak ganda pada satu gigi.
8.  **Anotasi Citra Gigi & Ekspor:**
    Anotasi teks label (Karies, Tambal, Hilang) digambar tepat di atas koordinat objek citra menggunakan pustaka `image`. Tebal garis pembatas disesuaikan secara dinamis berdasarkan lebar piksel gambar asli (`thickness = originalWidth ~/ 500`). Ukuran font teks label juga disesuaikan secara adaptif (`arial14` untuk resolusi rendah, `arial24` untuk sedang, dan `arial48` untuk resolusi tinggi). Citra hasil kemudian dienkode kembali menjadi format JPEG (`Uint8List`).

---

## 3. HASIL OPTIMISASI PERFORMA APLIKASI (TEMUAN UTAMA PENELITIAN)
Redesign ini tidak hanya memindahkan model AI ke perangkat lokal, melainkan juga menyelesaikan 3 masalah performa kritis pada perangkat seluler:

### Tabel Perbandingan Hasil Optimisasi Performa Aplikasi:
| Aspek Pengujian | Sebelum Optimisasi (Desain Awal Offline) | Setelah Optimisasi (Desain Akhir Offline) | Dampak terhadap Pengalaman Pengguna (UX) |
| :--- | :--- | :--- | :--- |
| **Kestabilan Memori (RAM)** | Terjadi *Force Close* (*Native Crash* SIGSEGV) saat memproses gambar resolusi tinggi | Aplikasi stabil berjalan tanpa *crash* meskipun memproses banyak foto berturut-turut | Menjamin keandalan aplikasi saat digunakan untuk pemeriksaan massal. |
| **Responsivitas Antarmuka (UI)** | Layar membeku (*freeze* / ANR) selama 1-2 menit saat inferensi AI sedang berjalan | Antarmuka tetap responsif, animasi berjalan mulus pada 60 FPS | Pengguna tetap dapat menavigasi menu atau menekan tombol kembali saat proses berlangsung. |
| **Waktu Inferensi Foto Ganda** | Waktu inferensi berjalan 2x lipat lebih lama (karena proses berjalan redundan) | Waktu inferensi dipotong **tepat 50%** untuk gambar yang sama | Mempercepat alur kerja klinis dokter gigi saat memuat halaman hasil deteksi karies. |
| **Akurasi Kotak Deteksi** | Kotak tidak terlihat (hanya berukuran 1 piksel) atau terpotong di tepi layar | Kotak tampil presisi di atas posisi gigi dan tidak terpotong pada tepi gambar | Dokter gigi dapat membaca hasil deteksi karies dengan jelas dan akurat. |

### Penjelasan Ilmiah Teknik Optimisasi:
1.  **Penyelesaian Masalah Memory Overflow (RAM Crash):**
    *   *Analisis:* Kegagalan disebabkan oleh sifat dinamis alokasi memori Dart (`List<dynamic>`) saat ditransfer ke memori C++ TFLite yang kaku.
    *   *Solusi:* Menggunakan array bertipe ketat (*Strongly Typed Lists*) dengan ukuran statis (`growable: false`). Hal ini memastikan sistem operasi Android/iOS langsung memesan ruang memori yang pas sejak awal tanpa memicu fragmentasi memori.
2.  **Pencegahan UI Thread Blocking melalui Dart Isolates:**
    *   *Analisis:* Sistem operasi seluler akan mematikan paksa aplikasi (ANR) jika *Main Thread* terhambat selama lebih dari 5 detik. Proses prapemrosesan matriks citra 640x640 dan kalkulasi NMS memakan waktu CPU yang intensif.
    *   *Solusi:* Menggunakan metode `compute()` untuk mendelegasikan pemrosesan citra dan inferensi ke thread latar belakang terpisah (*Isolates*). Setelah selesai, Isolate mengirim kembali data biner hasil anotasi ke *Main Thread* hanya untuk ditampilkan di layar.
3.  **Deduplikasi Inferensi via Smart Inference Cache:**
    *   *Analisis:* BLoC pattern memicu panggilan inferensi dari dua tempat berbeda secara asinkron untuk satu foto yang sama: satu untuk menghitung statistik jumlah karies (kebutuhan data angka) dan satu untuk menggambar kotak deteksi (kebutuhan visual).
    *   *Solusi:* Penanaman peta asinkron `_inferenceFutures` berbasis nama berkas citra. Ketika pemanggilan kedua masuk, sistem tidak akan menjalankan proses AI lagi, melainkan mengambil antrean hasil masa depan (*future*) yang sedang diselesaikan oleh proses pertama.

---

## 4. ALUR KERJA SISTEM SECARA DETAIL (SYSTEM WORKFLOW)
Berikut adalah alur kerja operasional lengkap dari aplikasi **Gigoe Detection App** secara berurutan, dari saat pengguna berinteraksi hingga hasil deteksi ditampilkan pada layar:

1.  **Autentikasi & Inisialisasi Aplikasi (Firebase Integration):**
    *   Pengguna membuka aplikasi. Fungsi `main()` melakukan inisialisasi Firebase Core secara aman (dilengkapi sistem pencegahan inisialisasi ganda `[core/duplicate-app]`).
    *   Pengguna melakukan masuk (*login*) melalui Firebase Authentication atau mendaftar (*register*) akun baru. Pada pendaftaran dokter gigi baru, terdapat isian Nomor Pokok Anggota (NPA) yang disimpan di Firestore.
2.  **Pemilihan Menu & Input Citra (Image Input Selection):**
    *   Setelah masuk, pengguna disuguhkan antarmuka utama bernuansa ungu. Pengguna memilih menu pemindaian gigi.
    *   Menggunakan modul kamera perangkat atau galeri foto (via paket `image_picker`), pengguna memasukkan 5 foto gigi klinis (depan, kiri, kanan, atas, bawah) pasien.
3.  **Pengecekan Konektivitas Jaringan (Connectivity Routing):**
    *   Sebelum citra dikirim ke kecerdasan buatan, sistem mendeteksi ada tidaknya koneksi internet secara *real-time* menggunakan pustaka `connectivity_plus` pada berkas `NetworkInfo`.
    *   **Rute A (Online Mode):** Jika internet tersedia, aplikasi mengirim berkas citra gigi ke **Roboflow API** menggunakan panggilan HTTP POST (`dio`) untuk inferensi berbasis *cloud*.
    *   **Rute B (Offline Mode / Fallback):** Jika internet tidak tersedia, ATAU jika Rute A mengalami kegagalan/RTO (`ServerException` atau `SocketException`), sistem secara otomatis mengalihkan beban kerja ke **model lokal TFLite** di perangkat.
4.  **Eksekusi Prapemrosesan Citra Lokal (Local Preprocessing):**
    *   Citra yang terpilih dibaca biner-nya dan dikonversi menjadi objek gambar (`img.Image`) menggunakan paket `image`.
    *   Citra diubah ukurannya (*resized*) menjadi **640 x 640 piksel** untuk mencocokkan matriks input YOLOv8.
    *   Setiap piksel citra dinormalisasi dari skala integer [0-255] ke skala desimal [0.0 - 1.0] dengan membagi nilainya dengan `255.0` (`pixel / 255.0`).
5.  **Multi-Threading via Dart Isolates (Pencegahan ANR):**
    *   Seluruh proses berat (dekode gambar, *resizing*, normalisasi, inferensi TFLite, perhitungan NMS, dan anotasi gambar) didelegasikan ke thread latar belakang terpisah (*Dart Isolates*) menggunakan fungsi `compute()`. 
    *   *Main Thread* tetap bebas dari beban komputasi berat sehingga antarmuka (UI) tetap responsif dan lancar (mencegah *Application Not Responding*).
6.  **Smart Inference Cache (Deduplikasi Pemrosesan):**
    *   BLoC State Management memicu pemrosesan citra dari dua tempat berbeda secara asinkronus (untuk visual dan perhitungan statistik).
    *   Untuk mencegah AI berjalan dua kali, sistem memeriksa peta memori asinkron `_inferenceFutures`. Jika citra tersebut sedang diproses, sistem menggunakan hasil kalkulasi pertama yang sedang berjalan secara efisien (mengurangi 50% waktu pemrosesan).
7.  **Inferensi Model YOLOv8 TFLite Lokal:**
    *   Model biner `best_float32.tflite` dimuat dari memori lokal.
    *   Array input `[1, 640, 640, 3]` (bertipe `double` statis / `growable: false` untuk mencegah kebocoran memori RAM) diproses menggunakan perintah `interpreter.run(input, output)`.
    *   Hasil keluaran berupa matriks `[1, 7, 8400]` dievaluasi berdasarkan ambang keyakinan (*confidence threshold*) `0.20`.
8.  **Penskalaan Koordinat (Auto-Scaling) & NMS:**
    *   Koordinat dideteksi apakah berbentuk desimal ternormalisasi (`output[0][2][0] <= 1.5`). Jika ya, koordinat dikalikan resolusi asli gambar agar ukurannya akurat.
    *   Kandidat kotak deteksi yang saling tumpang tindih pada satu gigi dibersihkan menggunakan algoritma *Non-Maximum Suppression* (NMS) dengan batas ambang batas IoU sebesar `0.45`.
9.  **Anotasi Visual Citra Gigi:**
    *   Kotak pembatas digambar di atas citra menggunakan pustaka `image` dengan warna yang sesuai (Karies = Merah, Tambal = Biru, Hilang = Kuning).
    *   Label teks dipasang di atas kotak pembatas dengan ketebalan garis dan ukuran font yang menyesuaikan resolusi asli citra (arial14, arial24, atau arial48) di dalam Isolate.
    *   Citra yang telah diplot kotak deteksinya diekspor kembali menjadi format JPEG byte (`Uint8List`).
10. **Penyajian Hasil Deteksi di Layar (Result UI Display):**
    *   Hasil citra beranotasi disajikan menggunakan widget Flutter dengan properti `BoxFit.contain` agar foto utuh dan tidak terpotong di tepi kontainer.
    *   BLoC state menyalurkan data kuantitatif deteksi (jumlah karies, tambal, hilang) ke layar secara dinamis tanpa illegal rebuild.
    *   Pengguna dapat menyimpan rekam medis ini ke riwayat pasien Firebase Database jika online, atau menghapus riwayat pasien secara individual dengan pop-up konfirmasi keamanan.

---

## 5. TEMPLATE PROMPT GEMINI UNTUK PENULISAN BAB 4

### A. Menulis Subbab: "Implementasi Antarmuka Pengguna (UI) dan Struktur Program"
> *"Berdasarkan berkas konteks skripsi saya, bantu saya menulis subbab Bab 4 berjudul 'Implementasi Antarmuka Pengguna dan Struktur Program'. Jelaskan bagaimana pola Clean Architecture (Presentation, Domain, Data) dan BLoC Pattern diimplementasikan dalam struktur kode aplikasi Gigoe Detection App. Jelaskan alur integrasi visual menu deteksi karies dan bagaimana data pasien disajikan secara dinamis. Tulis dalam Bahasa Indonesia formal akademis."*

### B. Menulis Subbab: "Implementasi Deteksi Karies Offline Berbasis YOLOv8 TFLite"
> *"Berdasarkan berkas konteks skripsi saya, tolong tulis draf Bab 4 bagian 'Implementasi Modul Deteksi Karies Gigi secara Offline'. Uraikan secara sistematis dan matematis proses prapemrosesan citra (resize 640x640, normalisasi RGB), alokasi memori typed list input-output YOLOv8, eksekusi model menggunakan tflite_flutter, penanganan auto-scaling koordinat, hingga penyaringan bounding box ganda menggunakan algoritma Non-Maximum Suppression (NMS) dengan IoU threshold 0.45. Gunakan bahasa akademis formal."*

### C. Menulis Subbab: "Implementasi Mekanisme Hibrida (Online-Offline Fallback)"
> *"Berdasarkan berkas konteks skripsi saya, tolong buatkan draf pembahasan mengenai Mekanisme Deteksi Hibrida (Online-Offline). Terangkan bagaimana aplikasi beroperasi saat online menggunakan Roboflow API (remote) dan secara otomatis mengalihkan pemrosesan ke model lokal TFLite (fallback mechanism) saat jaringan mati, terjadi timeout, atau server Roboflow mengalami error. Jelaskan peran NetworkInfo connectivity dalam mendeteksi perubahan status jaringan secara seamless."*

### D. Menulis Subbab: "Hasil Pengujian dan Analisis Optimasi Performa"
> *"Berdasarkan berkas konteks skripsi saya, bantu saya menyusun bagian analisis dan pembahasan performa aplikasi untuk Bab 4. Bahas secara detail tiga temuan optimasi utama: (1) Bagaimana Strongly Typed Lists mengeliminasi native memory crash, (2) Bagaimana penggunaan Dart Isolates (compute) menyelamatkan UI dari ANR/layar beku, dan (3) Bagaimana mekanisme Smart Inference Cache mempercepat waktu proses deteksi foto ganda sebesar 50%. Rujuk data dari Tabel Perbandingan Hasil Optimisasi Performa Aplikasi dalam pembahasan Anda. Tulis dalam bahasa Indonesia formal akademis."*
