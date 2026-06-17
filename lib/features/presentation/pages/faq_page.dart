import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/utils/app_colors.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqs = [
      {
        'q': 'Apa itu Gigoe Detection App?',
        'a':
            'Gigoe Detection App adalah aplikasi cerdas berbasis Artificial Intelligence (AI) yang dirancang untuk membantu dokter gigi mendeteksi dan mengklasifikasikan karies gigi (gigi berlubang) secara dini menggunakan foto klinis gigi pasien.'
      },
      {
        'q': 'Bagaimana cara melakukan pemindaian gigi?',
        'a':
            '1. Daftarkan pasien baru pada menu "Tambah Pasien".\n2. Pada langkah akhir, pilih "Ya, Pindai Sekarang".\n3. Unggah atau ambil 5 foto gigi pasien sesuai instruksi (Gigi Labial, Bukal Kanan, Bukal Kiri, Oklusal Atas, dan Oklusal Bawah).\n4. Tekan tombol "Proses" untuk melihat hasil analisis AI.'
      },
      {
        'q': 'Apakah aplikasi ini dapat bekerja tanpa internet?',
        'a':
            'Ya. Aplikasi ini mendukung fitur database offline secara parsial. Data pasien yang terdaftar secara offline akan otomatis disinkronkan ke server cloud ketika perangkat terhubung kembali ke jaringan internet.'
      },
      {
        'q': 'Bagaimana cara mengartikan grafik Peta Sebaran?',
        'a':
            'Grafik pada Dashboard menampilkan akumulasi tingkat prevalensi karies gigi (DMF-T) dari total seluruh pasien berdasarkan masing-masing kecamatan di Banda Aceh. Kode wilayah (BN, KA, MX, dll.) disesuaikan dengan daftar wilayah sebaran karies Kota Banda Aceh.'
      },
      {
        'q': 'Apakah data medis pasien terjamin kerahasiaannya?',
        'a':
            'Tentu saja. Seluruh data identitas pasien dan rekam foto medis disimpan dengan aman menggunakan enkripsi standar di Firebase Realtime Database dan Firebase Cloud Storage.'
      },
      {
        'q': 'Bagaimana cara memperbarui data pemeriksaan pasien?',
        'a':
            'Anda dapat membuka tab "Riwayat", memilih pasien yang diinginkan untuk membuka "Halaman Detail", lalu menekan tombol Edit (ikon Pensil) di sudut kanan atas untuk memperbarui data rekam medis mereka.'
      }
    ];

    return Scaffold(
      backgroundColor: AppColors.softWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.primaryBlue),
        ),
        elevation: 0,
        toolbarHeight: 80,
        title: Text(
          "FAQ (Tanya Jawab)",
          style: GoogleFonts.poppins(
              color: AppColors.primaryBlue,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                  color: AppColors.primaryBlue.withValues(alpha: 0.15),
                  width: 1.5),
            ),
            color: Colors.white,
            child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                iconColor: AppColors.primaryBlue,
                collapsedIconColor:
                    AppColors.primaryBlue.withValues(alpha: 0.6),
                title: Text(
                  faq['q']!,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBlue,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      faq['a']!,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: (index * 80).ms)
              .slideY(begin: 0.1, end: 0);
        },
      ),
    );
  }
}
