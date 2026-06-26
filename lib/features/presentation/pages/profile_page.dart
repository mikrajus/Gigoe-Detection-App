import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/utils/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        title: Text(
          "Profil Pengguna",
          style: GoogleFonts.poppins(
            color: const Color(0xffffffff),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            gradient: LinearGradient(
              colors: [
                AppColors.primaryBlue,
                AppColors.darkBlue,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                      width: 60,
                      height: 60,
                      child: Image.asset('assets/icons/icon_profile.png'),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Subhan Janura",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.phone,
                              size: 20,
                              color: AppColors.primaryBlue,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "085212345678",
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.credit_card,
                              size: 20,
                              color: AppColors.primaryBlue,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "1173031234567890",
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Informasi",
                style: GoogleFonts.poppins(
                    color: AppColors.darkBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              width: 300,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 20),
                      const Icon(
                        Icons.chat_rounded,
                        size: 20,
                        color: AppColors.primaryBlue,
                      ),
                      const SizedBox(width: 20),
                      Text(
                        "FAQ",
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontSize: 14),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                    height: 20,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 20),
                      const Icon(
                        Icons.menu_book_rounded,
                        size: 20,
                        color: AppColors.primaryBlue,
                      ),
                      const SizedBox(width: 20),
                      Text(
                        "Tentang Kami",
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontSize: 14),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Preferensi",
                style: GoogleFonts.poppins(
                    color: AppColors.darkBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              width: 300,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 20),
                      const Icon(
                        Icons.translate_rounded,
                        size: 20,
                        color: AppColors.primaryBlue,
                      ),
                      const SizedBox(width: 20),
                      Text(
                        "Bahasa",
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontSize: 14),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                    height: 20,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 20),
                      const Icon(
                        Icons.logout_rounded,
                        size: 20,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        child: SizedBox(
                          width: 200,
                          child: Text(
                            "Keluar",
                            style: GoogleFonts.poppins(
                                color: Colors.black, fontSize: 14),
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      color: Colors.red, // Warna bar
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.warning,
                                            color: Colors.white, // Warna ikon
                                          ),
                                          const SizedBox(width: 10),
                                          Text("Konfirmasi",
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                              )),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        "Anda yakin ingin keluar dari akun?",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          child: Text(
                                            "Batal",
                                            style: GoogleFonts.poppins(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            debugPrint("[ProfilePage] Logging out... currentUser before signout: ${FirebaseAuth.instance.currentUser?.uid}");
                                            try {
                                              await FirebaseAuth.instance.signOut();
                                              debugPrint("[ProfilePage] Logged out successfully. currentUser after signout: ${FirebaseAuth.instance.currentUser?.uid}");
                                            } catch (e) {
                                              debugPrint("[ProfilePage] Error signing out: $e");
                                            }
                                            if (context.mounted) {
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  '/welcome',
                                                  (route) => false);
                                            }
                                          },
                                          style: TextButton.styleFrom(
                                              foregroundColor: Colors.red,
                                              textStyle: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 12,
                                              )),
                                          child: const Text('Ya'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
