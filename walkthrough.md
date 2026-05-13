# Walkthrough: Pengembangan Gigoe Detection App (Dari Awal hingga Akhir)

Dokumen ini merangkum seluruh perjalanan langkah demi langkah (*walkthrough*) yang kita lakukan bersama dalam memperbaiki dan mengembangkan aplikasi ini dari awal hingga menjadi sistem yang sangat cepat dan berbasis 100% *offline*.

## Tahap 1: Penyesuaian Antarmuka & Tema (UI)
Pada sesi-sesi awal, fokus kita adalah pada tampilan visual.

1. **Mengubah Tema Keseluruhan (`main.dart`)**
   Kita mengganti tema utama dari warna standar bawaan Flutter (Biru/Material) menjadi palet **Ungu**. Hal ini dilakukan dengan menginjeksi parameter `ColorScheme.fromSeed(seedColor: Colors.purple)` ke dalam `ThemeData` milik widget `MaterialApp`.

2. **Memperbaiki Halaman Login (`login_page.dart`)**
   Warna *background* pada halaman *Login* juga disesuaikan menjadi warna `AppColors.softWhite` agar lebih sejuk dipandang mata dan selaras dengan tema modern ungu.

## Tahap 2: Konfigurasi Cloud & Autentikasi Firebase
Aplikasi ini sempat memiliki masalah tidak bisa tersambung ke Firebase dan tidak bisa login.

1. **Pemindahan Proyek (Google Services)**
   Kita memperbarui file `google-services.json` dan `firebase_options.dart` untuk mengalihkan rute *database* ke proyek Firebase yang baru secara spesifik (`gigoe-detection-c2466`).

2. **Perbaikan *Bug* `[core/duplicate-app]`**
   Android sempat mengalami gagal muat (*crash*) karena mencoba menyalakan Firebase dua kali secara bersamaan. Kita membersihkannya dan memastikan Firebase hanya menyala satu kali saat `main()` dijalankan.

## Tahap 3: Pemutusan API Cloud (Awal Era Offline TFLite)
Aplikasi sebelumnya wajib terhubung ke internet dan mengunggah foto secara *online*. Kita memotong proses ini dan memasukkan "otak AI" secara langsung ke dalam aplikasi (berupa *package* `tflite_flutter`).

1. **Memuat Model Lokal (`best_float32.tflite`)**
   Membuat *file* pondasi utama yaitu `local_ml_data_source.dart` yang bertugas membuka *file* AI Anda. 
2. **Pembersihan Teks (`labels.txt`)**
   AI Anda membaca indeks seperti `1: Karies`. Kita menambahkan fungsi pemotong huruf (Regex) otomatis agar hanya kata `"Karies"`, `"Tambal"`, dan `"Hilang"` yang diambil.

## Tahap 4: Mengatasi Bentrok Memori (*Native Crash SIGSEGV*)
Ketika pertama kali diuji untuk membedah foto, aplikasi menutup paksa (Force Close).

1. **Memori Bebas vs Memori Terkunci (*Strongly Typed*)**
   Awalnya, gambar diterjemahkan menggunakan `List.generate` yang sifatnya dinamis (`dynamic`). Mesin HP kebingungan menerima 400.000 titik warna tanpa tipe yang jelas, sehingga terjadi *Crash C++*. Kita menguncinya menggunakan tipe *List* bersarang yang sangat ketat:
   ```dart
   List<List<List<List<double>>>>.generate(..., growable: false)
   ```

## Tahap 5: Menyembuhkan *Layar Beku* (*Application Not Responding*)
Meskipun sudah tidak *Crash*, memproses foto 4K membuat layar HP sama sekali tidak bisa disentuh (beku/freeze) karena semuanya terjadi di **Jalur Utama** (*Main Thread*).

1. **Memindahkan Beban Kerja ke Balik Layar (*Isolates*)**
   Kita mengirimkan **semua pekerjaan berat** (mengupas resolusi foto, menerjemahkan piksel, menghitung rumus AI) ke *Isolate* menggunakan fungsi `compute()`. Jalur Utama menjadi 100% kosong, dan animasi aplikasi Anda berjalan mulus tanpa hambatan.

## Tahap 6: Memunculkan *Microscopic Bounding Box*
Meskipun tidak beku, kotak garis (Bounding Box) masih tidak muncul karena ukurannya ternyata hanya **1 pixel** (setitik debu).

1. **Algoritma Auto-Scaling**
   Ternyata ekspor YOLOv8 Anda menggunakan format *Normalized Coordinate* (ukuran desimal `0.0` sampai `1.0`). Kita memasang radar pengecek otomatis. Jika mesin menerima angka desimal, mesin akan segera mengalikannya dengan ukuran layar sebenarnya (contoh: `0.724 x 1080 pixel = 781 pixel`) sehingga kotaknya langsung mengembang sempurna.

## Tahap 7: Sinkronisasi Layar & Pemberian Nama (*Text Labeling*)
1. **Memperbaiki Fitur `BoxFit.cover`**
   Desain layar Anda `BoxFit.cover` sebelumnya terbukti "memotong paksa" (*crop*) area tepi foto agar pas di dalam kontainer kecil. Kita merubahnya menjadi `BoxFit.contain` agar foto ditampilkan secara penuh, sehingga kotak yang terletak di bibir atau gigi terluar tidak ikut terbuang.
2. **Menempelkan Teks Deskripsi**
   Menambahkan perintah khusus `img.drawString()` untuk menuliskan nama penyakit dan angka kepastiannya (misal: "Karies 85%") tepat di atas masing-masing kotak merah muda/kuning/biru.
3. **Membenahi Bug Update Teks**
   Angka "0" pada bagian teks diperbaiki dengan menghapus pemanggilan `setState` di tempat yang terlarang dan menggantinya dengan `context.watch<ClassificationBloc>().state`.

## Tahap 8: Sentuhan Pamungkas (Sistem *Smart Cache*)
Ini adalah pengoptimalan paling krusial. Pada awalnya, setiap proses memakan waktu berlarut-larut (sekitar 1-2 menit) karena aplikasi memerintahkan AI memproses foto yang sama sebanyak **dua kali** secara bersamaan.

1. **Penerapan *In-Memory Deduplication***
   Kita menanamkan sebuah Cache `_inferenceFutures`. Saat aplikasi meminta hasil, Cache akan berkata: *"Tunggu sebentar, saya sedang memprosesnya. Jika kamu meminta hal yang sama, saya akan memberikan fotokopiannya saja"*.
   Fitur ini sukses besar dalam **memangkas 50% beban kerja HP** dan menggandakan kecepatan aplikasi saat memproses kelima foto gigi tersebut!
