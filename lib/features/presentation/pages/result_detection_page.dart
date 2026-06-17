import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/prediction.dart';
import '../../../core/utils/app_colors.dart';
import '../bloc/classification_bloc.dart';
import 'package:flutter/foundation.dart';
import '../bloc/img_response_bloc.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class ResultDetectionPage extends StatefulWidget {
  const ResultDetectionPage({super.key, required this.name, required this.imagePaths});

  final String name;
  final Map<String, String> imagePaths;

  @override
  State<ResultDetectionPage> createState() => _ResultDetectionPageState();
}

class _ResultDetectionPageState extends State<ResultDetectionPage> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  // Front
  List<String> frontCaries = [];
  List<String> frontMissing = [];
  List<String> frontFilling = [];

  // Right
  List<String> rightCaries = [];
  List<String> rightMissing = [];
  List<String> rightFilling = [];

  // Left
  List<String> leftCaries = [];
  List<String> leftMissing = [];
  List<String> leftFilling = [];

  // Upper
  List<String> upperCaries = [];
  List<String> upperMissing = [];
  List<String> upperFilling = [];

  // Lower
  List<String> lowerCaries = [];
  List<String> lowerMissing = [];
  List<String> lowerFilling = [];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    List<String> filterData(
      List<Prediction> predictions,
      String predictionClass,
    ) {
      return predictions
          .where((element) => element.predictionClass == predictionClass)
          .map((e) => e.predictionClass)
          .toList()
          .cast<String>();
    }

    final classificationState = context.watch<ClassificationBloc>().state;

    if (classificationState is CombinedClassificationState) {
      // Front
      frontCaries = filterData(classificationState.frontData.predictions!, "Karies");
      frontMissing = filterData(classificationState.frontData.predictions!, "Hilang");
      frontFilling = filterData(classificationState.frontData.predictions!, "Tambal");

      // Right
      rightCaries = filterData(classificationState.rightData.predictions!, "Karies");
      rightMissing = filterData(classificationState.rightData.predictions!, "Hilang");
      rightFilling = filterData(classificationState.rightData.predictions!, "Tambal");

      // Left
      leftCaries = filterData(classificationState.leftData.predictions!, "Karies");
      leftMissing = filterData(classificationState.leftData.predictions!, "Hilang");
      leftFilling = filterData(classificationState.leftData.predictions!, "Tambal");

      // Upper
      upperCaries = filterData(classificationState.upperData.predictions!, "Karies");
      upperMissing = filterData(classificationState.upperData.predictions!, "Hilang");
      upperFilling = filterData(classificationState.upperData.predictions!, "Tambal");

      // Lower
      lowerCaries = filterData(classificationState.lowerData.predictions!, "Karies");
      lowerMissing = filterData(classificationState.lowerData.predictions!, "Hilang");
      lowerFilling = filterData(classificationState.lowerData.predictions!, "Tambal");
    }

    int totalCaries = frontCaries.length +
        rightCaries.length +
        leftCaries.length +
        upperCaries.length +
        lowerCaries.length;

    int totalMissing = frontMissing.length +
        rightMissing.length +
        leftMissing.length +
        upperMissing.length +
        lowerMissing.length;

    int totalFilling = frontFilling.length +
        rightFilling.length +
        leftFilling.length +
        upperFilling.length +
        lowerFilling.length;

    return Scaffold(
      backgroundColor: AppColors.softWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        elevation: 0,
        toolbarHeight: 80,
        title: Text(
          "Hasil Pemindaian",
          style: GoogleFonts.poppins(
              color: AppColors.primaryBlue,
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        leading: const SizedBox(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: CarouselSlider(
              carouselController: _controller,
              items: [
                BlocBuilder<ImgResponseBloc, ImgResponseState>(
                  builder: (context, state) {
                    if (state is CombinedImgResponseState) {
                      return ResultDetectionCard(
                        imageBytes: state.frontImgUint8List,
                        caries: frontCaries.length,
                        filledTooth: frontFilling.length,
                        missingTooth: frontMissing.length,
                        title: "Labial",
                        subtitle: "PHOTO 1 OF 5",
                      );
                    }
                    return const ResultDetectionLoading();
                  },
                ),
                BlocBuilder<ImgResponseBloc, ImgResponseState>(
                  builder: (context, state) {
                    if (state is CombinedImgResponseState) {
                      return ResultDetectionCard(
                        imageBytes: state.rightImgUint8List,
                        caries: rightCaries.length,
                        filledTooth: rightFilling.length,
                        missingTooth: rightMissing.length,
                        title: "Bukal Kanan",
                        subtitle: "PHOTO 2 OF 5",
                      );
                    }
                    return const ResultDetectionLoading();
                  },
                ),
                BlocBuilder<ImgResponseBloc, ImgResponseState>(
                  builder: (context, state) {
                    if (state is CombinedImgResponseState) {
                      return ResultDetectionCard(
                        imageBytes: state.leftImgUint8List,
                        caries: leftCaries.length,
                        filledTooth: leftFilling.length,
                        missingTooth: leftMissing.length,
                        title: "Bukal Kiri",
                        subtitle: "PHOTO 3 OF 5",
                      );
                    }
                    return const ResultDetectionLoading();
                  },
                ),
                BlocBuilder<ImgResponseBloc, ImgResponseState>(
                  builder: (context, state) {
                    if (state is CombinedImgResponseState) {
                      return ResultDetectionCard(
                        imageBytes: state.upperImgUint8List,
                        caries: upperCaries.length,
                        filledTooth: upperFilling.length,
                        missingTooth: upperMissing.length,
                        title: "Oklusal Atas",
                        subtitle: "PHOTO 4 OF 5",
                      );
                    }
                    return const ResultDetectionLoading();
                  },
                ),
                BlocBuilder<ImgResponseBloc, ImgResponseState>(
                  builder: (context, state) {
                    if (state is CombinedImgResponseState) {
                      return ResultDetectionCard(
                        imageBytes: state.lowerImgUint8List,
                        caries: lowerCaries.length,
                        filledTooth: lowerFilling.length,
                        missingTooth: lowerMissing.length,
                        title: "Oklusal Bawah",
                        subtitle: "PHOTO 5 OF 5",
                      );
                    }
                    return const ResultDetectionLoading();
                  },
                ),
              ],
              options: CarouselOptions(
                height: height * 0.44,
                disableCenter: true,
                initialPage: 0,
                autoPlay: false,
                autoPlayInterval: const Duration(seconds: 5),
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [0, 1, 2, 3, 4].asMap().entries.map((entry) {
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
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 38),
            child: ResultoverallConditionCard(
              totalCaries: totalCaries,
              totalMissing: totalMissing,
              totalFilling: totalFilling,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 38, right: 38),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                foregroundColor: AppColors.softWhite,
                backgroundColor: AppColors.primaryBlue,
                minimumSize: const Size(0, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                final imgState = context.read<ImgResponseBloc>().state;
                Map<String, String> localImagePaths = {};
                
                if (imgState is CombinedImgResponseState) {
                  localImagePaths = await _saveAnnotatedImagesLocally(imgState);
                } else {
                  // Fallback if state is not available (shouldn't happen)
                  localImagePaths = await _saveImagesLocally();
                }

                await updateData(
                  totalCaries: totalCaries,
                  totalMissing: totalMissing,
                  totalFilling: totalFilling,
                  imagePaths: localImagePaths,
                );
                
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const BottomNavBar(),
                  ),
                );
              },
              child: Center(
                child: Text(
                  "Simpan",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, String>> _saveAnnotatedImagesLocally(CombinedImgResponseState state) async {
    final appDir = await getApplicationDocumentsDirectory();
    final Map<String, String> savedPaths = {};

    for (var entry in widget.imagePaths.entries) {
      final type = entry.key;
      final originalPath = entry.value;

      if (originalPath.isNotEmpty) {
        Uint8List? annotatedBytes;
        switch(type) {
          case 'front': annotatedBytes = state.frontImgUint8List; break;
          case 'right': annotatedBytes = state.rightImgUint8List; break;
          case 'left': annotatedBytes = state.leftImgUint8List; break;
          case 'upper': annotatedBytes = state.upperImgUint8List; break;
          case 'lower': annotatedBytes = state.lowerImgUint8List; break;
        }

        if (annotatedBytes != null && annotatedBytes.isNotEmpty) {
          final fileName = '${DateTime.now().millisecondsSinceEpoch}_$type.jpg';
          final newFile = File('${appDir.path}/$fileName');
          await newFile.writeAsBytes(annotatedBytes);
          savedPaths[type] = newFile.path;
        } else {
          // Fallback ke gambar asli jika proses anotasi gagal
          final file = File(originalPath);
          if (await file.exists()) {
            final fileName = '${DateTime.now().millisecondsSinceEpoch}_$type.jpg';
            final savedImage = await file.copy('${appDir.path}/$fileName');
            savedPaths[type] = savedImage.path;
          }
        }
      }
    }
    
    return savedPaths;
  }

  Future<Map<String, String>> _saveImagesLocally() async {
    final appDir = await getApplicationDocumentsDirectory();
    final Map<String, String> savedPaths = {};

    for (var entry in widget.imagePaths.entries) {
      final type = entry.key;
      final originalPath = entry.value;

      if (originalPath.isNotEmpty) {
        final file = File(originalPath);
        if (await file.exists()) {
          final fileName = '${DateTime.now().millisecondsSinceEpoch}_$type.jpg';
          final savedImage = await file.copy('${appDir.path}/$fileName');
          savedPaths[type] = savedImage.path;
        }
      }
    }
    
    return savedPaths;
  }

  updateData({
    required totalCaries,
    required totalMissing,
    required totalFilling,
    required Map<String, String> imagePaths,
  }) {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    ref.child('data_pasien').child(widget.name).update({
      'total_karies': totalCaries,
      'total_hilang': totalMissing,
      'total_tambal': totalFilling,
      'images': imagePaths,
    });
  }
}

class ResultDetectionCard extends StatelessWidget {
  const ResultDetectionCard({
    super.key,
    this.caries = 0,
    this.missingTooth = 0,
    this.filledTooth = 0,
    required this.imageBytes,
    required this.title,
    required this.subtitle,
  });

  final int caries;
  final int missingTooth;
  final int filledTooth;
  final Uint8List? imageBytes;

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.5,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
                style: GoogleFonts.poppins(),
              )
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: height * 0.20,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10),
            ),
            child: imageBytes != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(
                      imageBytes!,
                      fit: BoxFit.cover,
                    ),
                  )
                : const SizedBox(),
          ),
          const SizedBox(height: 10),
          Text(
            "Kondisi Gigi",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Gigi Karies ",
                    style: GoogleFonts.poppins(),
                  ),
                  Text(
                    "Gigi Hilang ",
                    style: GoogleFonts.poppins(),
                  ),
                  Text(
                    "Gigi Tambal ",
                    style: GoogleFonts.poppins(),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    ":  ",
                    style: GoogleFonts.poppins(),
                  ),
                  Text(
                    ":  ",
                    style: GoogleFonts.poppins(),
                  ),
                  Text(
                    ":  ",
                    style: GoogleFonts.poppins(),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    caries.toStringAsFixed(0),
                    style: GoogleFonts.poppins(),
                  ),
                  Text(
                    missingTooth.toStringAsFixed(0),
                    style: GoogleFonts.poppins(),
                  ),
                  Text(
                    filledTooth.toStringAsFixed(0),
                    style: GoogleFonts.poppins(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ResultoverallConditionCard extends StatelessWidget {
  const ResultoverallConditionCard({
    super.key,
    this.totalCaries,
    this.totalMissing,
    this.totalFilling,
  });

  final int? totalCaries;
  final int? totalMissing;
  final int? totalFilling;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Kondisi keselurahan Gigi Pasien",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Gigi Karies ",
                    style: GoogleFonts.poppins(),
                  ),
                  Text(
                    "Total Gigi Hilang ",
                    style: GoogleFonts.poppins(),
                  ),
                  Text(
                    "Total Gigi Tambal ",
                    style: GoogleFonts.poppins(),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    ":  ",
                    style: GoogleFonts.poppins(),
                  ),
                  Text(
                    ":  ",
                    style: GoogleFonts.poppins(),
                  ),
                  Text(
                    ":  ",
                    style: GoogleFonts.poppins(),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    totalCaries.toString(),
                    style: GoogleFonts.poppins(),
                  ),
                  Text(
                    totalMissing.toString(),
                    style: GoogleFonts.poppins(),
                  ),
                  Text(
                    totalFilling.toString(),
                    style: GoogleFonts.poppins(),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ResultDetectionLoading extends StatelessWidget {
  const ResultDetectionLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Labial",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                "PHOTO 0 OF 0",
                style: GoogleFonts.poppins(),
              )
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: height * 0.22,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.black45,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Gigi Karies ",
                    style: GoogleFonts.poppins(),
                  ),
                  Text(
                    "Gigi Hilang ",
                    style: GoogleFonts.poppins(),
                  ),
                  Text(
                    "Gigi Tambal ",
                    style: GoogleFonts.poppins(),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    ":  ",
                    style: GoogleFonts.poppins(),
                  ),
                  Text(
                    ":  ",
                    style: GoogleFonts.poppins(),
                  ),
                  Text(
                    ":  ",
                    style: GoogleFonts.poppins(),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "0",
                    style: GoogleFonts.poppins(),
                  ),
                  Text(
                    "0",
                    style: GoogleFonts.poppins(),
                  ),
                  Text(
                    "0",
                    style: GoogleFonts.poppins(),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
