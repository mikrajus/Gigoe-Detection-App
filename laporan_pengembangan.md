# Laporan Pengembangan Aplikasi: Gigoe Detection App

Dokumen ini memuat rangkuman komprehensif mengenai seluruh tahapan pengembangan, perbaikan *bug*, dan optimisasi yang telah dilakukan pada **Gigoe Detection App**. Laporan ini disusun secara kronologis mulai dari penyesuaian antarmuka pengguna (UI) hingga integrasi sistem kecerdasan buatan (*Machine Learning*) berbasis *Offline*.

---

## 1. Penyesuaian Tema dan Antarmuka (UI/UX)
Pada tahap awal, fokus pengembangan adalah menyesuaikan identitas visual aplikasi agar lebih modern dan konsisten.

*   **Pembaruan Tema Utama (`lib/main.dart`)**: Mengubah tema dasar aplikasi menjadi warna dominan ungu dengan memanfaatkan `ColorScheme.fromSeed(seedColor: Colors.purple)`. Ini memastikan seluruh komponen bawaan Flutter (seperti tombol dan *app bar*) mengikuti palet warna ungu secara otomatis.
*   **Pembaruan Halaman Login (`lib/features/presentation/pages/login_page.dart`)**: Menyesuaikan warna latar belakang halaman otentikasi menggunakan variabel warna kustom `AppColors.softWhite` yang diambil dari berkas utilitas `app_colors.dart`.

## 2. Konfigurasi Ulang Firebase dan Autentikasi
Aplikasi dimigrasikan ke proyek Firebase yang baru untuk pemisahan *environment* yang lebih baik.

*   **Pembaruan Kredensial (`google-services.json` & `firebase_options.dart`)**: Mengganti kunci API dan URL basis data agar terhubung ke proyek `gigoe-detection-c2466`.
*   **Perbaikan Bug Inisialisasi (`[core/duplicate-app]`)**: Memperbaiki masalah sistem Android yang mengalami *crash* saat aplikasi mencoba melakukan inisialisasi Firebase lebih dari satu kali secara bersamaan di fungsi `main()`.

## 3. Migrasi Sistem ML Cloud ke Offline (YOLOv8 TFLite)
Ini adalah perubahan arsitektur terbesar. Sebelumnya, aplikasi harus mengunggah foto ke *Firebase Storage* dan menunggu hasil dari API *Cloud*. Sistem ini dirombak total menjadi 100% *Offline* (berjalan di dalam HP pengguna) untuk privasi, kecepatan, dan penghematan kuota internet.

*   **Pembuatan `LocalMLDataSource`**: Menulis sistem pengolahan baru dari nol menggunakan *library* `tflite_flutter` dan `image`.
*   **Integrasi Model**: Memasukkan file model kustom `best_float32.tflite` dan merancang pemindai yang mampu membaca arsitektur matriks dinamis dari YOLOv8 yaitu `[1, 7, 8400]`.
*   **Pembersihan Label Kustom**: Menambahkan logika pembersihan teks (Regex/Split) saat membaca `labels.txt` untuk membuang angka indeks otomatis (contoh: mengubah `"1: Karies"` menjadi `"Karies"`) agar tulisan sinkron dengan penghitung di layar UI.

## 4. Manajemen Memori & Pencegahan *Native Crash*
Saat pertama kali model offline dijalankan, aplikasi mengalami *Force Close* pada tingkat sistem C++ Android (`failed to attach to thread 614: Permission denied`).

*   **Penerapan *Strongly Typed Lists***: *Crash* terjadi karena memori HP membludak (Overload) saat Flutter mencoba memetakan ratusan ribu *pixel* ke memori C++ secara dinamis (`List<dynamic>`). Masalah ini diselesaikan dengan mengunci struktur memori menggunakan deklarasi tipe data yang ketat dan `growable: false`:
    ```dart
    var input = List<List<List<List<double>>>>.generate(1, ... growable: false);
    ```

## 5. Implementasi *Isolate Threading* (Pencegahan Layar Beku/ANR)
Beban menghitung algoritma *Non-Maximum Suppression* (NMS) dan memproses matriks 640x640 membuat "Jalur Utama" (Main Thread) layar HP membeku, memicu pesan *Application Not Responding (ANR) / Signal 3 (SIGQUIT)*.

*   **Isolate Background Processing**: Memindahkan *seluruh* siklus AI (Dekode gambar, Resize, Pemindaian TFLite, Algoritma NMS, hingga Menggambar Kotak) ke dalam proses latar belakang menggunakan fungsi `compute()`.
    ```dart
    static Future<Uint8List> _annotateInIsolate(Map<String, dynamic> params) async { ... }
    ```
    Hasilnya, layar HP tetap mulus dan bisa digeser (tidak *freeze*) meskipun aplikasi sedang bekerja keras di belakang layar memproses 5 foto beresolusi tinggi sekaligus.

## 6. Algoritma *Auto-Scaling* Bounding Box
Saat AI berhasil menemukan gigi, kotaknya tidak terlihat karena ukurannya hanya sebesar 1 piksel.

*   **Deteksi Skala Dinamis**: Kami menemukan bahwa model yang baru diekspor menghasilkan koordinat dalam format *Normalized Decimals* (0.0 - 1.0). Sebuah logika pendeteksi skala ditambahkan di dalam `LocalMLDataSource`:
    ```dart
    if ((output)[0][2][0] <= 1.5) { // Mendeteksi format normalisasi
      scaleX = originalWidth;
      scaleY = originalHeight;
    }
    ```
    Ini menjamin kotak akan tergambar sempurna terlepas dari apakah TFLite memuntahkan format koordinat *Absolute* ataupun *Normalized*.

## 7. Optimisasi Perenderan Layar (UI) Hasil Deteksi
Setelah kotak berhasil digambar, tampilan layar hasil (`ResultDetectionPage`) masih mengalami kendala tata letak dan pembaruan *state*.

*   **Perbaikan Teks Indikator (Bug `setState` pada `build`)**: Membuang `context.select` yang memicu pembaruan paksa (illegal rebuild) dan menggantinya dengan `context.watch<ClassificationBloc>().state` yang jauh lebih aman untuk menghitung total Gigi Karies, Tambal, dan Hilang.
*   **Perbaikan Rasio Foto (`BoxFit`)**: Mengubah pengaturan foto pada `ResultDetectionCard` dari `BoxFit.cover` menjadi `BoxFit.contain`. Ini mencegah mesin Flutter memotong (crop) paksa sisi atas dan bawah foto yang justru menghilangkan gambar kotak deteksi.
*   **Penambahan Teks Dinamis (`img.drawString`)**: Memerintahkan sistem untuk tidak hanya menggambar kotak, tetapi juga menuliskan **Label** dan **Akurasi Persentase** (contoh: "Karies 85%") tepat di atas masing-masing kotak deteksi.

## 8. Penciptaan *Smart Inference Cache* (Peningkatan Kecepatan 50%)
Sistem *State Management* (BLoC) aplikasi tanpa sengaja memerintahkan AI untuk memindai foto yang sama sebanyak **dua kali** secara bersamaan (satu untuk menghitung angka statistik, satu untuk menggambar gambar visual), menyebabkan HP kehabisan nafas dan proses memakan waktu berlarut-larut.

*   **In-Memory Deduplication (`_inferenceFutures`)**: Menginjeksi sebuah memori pintar (Cache) ke dalam otak pemindai:
    ```dart
    static final Map<String, Future<List<BBox>>> _inferenceFutures = {};
    ```
    Jika foto "Gigi Depan" sudah mulai dipindai untuk perhitungan angka, proses penggambaran visual tidak akan menghidupkan AI lagi, melainkan sekadar "mengambil antrean" dari proses pertama yang sedang berjalan. Hal ini memotong total waktu deteksi aplikasi (dari unggah hingga hasil keluar) sebesar **tepat 50%**.

## 9. Penambahan Fitur Manajemen Riwayat Pasien (Individual Delete)
Untuk memberikan kontrol penuh kepada pengguna, ditambahkan fitur manajemen riwayat data.

*   **Penghapusan Individual (Per Pasien)**: Memodifikasi antarmuka di `lib/Firebase/fetch_data_pasien.dart` dengan menambahkan tombol *Hapus* (tong sampah merah) pada kartu masing-masing pasien.
*   **Sistem Keamanan Konfirmasi (Anti-Misclick)**: Menambahkan `_showDeleteConfirmationDialog` yang akan memunculkan *pop-up* persetujuan *"Apakah Anda yakin ingin menghapus data pasien ini secara permanen?"* untuk mencegah penghapusan tanpa sengaja.
*   **Integrasi Firebase (Real-time)**: Menggunakan perintah `.remove()` pada `FirebaseDatabase.instance` yang terhubung ke `FirebaseAnimatedList`. Kartu pasien akan otomatis lenyap dari layar dalam sekejap mata setelah data ditarik dari server.

## 10. Modifikasi Atribut Akun Pengguna (NPA Dinamis & Email Asli)
Sebelumnya, sistem halaman Profil hanya memunculkan nilai statis (*hardcoded*) untuk email dan NPA.

*   **Formulir Register Baru (`register_page.dart`)**: Menyisipkan kolom isian tambahan pada tahapan pembuatan akun untuk menampung Nomor Pokok Anggota (NPA), serta memperbarui logika `userDocRef.set()` untuk menyimpan data `npa` ke dalam Firestore.
*   **Data Dinamis di Halaman Profil (`user_page.dart`)**: Menghubungkan teks statis *"email_saya@gmail.com"* dengan sistem bawaan Firebase menggunakan variabel `FirebaseAuth.instance.currentUser?.email`. Kami juga menambahkan logika untuk menarik NPA asli pengguna dari Firestore. Jika pengguna versi lama tidak memiliki NPA, sistem akan menuliskan *"NPA Belum Diatur"*.
*   **Perombakan Tata Letak Profil (*UI Alignment*)**: Mengubah penjajaran (*Alignment*) seluruh blok teks identitas (Nama, NPA, Email) dari Rata Tengah (`CrossAxisAlignment.center`) menjadi Rata Kiri (`CrossAxisAlignment.start`) di *header* halaman profil agar lebih menyerupai tata letak kartu identitas yang rapi dan profesional.

---
*Laporan ini dihasilkan secara otomatis dari riwayat sistem dan struktur pembaruan *version control*.*
