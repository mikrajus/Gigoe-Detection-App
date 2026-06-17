import 'package:firebase_database/firebase_database.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/utils/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddPatient extends StatefulWidget {
  const AddPatient({Key? key}) : super(key: key);

  @override
  State<AddPatient> createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _lahirController = TextEditingController();
  final TextEditingController _pekerjaanController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomorController = TextEditingController();
  final TextEditingController _tanggalPemeriksaanController = TextEditingController();

  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  String _selectedGender = '';
  String _selectedDistrict = '';
  String _selectedVillage = '';
  String _selectedProfession = '';
  bool _shouldScan = true;

  List<String> listDistrict = [
    'Baiturrahman',
    'Banda Raya',
    'Jaya Baru',
    'Kuta Alam',
    'Kuta Raja',
    'Lueng Bata',
    'Meuraxa',
    'Syiah Kuala',
    'Ulee Kareng'
  ];

  Map<String, List<String>> mapVillage = {
    'Baiturrahman': [
      'Ateuk Jawo',
      'Ateuk Deah Tanoh',
      'Ateuk Pahlawan',
      'Ateuk Munjeng',
      'Neusu Aceh',
      'Seutui',
      'Sukaramai',
      'Neusu Jaya',
      'Peuniti',
      'Kampung Baru'
    ],
    'Banda Raya': [
      'Lam Ara',
      'Lampeuot',
      'Mibo',
      'Lhong Cut',
      'Lhong Raya',
      'Peunyerat',
      'Lamlagang',
      'Geuceu Komplek',
      'Geuceu Inem',
      'Geuceu Kayee Jato'
    ],
    'Jaya Baru': [
      'Ulee Pata',
      'Lamjamee',
      'Lampoh Daya',
      'Emperom',
      'Geuceu Menara',
      'Lamteumen Barat',
      'Lamteumen Timur',
      'Bitai',
      'Punge Blang Cut'
    ],
    'Kuta Alam': [
      'Peunayong',
      'Laksana',
      'Keuramat',
      'Kuta Alam',
      'Beurawe',
      'Kota Baru',
      'Bandar Baru',
      'Mulia',
      'Lampulo',
      'Lamdingin',
      'Lambaro Skep'
    ],
    'Kuta Raja': [
      'Lampaseh Kota',
      'Merduati',
      'Keudah',
      'Peulanggahan',
      'Gampong Jawa',
      'Gampong Pande'
    ],
    'Lueng Bata': [
      'Lamdom',
      'Cot Masjid',
      'Bathoh',
      'Lueng Bata',
      'Blang Cut',
      'Lampaloh',
      'Suka Damai',
      'Panteriek',
      'Lamseupeung'
    ],
    'Meuraxa': [
      'Surien',
      'Aso Nanggroe',
      'Gampong Blang',
      'Lamjabat',
      'Gampong Baro',
      'Punge Jurong',
      'Lampaseh Aceh',
      'Punge Ujong',
      'Cot Lamkeuweuh',
      'Gampong Pie',
      'Ulee Lheue',
      'Deah Glumpang',
      'Lambung',
      'Blang Oi',
      'Alue Deah Teungoh',
      'Deah Baro'
    ],
    'Syiah Kuala': [
      'Ie Masen Kaye Adang',
      'Gampong Pineung',
      'Lamgugob',
      'Kopelma Darussalam',
      'Rukoh',
      'Jeulingke',
      'Tibang',
      'Deah Jaya',
      'Alue Naga',
      'Peurada'
    ],
    'Ulee Kareng': [
      'Pango Raya',
      'Pango Deah',
      'Ilie',
      'Lamteh',
      'Lamglumpang',
      'Ceurih',
      'Ie Masen Ulee Kareng',
      'Doi',
      'Lambhuk'
    ],
  };

  List<String> listGender = [
    'Laki-laki',
    'Perempuan',
  ];

  List<String> listProfession = [
    'Belum/Tidak Bekerja',
    'Buruh',
    'Lainnya',
    'Mengurus Rumah Tangga',
    'Pelajar/Mahasiswa',
    'Pensiunan',
    'Petani/Pekebun',
    'PNS',
    'Tukang',
    'Wiraswasta',
  ];

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('data_pasien');
  }

  get firestore => null;

  void _tambahpasien() {
    Map<String, String> datapasien = {
      'nik': _nikController.text.trim(),
      'nama': _namaController.text.trim(),
      'ttl': _lahirController.text.trim(),
      'gender': _selectedGender.trim(),
      'kecamatan': _selectedDistrict.trim(),
      'desa': _selectedVillage.trim(),
      'pekerjaan': _selectedProfession.trim(),
      'email': _emailController.text.trim(),
      'nomor': _nomorController.text.trim(),
      'tanggal_pemeriksaan': _tanggalPemeriksaanController.text.trim(),
    };
    if (_namaController.text.isNotEmpty) {
      // ignore: unnecessary_string_interpolations
      dbRef.child('${_namaController.text.trim()}').set(datapasien);
    } else {
      if (kDebugMode) {
        print("no data");
      }
    }
  }

  @override
  void dispose() {
    _nikController.dispose();
    _namaController.dispose();
    _lahirController.dispose();
    _pekerjaanController.dispose();
    _emailController.dispose();
    _nomorController.dispose();
    _tanggalPemeriksaanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        elevation: 0,
        toolbarHeight: 80,
        title: Text(
          "Tambah  Pasien",
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
      ),
      body: Form(
        key: _formKey,
        child: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primaryBlue),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 90),
            child: Stepper(
            type: StepperType.vertical,
            currentStep: _currentStep,
            onStepContinue: () {
              // Manual validation for each step to avoid silent failures
              if (_currentStep == 0) {
                if (_nikController.text.isEmpty || _namaController.text.isEmpty || _lahirController.text.isEmpty || _tanggalPemeriksaanController.text.isEmpty || _selectedGender.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Harap lengkapi NIK, Nama, Tgl Lahir, Tgl Periksa, dan Jenis Kelamin', style: GoogleFonts.poppins()), backgroundColor: Colors.red),
                  );
                  return;
                }
              } else if (_currentStep == 1) {
                if (_selectedDistrict.isEmpty || _selectedVillage.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Harap lengkapi Kecamatan dan Kelurahan/Desa', style: GoogleFonts.poppins()), backgroundColor: Colors.red),
                  );
                  return;
                }
              } else if (_currentStep == 2) {
                if (_selectedProfession.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Harap pilih Pekerjaan', style: GoogleFonts.poppins()), backgroundColor: Colors.red),
                  );
                  return;
                }
              }

              final isLastStep = _currentStep == 3;
              if (isLastStep) {
                if (_formKey.currentState!.validate()) {
                  _tambahpasien();
                  if (_shouldScan) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/add_photo',
                      (route) => false,
                      arguments: _namaController.text.trim(),
                    );
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/main',
                      (route) => false,
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Terdapat data yang belum valid, periksa kembali', style: GoogleFonts.poppins()), backgroundColor: Colors.red),
                  );
                }
              } else {
                setState(() {
                  _currentStep += 1;
                });
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() {
                  _currentStep -= 1;
                });
              } else {
                Navigator.pop(context);
              }
            },
            controlsBuilder: (context, details) {
              final isLastStep = _currentStep == 3;
              return Container(
                margin: const EdgeInsets.only(top: 20, bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: details.onStepContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          isLastStep
                              ? (_shouldScan ? 'Simpan & Mulai Pemindaian' : 'Simpan & Selesai')
                              : 'Selanjutnya',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (_currentStep > 0)
                      Expanded(
                        child: TextButton(
                          onPressed: details.onStepCancel,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Text(
                            'Kembali',
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
            steps: [
              Step(
                title: Text('Data Utama', style: GoogleFonts.poppins()),
                isActive: _currentStep >= 0,
                state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                content: Column(
                  children: [
                    _buildDateField("Tanggal Pemeriksaan", _tanggalPemeriksaanController,
                        firstDate: DateTime(DateTime.now().year, DateTime.now().month - 1, DateTime.now().day),
                        lastDate: DateTime(DateTime.now().year, DateTime.now().month + 1, DateTime.now().day),
                        initialDate: DateTime.now()),
                    _buildNikField("NIK", _nikController),
                    const SizedBox(height: 10),
                    _buildNameField("Nama Lengkap", _namaController),
                    const SizedBox(height: 10),
                    _buildDateField("Tanggal Lahir", _lahirController, 
                        lastDate: DateTime(DateTime.now().year - 15, DateTime.now().month, DateTime.now().day),
                        initialDate: DateTime(DateTime.now().year - 15, DateTime.now().month, DateTime.now().day)),
                    _buildGenderDropdown("Jenis Kelamin"),
                  ],
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
              ),
              Step(
                title: Text('Alamat', style: GoogleFonts.poppins()),
                isActive: _currentStep >= 1,
                state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                content: Column(
                  children: [
                    _buildDistrictDropdown("Kecamatan"),
                    _buildVillageDropdown("Desa"),
                  ],
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
              ),
              Step(
                title: Text('Pekerjaan & Kontak', style: GoogleFonts.poppins()),
                isActive: _currentStep >= 2,
                state: _currentStep > 2 ? StepState.complete : StepState.indexed,
                content: Column(
                  children: [
                    _buildProfessionDropdown("Pekerjaan"),
                    const SizedBox(height: 10),
                    _buildEmailField("Alamat Email (Opsional)", _emailController),
                    const SizedBox(height: 10),
                    _buildPhoneField("Nomor Handphone (Opsional)", _nomorController),
                  ],
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
              ),
              Step(
                title: Text('Pilihan Pemindaian', style: GoogleFonts.poppins()),
                isActive: _currentStep >= 3,
                state: _currentStep > 3 ? StepState.complete : StepState.indexed,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Apakah Anda ingin langsung melakukan pemindaian foto gigi untuk pasien ini?",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.darkBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _shouldScan = true;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                              decoration: BoxDecoration(
                                color: _shouldScan ? AppColors.primaryBlue.withValues(alpha: 0.1) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _shouldScan ? AppColors.primaryBlue : Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.photo_camera_rounded,
                                    color: _shouldScan ? AppColors.primaryBlue : Colors.grey,
                                    size: 32,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Ya, Pindai Sekarang",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: _shouldScan ? AppColors.primaryBlue : Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _shouldScan = false;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                              decoration: BoxDecoration(
                                color: !_shouldScan ? AppColors.primaryBlue.withValues(alpha: 0.1) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: !_shouldScan ? AppColors.primaryBlue : Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline_rounded,
                                    color: !_shouldScan ? AppColors.primaryBlue : Colors.grey,
                                    size: 32,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Tidak, Simpan Saja",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: !_shouldScan ? AppColors.primaryBlue : Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildNikField(String hintText, TextEditingController controller) {
    return TextFormField(
      controller: _nikController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(16)
      ],
      decoration: InputDecoration(
        hintText: "Nomor Induk Kependudukan (NIK)",
        hintStyle: GoogleFonts.poppins(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: Colors.grey,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 2,
            color: Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 2,
            color: AppColors.primaryBlue,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nomor Induk Kependudukan (NIK) harus diisi';
        } else if (value.length != 16) {
          return 'Nomor Induk Kependudukan (NIK) harus memiliki 16 digit';
        }
        return null;
      },
      onSaved: (val) {},
    );
  }

  Widget _buildNameField(String hintText, TextEditingController controller) {
    return TextFormField(
      controller: _namaController,
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: 'Nama Lengkap',
        hintStyle: GoogleFonts.poppins(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: Colors.grey,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 2,
            color: Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 2,
            color: AppColors.primaryBlue,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nama Lengkap harus diisi';
        }
        return null;
      },
    );
  }

  Widget _buildDateField(String hintText, TextEditingController controller, {DateTime? firstDate, DateTime? lastDate, DateTime? initialDate}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DateTimePicker(
            type: DateTimePickerType.date,
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.poppins(
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: Colors.grey,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.black,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  width: 2,
                  color: AppColors.primaryBlue,
                ),
              ),
              suffixIcon: const Icon(
                Icons.calendar_today,
                color: AppColors.primaryBlue,
              ),
            ),
            dateMask: 'dd/MM/yyyy',
            // initialValue: '',
            firstDate: firstDate ?? DateTime(1900),
            initialDate: initialDate ?? lastDate ?? DateTime.now(),
            lastDate: lastDate ?? DateTime(2101),
            onChanged: (val) {},
            validator: (val) {
              if (val!.isEmpty) {
                return 'Tanggal tidak boleh kosong';
              }
              return null;
            },
            onSaved: (val) {},
          ),
        ],
      ),
    );
  }

  Widget _buildGenderDropdown(String hintText) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
              initialValue: _selectedGender.isNotEmpty ? _selectedGender : null,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue!;
                });
              },
              items: listGender.map((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(
                    gender,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
              decoration: InputDecoration(
                hintText: "Jenis Kelamin",
                hintStyle: GoogleFonts.poppins(
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    width: 2,
                    color: Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    width: 2,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jenis kelamin harus dipilih';
                }
                return null;
              },
            ),
        ],
      ),
    );
  }

  Widget _buildDistrictDropdown(String hintText) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
              initialValue: _selectedDistrict.isNotEmpty ? _selectedDistrict : null,
              onChanged: (newValue) {
                setState(() {
                  _selectedDistrict = newValue!;
                  _selectedVillage = '';
                });
              },
              items: listDistrict.map((String district) {
                return DropdownMenuItem<String>(
                  value: district,
                  child: Text(
                    district,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
              decoration: InputDecoration(
                hintText: "Kecamatan",
                hintStyle: GoogleFonts.poppins(
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    width: 2,
                    color: Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    width: 2,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kecamatan harus dipilih';
                }
                return null;
              },
            ),
        ],
      ),
    );
  }

  Widget _buildVillageDropdown(String hintText) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
              initialValue: _selectedVillage.isNotEmpty ? _selectedVillage : null,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedVillage = newValue!;
                });
              },
              items: _selectedDistrict.isNotEmpty
                  ? mapVillage[_selectedDistrict]?.map((String village) {
                        return DropdownMenuItem<String>(
                          value: village,
                          child: Text(
                            village,
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList() ??
                      []
                  : [],
              decoration: InputDecoration(
                hintText: "Kelurahan/Desa",
                hintStyle: GoogleFonts.poppins(
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    width: 2,
                    color: Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    width: 2,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kelurahan/Desa harus dipilih';
                }
                return null;
              },
            ),
        ],
      ),
    );
  }

  Widget _buildProfessionDropdown(String hintText) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
              initialValue:
                  _selectedProfession.isNotEmpty ? _selectedProfession : null,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedProfession = newValue!;
                });
              },
              items: listProfession.map((String profession) {
                return DropdownMenuItem<String>(
                  value: profession,
                  child: Text(
                    profession,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
              decoration: InputDecoration(
                hintText: "Pekerjaan",
                hintStyle: GoogleFonts.poppins(
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    width: 2,
                    color: Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    width: 2,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pekerjaan harus dipilih';
                }
                return null;
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEmailField(String hintText, TextEditingController controller) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Alamat Email',
        hintStyle: GoogleFonts.poppins(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: Colors.grey,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 2,
            color: Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 2,
            color: AppColors.primaryBlue,
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField(String hintText, TextEditingController controller) {
    return TextFormField(
      controller: _nomorController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(13)
      ],
      decoration: InputDecoration(
        hintText: 'Nomor Handphone',
        hintStyle: GoogleFonts.poppins(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: Colors.grey,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 2,
            color: Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 2,
            color: AppColors.primaryBlue,
          ),
        ),
      ),
    );
  }
}
