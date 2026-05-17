import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/app_colors.dart';
import '../bloc/classification_bloc.dart';
import '../bloc/img_response_bloc.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'result_detection_page.dart';
import 'dart:io';

class AddPhoto extends StatefulWidget {
  const AddPhoto({
    Key? key,
  }) : super(key: key);

  @override
  State<AddPhoto> createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  late ImagePicker _imagePicker;
  late PageController _pageController;
  int _currentPage = 0;

  final List<String> _pageTitles = [
    'Gigi Labial',
    'Gigi Bukal Kanan',
    'Gigi Bukal Kiri',
    'Gigi Oklusal Atas',
    'Gigi Oklusal Bawah',
  ];

  final Map<String, String?> _imageFiles = {
    'Gigi Labial': null,
    'Gigi Bukal Kanan': null,
    'Gigi Bukal Kiri': null,
    'Gigi Oklusal Atas': null,
    'Gigi Oklusal Bawah': null,
  };

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _uploadImageFromGallery(String title) async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _imageFiles[title] = pickedImage.path;
      }
    });
  }

  Future<void> _takeImageFromCamera(String title) async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedImage != null) {
        _imageFiles[title] = pickedImage.path;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String name = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      backgroundColor: AppColors.softWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        elevation: 0,
        toolbarHeight: 80,
        title: Text(
          "Tambah Foto",
          style: GoogleFonts.poppins(
              color: AppColors.primaryBlue,
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => const BottomNavBar(),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _pageTitles.length,
              itemBuilder: (context, index) {
                final title = _pageTitles[index];
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: _buildImageCard(
                    title,
                    'PHOTO ${index + 1} OF 5',
                    _imageFiles[title],
                  ),
                );
              },
            ),
          ),
          _buildBottomNavigation(name),
        ],
      ),
    );
  }

  Widget _buildImageCard(
    String title,
    String subtitle,
    String? imageFile,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: imageFile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(imageFile),
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate_rounded, size: 60, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          "Belum ada foto",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        )
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _uploadImageFromGallery(title);
                  },
                  icon: const Icon(
                    Icons.upload_rounded,
                    size: 20,
                  ),
                  label: Text(
                    "Upload",
                    style: GoogleFonts.poppins(),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    foregroundColor: AppColors.softWhite,
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _takeImageFromCamera(title);
                  },
                  icon: const Icon(
                    Icons.photo_camera_rounded,
                    size: 20,
                  ),
                  label: Text(
                    "Camera",
                    style: GoogleFonts.poppins(),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.darkBlue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(String name) {
    final title = _pageTitles[_currentPage];
    final isImageSelected = _imageFiles[title] != null;
    final isLastPage = _currentPage == _pageTitles.length - 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.primaryBlue,
                  backgroundColor: AppColors.softWhite,
                  minimumSize: const Size(0, 50),
                  side: const BorderSide(color: AppColors.primaryBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  setState(() {
                    _currentPage--;
                  });
                },
                child: Text(
                  "Kembali",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          else
            const Spacer(),
            
          const SizedBox(width: 15),

          Expanded(
            child: isLastPage
                ? _buildProcessButton(name, isImageSelected)
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.softWhite,
                      backgroundColor: AppColors.primaryBlue,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      setState(() {
                        _currentPage++;
                      });
                    },
                    child: Text(
                      "Selanjutnya",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessButton(String name, bool isImageSelected) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.softWhite,
        backgroundColor: AppColors.primaryBlue,
        minimumSize: const Size(0, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        context.read<ImgResponseBloc>().add(
              OnCombinedImgResponse(
                frontImage: _imageFiles['Gigi Labial'] ?? '',
                rightImage: _imageFiles['Gigi Bukal Kanan'] ?? '',
                leftImage: _imageFiles['Gigi Bukal Kiri'] ?? '',
                upperImage: _imageFiles['Gigi Oklusal Atas'] ?? '',
                lowerImage: _imageFiles['Gigi Oklusal Bawah'] ?? '',
              ),
            );
        context.read<ClassificationBloc>().add(
              OnCombinedClassification(
                frontImage: _imageFiles['Gigi Labial'] ?? '',
                rightImage: _imageFiles['Gigi Bukal Kanan'] ?? '',
                leftImage: _imageFiles['Gigi Bukal Kiri'] ?? '',
                upperImage: _imageFiles['Gigi Oklusal Atas'] ?? '',
                lowerImage: _imageFiles['Gigi Oklusal Bawah'] ?? '',
              ),
            );
      },
      child: BlocConsumer<ImgResponseBloc, ImgResponseState>(
        listener: (context, state) {
          if (state is CombinedImgResponseState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ResultDetectionPage(name: name);
                },
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ImgResponseLoading) {
            return const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: AppColors.softWhite, strokeWidth: 3),
              ),
            );
          }
          return Center(
            child: Text(
              "Proses",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
      ),
    );
  }
}
