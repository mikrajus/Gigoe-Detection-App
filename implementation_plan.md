# Offline & Online Capability Implementation Plan

Aplikasi Anda saat ini bergantung pada koneksi internet, terutama karena pemrosesan Machine Learning dilakukan di server eksternal (Roboflow) dan penggunaan database Firebase (Firestore/Storage) yang secara default memerlukan internet untuk sinkronisasi awal dan upload gambar.

Untuk membuat aplikasi ini dapat berjalan baik secara **Offline** (tanpa internet) dan tersinkronisasi saat **Online** (ada internet), kita perlu merombak arsitektur di beberapa titik kunci.

## User Review Required

> [!WARNING]
> **Penting:** Perubahan ini adalah perubahan arsitektur berskala besar (Major Architectural Change). Anda perlu menyiapkan model **`.tflite`** secara manual, karena saya tidak memiliki akses ke akun Roboflow Anda untuk mengunduh model tersebut.

## Open Questions

> [!IMPORTANT]
> 1. **Ketersediaan Model TFLite:** Apakah Anda sudah memiliki atau bisa mengekspor model pendeteksi karies ini dari Roboflow ke dalam format `.tflite` (TensorFlow Lite)? Ini adalah syarat MUTLAK agar fitur deteksi gambar bisa berjalan tanpa internet.
> 2. **Prioritas Offline:** Apakah semua fitur harus bisa offline? (Misal: pengguna bisa login offline asalkan sebelumnya sudah pernah login? Apakah gambar hasil deteksi cukup disimpan di HP, atau wajib di-upload ke Cloud ketika internet kembali menyala?)

---

## Proposed Changes

Berikut adalah langkah-langkah teknis yang akan kita lakukan jika Anda menyetujui rencana ini:

### 1. Migrasi Machine Learning ke Lokal (TFLite)

Kita akan mengubah logika pemanggilan API jarak jauh menjadi pemrosesan model di perangkat (on-device processing) sehingga tidak butuh internet sama sekali.

#### [NEW] `assets/models/caries_model.tflite`
- Anda harus meletakkan file `.tflite` dan file `labels.txt` (daftar label karies) dari Roboflow ke dalam folder `assets/models/`.

#### [MODIFY] `pubspec.yaml`
- Menambahkan library Machine Learning lokal: `tflite_flutter` atau `google_mlkit_object_detection`.
- Mendaftarkan folder `assets/models/` agar bisa diakses oleh aplikasi.

#### [NEW] `lib/features/data/datasources/local_ml_data_source.dart`
- Membuat implementasi baru yang akan memuat model `.tflite` menggunakan library `tflite_flutter`.
- Membuat fungsi untuk menerima gambar (dari kamera/galeri), mengubah ukuran/formatnya agar sesuai dengan input model, dan menjalankan proses klasifikasi (inferensi).
- Mengembalikan hasil (bounding box & tingkat kepercayaan) untuk digambar di atas foto.

#### [MODIFY] `lib/features/data/datasources/remote_data_source.dart` (Atau dihapus)
- Fungsi pemanggilan API ke `https://detect.roboflow.com` akan kita nonaktifkan/ganti, atau kita buat logika *fallback*: "Coba API online dulu (jika akurasinya lebih bagus), kalau tidak ada sinyal, pakai model lokal TFLite".

---

### 2. Konfigurasi Database Firebase Offline

Firebase Firestore sebenarnya sudah memiliki fitur bawaan untuk tetap bisa membaca data secara offline (*offline persistence*), tetapi kita perlu mengaktifkannya dan menata cara upload datanya.

#### [MODIFY] `lib/main.dart`
- Mengaktifkan konfigurasi *Offline Persistence* pada inisialisasi Firebase Firestore sehingga riwayat deteksi pengguna yang di-load sebelumnya tetap muncul walau internet mati.

#### [MODIFY] `lib/features/presentation/pages/add_photo_page.dart` (Atau halaman terkait upload)
- Saat ini, aplikasi mengirim gambar ke API/Firebase langsung.
- **Logika Baru:** Kita akan menggunakan library `connectivity_plus` (sudah terinstal) untuk mendeteksi jaringan.
  - **Jika Online:** Proses ML -> Simpan ke Firestore -> Upload ke Firebase Storage.
  - **Jika Offline:** Proses ML (lokal) -> Simpan riwayat/metadata ke database lokal sementara (seperti SQLite/Hive) atau biarkan Firestore menyimpannya di *cache offline* -> Simpan gambar ke penyimpanan HP (*Local Storage*).

---

### 3. Sinkronisasi Data (Local to Cloud)

#### [NEW] `lib/core/network/sync_manager.dart`
- Membuat manajer sinkronisasi di latar belakang. Saat aplikasi mendeteksi koneksi internet kembali aktif, sistem akan membaca gambar-gambar yang tertunda di *Local Storage*, mengunggahnya ke Firebase Storage, dan memperbarui status di Firestore.

---

## Verification Plan

### Manual Verification
1. Matikan WiFi dan Data Seluler pada emulator/perangkat Android.
2. Buka aplikasi, pastikan aplikasi tidak *crash*.
3. Lakukan deteksi foto gigi. Pastikan aplikasi berhasil menandai kotak karies dan menampilkannya di layar meski tidak ada internet (berarti TFLite lokal berhasil).
4. Nyalakan WiFi/Data Seluler. Pastikan hasil deteksi yang tadi diproses secara offline secara otomatis tersinkronisasi/muncul di akun Firebase.
