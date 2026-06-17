import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../core/utils/app_colors.dart';
import 'edit_patient_page.dart';

class PatientDetailPage extends StatefulWidget {
  final Map patientData;

  const PatientDetailPage({Key? key, required this.patientData}) : super(key: key);

  @override
  State<PatientDetailPage> createState() => _PatientDetailPageState();
}

class _PatientDetailPageState extends State<PatientDetailPage> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  final List<Map<String, String>> imageTypes = [
    {'type': 'front', 'title': 'Labial'},
    {'type': 'right', 'title': 'Bukal Kanan'},
    {'type': 'left', 'title': 'Bukal Kiri'},
    {'type': 'upper', 'title': 'Oklusal Atas'},
    {'type': 'lower', 'title': 'Oklusal Bawah'},
  ];

  void _showDeleteConfirmationDialog(BuildContext context, String key) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        backgroundColor: AppColors.softWhite,
        title: Text(
          'Hapus Data Pasien?',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus data pasien ini secara permanen?',
          style: GoogleFonts.poppins(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Batal'),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(
                  color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              FirebaseDatabase.instance
                  .ref()
                  .child('data_pasien')
                  .child(key)
                  .remove();
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to history list page
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Riwayat pasien berhasil dihapus',
                      style: GoogleFonts.poppins()),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              'Hapus',
              style: GoogleFonts.poppins(
                  color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance
          .ref()
          .child('data_pasien')
          .child(widget.patientData['key'] ?? '')
          .onValue,
      builder: (context, snapshot) {
        Map patient = widget.patientData;
        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          patient = Map<dynamic, dynamic>.from(snapshot.data!.snapshot.value as Map);
          patient['key'] = widget.patientData['key'];
        }

        return Scaffold(
          backgroundColor: AppColors.softWhite,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.softWhite),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 80,
            title: Text(
              "Detail Pasien",
              style: GoogleFonts.poppins(
                color: const Color(0xffffffff),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_rounded, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditPatientPage(patientData: patient),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_rounded, color: Colors.redAccent),
                onPressed: () {
                  if (patient['key'] != null) {
                    _showDeleteConfirmationDialog(context, patient['key']);
                  }
                },
              ),
              const SizedBox(width: 10),
            ],
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
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection(patient),
                  const SizedBox(height: 20),
                  if (patient['images'] != null && patient['images'] is Map)
                    _buildImagesCarousel(context, patient),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/add_photo',
                  arguments: patient['nama'],
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Lakukan Pemindaian Gigi",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildInfoSection(Map patient) {
    return Container(
      width: double.infinity,
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Data Diri Pasien",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.darkBlue,
            ),
          ),
          const Divider(height: 20, thickness: 1),
          _buildDetailRow("NIK", patient['nik'] ?? '-'),
          _buildDetailRow("Nama Lengkap", patient['nama'] ?? '-'),
          _buildDetailRow("Tanggal Lahir", patient['ttl'] ?? '-'),
          _buildDetailRow("Jenis Kelamin", patient['gender'] ?? '-'),
          _buildDetailRow("Kecamatan", patient['kecamatan']?.toString() ?? '-'),
          _buildDetailRow("Desa", patient['desa']?.toString() ?? '-'),
          _buildDetailRow("Pekerjaan", patient['pekerjaan']?.toString() ?? '-'),
          _buildDetailRow("Email", patient['email']?.toString() ?? '-'),
          if (patient['nomor'] != null && patient['nomor'].isNotEmpty)
            _buildDetailRow("Nomor Telepon", patient['nomor']),
          
          const SizedBox(height: 20),
          Text(
            "Hasil Pemeriksaan",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.darkBlue,
            ),
          ),
          const Divider(height: 20, thickness: 1),
          _buildDetailRow("Tanggal", patient['tanggal_pemeriksaan'] ?? '-'),
          _buildDetailRow("Total Karies", "${patient['total_karies'] ?? '0'}"),
          _buildDetailRow("Total Hilang", "${patient['total_hilang'] ?? '0'}"),
          _buildDetailRow("Total Tambal", "${patient['total_tambal'] ?? '0'}"),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.grey[700],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(" : ", style: TextStyle(fontWeight: FontWeight.w500)),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesCarousel(BuildContext context, Map patient) {
    final height = MediaQuery.of(context).size.height;
    Map imagesMap = patient['images'] as Map;

    // Filter available images
    List<Map<String, dynamic>> availableImages = [];
    int index = 1;
    for (var item in imageTypes) {
      if (imagesMap.containsKey(item['type'])) {
        availableImages.add({
          'type': item['type'],
          'title': item['title'],
          'path': imagesMap[item['type']].toString(),
          'displayIndex': index++,
        });
      }
    }

    if (availableImages.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CarouselSlider(
          carouselController: _controller,
          items: availableImages.map((imgData) {
            File imageFile = File(imgData['path']);
            return _buildCarouselCard(
              context,
              imageFile: imageFile,
              title: imgData['title'],
              subtitle: "PHOTO ${imgData['displayIndex']} OF ${availableImages.length}",
            );
          }).toList(),
          options: CarouselOptions(
            height: height * 0.35,
            disableCenter: true,
            initialPage: 0,
            autoPlay: false,
            enlargeCenterPage: true,
            enableInfiniteScroll: availableImages.length > 1,
            viewportFraction: 0.9,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: availableImages.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 10.0,
                height: 10.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == entry.key
                      ? AppColors.primaryBlue
                      : Colors.black.withValues(alpha: 0.2),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCarouselCard(BuildContext context, {required File imageFile, required String title, required String subtitle}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                subtitle,
                style: GoogleFonts.poppins(fontSize: 12),
              )
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (imageFile.existsSync()) {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      backgroundColor: Colors.transparent,
                      insetPadding: const EdgeInsets.all(10),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          InteractiveViewer(
                            minScale: 0.5,
                            maxScale: 4.0,
                            child: Image.file(imageFile, fit: BoxFit.contain),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.white, size: 30),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: imageFile.existsSync()
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          imageFile,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
