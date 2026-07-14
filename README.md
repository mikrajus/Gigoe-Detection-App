# Gigoe Detection App 🦷

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![TensorFlow Lite](https://img.shields.io/badge/TensorFlow_Lite-FF6F00?style=for-the-badge&logo=tensorflow&logoColor=white)

Gigoe Detection App adalah aplikasi mobile inovatif yang dikembangkan untuk mendeteksi karies gigi secara dini menggunakan teknologi Kecerdasan Buatan (Artificial Intelligence). Dibangun dengan *framework* Flutter, aplikasi ini mengintegrasikan model Machine Learning TensorFlow Lite untuk pengenalan gambar gigi secara *real-time* langsung di perangkat pengguna.

## 🌟 Fitur Utama

- **Deteksi Karies Otomatis**: Analisis foto gigi menggunakan model *Deep Learning* (TensorFlow Lite) untuk mengidentifikasi indikasi karies.
- **Pengambilan Gambar Dinamis**: Mendukung deteksi melalui kamera (*real-time capture*) maupun unggahan foto dari galeri.
- **Manajemen Profil Pengguna**: Sistem autentikasi aman menggunakan Firebase Authentication terintegrasi dengan Firestore.
- **Riwayat Analisis**: Menyimpan hasil deteksi dan analisis gigi.
- **Antarmuka Intuitif**: Desain UI/UX modern berbasis yang profesional dan ramah pengguna.

## 🏗️ Arsitektur Sistem

Aplikasi ini mengadopsi standar industri **Clean Architecture** yang memisahkan struktur kode menjadi lapisan (Layers) yang rapi untuk skalabilitas tinggi:
1. **Presentation Layer**: Mengatur UI (*Widgets* dan *Pages*).
2. **Domain/Core Layer**: Berisi utilitas inti aplikasi dan desain sistem.
3. **Data Layer**: Mengatur *Data Sources* baik itu pengambilan data (Remote Firebase) maupun pemrosesan lokal (Local ML Data Source).

## 🚀 Cara Instalasi (Local Development)

### Persyaratan Sistem
- Flutter SDK (Versi >= 3.0.3)
- Dart SDK
- Android Studio / VS Code

### Langkah-langkah Menjalankan
1. **Clone repositori ini:**
   ```bash
   git clone <URL_REPOSITORY_ANDA>
   cd Flutter-Gigoe-Detection-App
   ```
2. **Install dependensi paket:**
   ```bash
   flutter pub get
   ```
3. **Konfigurasi Firebase (Bila perlu di-setup ulang):**
   - Pastikan file `google-services.json` berada di `android/app/`.
4. **Jalankan aplikasi ke emulator atau *device* fisik:**
   ```bash
   flutter run
   ```

## 📚 Teknologi yang Digunakan

- **Frontend**: Flutter & Dart
- **Backend/BaaS**: Firebase (Auth, Firestore, Storage, Realtime Database)
- **Machine Learning**: TensorFlow Lite (`tflite_flutter`)
- **State Management**: Provider / BLoC
- **Desain UI**: Google Fonts, Fl_Chart

---
*Dikembangkan untuk keperluan penelitian dan implementasi teknologi Artificial Intelligence dalam bidang kesehatan gigi.*
