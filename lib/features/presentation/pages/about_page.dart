import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/utils/app_colors.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          "Tentang Kami",
          style: GoogleFonts.poppins(
              color: AppColors.primaryBlue,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
        child: Column(
          children: [
            // App Logo and Description
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: AppColors.subtleShadow,
                      border: Border.all(
                          color: AppColors.primaryBlue.withValues(alpha: 0.1),
                          width: 2),
                    ),
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  )
                      .animate()
                      .scale(duration: 500.ms, curve: Curves.easeOutBack),
                  const SizedBox(height: 16),
                  Text(
                    'Gigoe Detection App',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Versi 2.0.0',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'Gigoe Detection App dirancang khusus untuk mendigitalisasi pencatatan rekam medis gigi serta membantu mempercepat diagnosis prevalensi karies gigi (gigi berlubang) secara dini menggunakan pemrosesan gambar klinis berbasis kecerdasan buatan (AI).',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms),

            const SizedBox(height: 30),

            // Research info card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                    color: AppColors.primaryBlue.withValues(alpha: 0.15),
                    width: 1.5),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.psychology_rounded,
                            color: AppColors.primaryBlue, size: 24),
                        const SizedBox(width: 10),
                        Text(
                          'Deteksi Karies AI',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBlue,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20, thickness: 1),
                    Text(
                      'Model klasifikasi AI dalam aplikasi ini dilatih menggunakan dataset gambar klinis gigi untuk mengenali tanda-tanda kerusakan enamel, dentin, serta mahkota gigi. Sistem memproses 5 perspektif gambar gigi yang disatukan untuk menghitung rasio DMF-T secara dinamis.',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 500.ms, delay: 200.ms)
                .slideY(begin: 0.1, end: 0),

            const SizedBox(height: 20),

            // Developer team card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                    color: AppColors.primaryBlue.withValues(alpha: 0.15),
                    width: 1.5),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.people_rounded,
                            color: AppColors.primaryBlue, size: 24),
                        const SizedBox(width: 10),
                        Text(
                          'Tim Pengembang',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBlue,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20, thickness: 1),
                    Text(
                      'Aplikasi ini dikembangkan oleh tim kolaborasi peneliti dan ahli kedokteran gigi untuk mewujudkan sistem pemantauan kesehatan mulut yang cerdas, efisien, dan presisi di Kota Banda Aceh.',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [],
                    )
                  ],
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 500.ms, delay: 350.ms)
                .slideY(begin: 0.1, end: 0),
          ],
        ),
      ),
    );
  }
}
