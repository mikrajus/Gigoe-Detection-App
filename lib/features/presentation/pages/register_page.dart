import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/app_colors.dart';
import '../widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nama = TextEditingController();
  final TextEditingController npa = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.softBlue,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.primaryBlue),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: double.infinity,
              height: size.height - 450,
              child: Image.asset(
                'assets/images/doctor_register.png',
                height: 350,
                width: 360,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * 0.60,
              decoration: const ShapeDecoration(
                color: AppColors.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      'Daftar Akun',
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
                      controller: nama,
                      decoration: InputDecoration(
                        hintText: 'Nama Lengkap',
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
                      controller: npa,
                      decoration: InputDecoration(
                        hintText: 'Nomor Pokok Anggota (NPA)',
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
                  const SizedBox(height: 24),
                  Container(
                    height: 40,
                    width: 230,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color(0xffffffff),
                    ),
                    child: CustomButton(
                      btnText: "Buat Akun",
                      backgroundColor: Colors.white,
                      textColor: AppColors.primaryBlue,
                      minimumSize: const Size(230, 58),
                      onPressed: () => onSubmit(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Sudah mempunyai akun? ',
                          style: GoogleFonts.poppins(
                              color: const Color(0xffffffff),
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text: 'Masuk',
                          style: GoogleFonts.poppins(
                              color: const Color(0xFFF3F9FB),
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const LoginPage(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  onSubmit() async {
    // 1. Validasi manual agar pengguna tidak mengirim form kosong
    if (email.text.trim().isEmpty || 
        password.text.trim().isEmpty || 
        npa.text.trim().isEmpty || 
        nama.text.trim().isEmpty) {
      warning("Semua kolom (Nama, NPA, Email, dan Kata Sandi) harus diisi!");
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      
      // Mengambil ID pengguna
      String userId = userCredential.user!.uid;
      
      // Membuat document reference untuk pengguna di Firestore
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      await userDocRef.set(
        {
          'name': nama.text.trim(),
          'npa': npa.text.trim(),
          'email': email.text.trim(),
        },
      );
      
      // Menggantikan ignore: use_build_context_synchronously dengan mounted check
      if (!mounted) return; 
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const LoginPage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // 2. Menangkap error Firebase Auth secara spesifik
      if (e.code == 'weak-password') {
        warning('Kata sandi terlalu lemah (minimal 6 karakter).');
      } else if (e.code == 'email-already-in-use') {
        warning('Email ini sudah terdaftar.');
      } else if (e.code == 'invalid-email') {
        warning('Format email tidak valid.');
      } else {
        warning('Gagal mendaftar: ${e.message}');
      }
    } catch (e) {
      // 3. Menangkap error Firestore atau sistem lainnya
      warning('Terjadi kesalahan: $e');
    }
  }

  // Fungsi warning sekarang menerima parameter pesan error
  warning(String message) {
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
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Text(
                message, // Pesan akan berubah sesuai error yang terjadi
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue),
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
}