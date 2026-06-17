import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/utils/app_colors.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../../Firebase/auth.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = "";
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool _obscureText = true;

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBlue,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          // Background decorations (Modern detail)
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryBlue.withOpacity(0.15),
              ),
            ).animate().scale(duration: 1.seconds, curve: Curves.easeOut),
          ),
          Positioned(
            top: 200,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ).animate().scale(duration: 1200.ms, curve: Curves.easeOut),
          ),
          // Main content
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 60),
                Image.asset(
                  'assets/images/logo.png',
                  height: 35,
                ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.5, end: 0),
                const SizedBox(height: 10),
                Text(
                  ' Selamat Datang Kembali! ',
                  style: GoogleFonts.poppins(
                    color: AppColors.darkBlue,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.5, end: 0),
                Text(
                  ' Solusi Cerdas Deteksi Gigi Anda ',
                  style: GoogleFonts.poppins(
                    color: AppColors.darkBlue.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ).animate().fadeIn(delay: 300.ms).slideY(begin: -0.5, end: 0),
                const SizedBox(height: 10),
                Transform.scale(
                  scale: 1.15,
                  child: Image.asset(
                    'assets/images/doctor_login.png',
                    height: 380,
                    fit: BoxFit.contain,
                  ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
            Container(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * 0.60,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                boxShadow: AppColors.subtleShadow,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      'Masuk',
                      style: GoogleFonts.poppins(
                          color: const Color(0xFFF3F9FB),
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                        hintText: 'Alamat Email',
                        hintStyle: GoogleFonts.poppins(
                            color: const Color(0xffC3C3C3),
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 10, 0, 10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: password,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        hintText: 'Kata Sandi',
                        hintStyle: GoogleFonts.poppins(
                            color: const Color(0xffC3C3C3),
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.fromLTRB(20, 12, 0, 0),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility_rounded,
                              color: const Color(0xff2E4F4F),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    height: 40,
                    width: 230,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color(0xffffffff),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: email.text.trim(),
                            password: password.text.trim(),
                          );
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const BottomNavBar(),
                            ),
                          );
                        } catch (e) {
                          setState(() {
                            errorMessage = e.toString();
                          });
                          if (!mounted) return;
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Kesalahan!',
                                      style: GoogleFonts.poppins(
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Alamat Email dan Kata Sandi yang dimasukkan tidak valid!',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.primaryBlue),
                                      child: Text(
                                        'OK',
                                        style: GoogleFonts.poppins(
                                            color: const Color(0xffffffff),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        'Lanjutkan',
                        style: GoogleFonts.poppins(
                            color: AppColors.primaryBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Belum mempunyai akun? ',
                          style: GoogleFonts.poppins(
                              color: const Color(0xffffffff),
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text: 'Daftar',
                          style: GoogleFonts.poppins(
                              color: const Color(0xffffffff),
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const RegisterPage(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().slideY(begin: 0.2, end: 0, duration: 600.ms, curve: Curves.easeOut).fadeIn(duration: 600.ms),
          ],
        ),
      ),
        ],
      ),
    );
  }
}
