import 'package:firebase_database/firebase_database.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditPatientPage extends StatefulWidget {
  final Map patientData;
  const EditPatientPage({Key? key, required this.patientData}) : super(key: key);

  @override
  State<EditPatientPage> createState() => _EditPatientPageState();
}

class _EditPatientPageState extends State<EditPatientPage> {
  late TextEditingController _nikController;
  late TextEditingController _namaController;
  late TextEditingController _lahirController;
  late TextEditingController _pekerjaanController;
  late TextEditingController _emailController;
  late TextEditingController _nomorController;

  String _selectedGender = '';
  String _selectedDistrict = '';
  String _selectedVillage = '';
  String _selectedProfession = '';

  late String _originalKey;

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
    'Mengurus Rumah Tangga',
    'Pelajar/Mahasiswa',
    'Pegawai Negeri Sipil',
    'Wiraswasta',
    'Petani/Pekebun',
    'Pensiunan',
    'Buruh',
    'Tukang',
    'Lainnya',
  ];

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('data_pasien');

    _originalKey = widget.patientData['key'] ?? '';

    _nikController = TextEditingController(text: widget.patientData['nik'] ?? '');
    _namaController = TextEditingController(text: widget.patientData['nama'] ?? '');
    _lahirController = TextEditingController(text: widget.patientData['ttl'] ?? '');
    _emailController = TextEditingController(text: widget.patientData['email'] ?? '');
    _nomorController = TextEditingController(text: widget.patientData['nomor'] ?? '');

    _selectedGender = widget.patientData['gender'] ?? '';
    _selectedDistrict = widget.patientData['kecamatan'] ?? '';
    _selectedVillage = widget.patientData['desa'] ?? '';
    _selectedProfession = widget.patientData['pekerjaan'] ?? '';

    if (!listGender.contains(_selectedGender)) _selectedGender = '';
    if (!listDistrict.contains(_selectedDistrict)) _selectedDistrict = '';
    if (_selectedDistrict.isNotEmpty && mapVillage[_selectedDistrict] != null) {
      if (!mapVillage[_selectedDistrict]!.contains(_selectedVillage)) {
        _selectedVillage = '';
      }
    } else {
      _selectedVillage = '';
    }
    if (!listProfession.contains(_selectedProfession)) _selectedProfession = '';
  }

  void _updatePasien() {
    String newName = _namaController.text.trim();
    if (newName.isEmpty) return;

    Map<String, dynamic> datapasien = {
      'nik': _nikController.text.trim(),
      'nama': newName,
      'ttl': _lahirController.text.trim(),
      'gender': _selectedGender.trim(),
      'kecamatan': _selectedDistrict.trim(),
      'desa': _selectedVillage.trim(),
      'pekerjaan': _selectedProfession.trim(),
      'email': _emailController.text.trim(),
      'nomor': _nomorController.text.trim(),
    };
    
    // Preserve any existing fields (like total_karies, etc.)
    widget.patientData.forEach((key, value) {
      if (key != 'key' && !datapasien.containsKey(key)) {
        datapasien[key] = value;
      }
    });

    if (newName == _originalKey) {
      // Name is same, just update
      dbRef.child(_originalKey).update(datapasien).then((_) {
        _showSuccessDialog();
      });
    } else {
      // Name changed, key changes. Set new node and remove old one
      dbRef.child(newName).set(datapasien).then((_) {
        if (_originalKey.isNotEmpty) {
          dbRef.child(_originalKey).remove();
        }
        _showSuccessDialog();
      });
    }
  }

  void _showSuccessDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data pasien berhasil diperbarui!', style: GoogleFonts.poppins()),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context); // Go back
  }

  @override
  void dispose() {
    _nikController.dispose();
    _namaController.dispose();
    _lahirController.dispose();
    _emailController.dispose();
    _nomorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.softWhite,
      appBar: AppBar(
        forceMaterialTransparency: true,
        elevation: 0,
        toolbarHeight: 80,
        title: Text(
          "Edit Pasien",
          style: GoogleFonts.poppins(
              color: AppColors.primaryBlue,
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SizedBox(
        height: screenHeight,
        child: ListView(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNikField("NIK", _nikController),
                    const SizedBox(height: 10),
                    _buildNameField("Nama Lengkap", _namaController),
                    const SizedBox(height: 10),
                    _buildDateField("Tanggal Lahir", _lahirController),
                    _buildGenderDropdown("Jenis Kelamin"),
                    _buildDistrictDropdown("Kecamatan"),
                    _buildVillageDropdown("Desa"),
                    _buildProfessionDropdown("Pekerjaan"),
                    _buildEmailField("Alamat Email", _emailController),
                    const SizedBox(height: 10),
                    _buildPhoneField("Nomor Handphone", _nomorController),
                    const SizedBox(height: 35),
                    MaterialButton(
                      onPressed: _updatePasien,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: AppColors.primaryBlue,
                      textColor: Colors.white,
                      minWidth: screenWidth,
                      height: 50,
                      child: Text(
                        'Simpan Perubahan',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
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
    );
  }

  Widget _buildDateField(String hintText, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DateTimePicker(
            type: DateTimePickerType.date,
            controller: _lahirController,
            decoration: InputDecoration(
              hintText: "Tanggal Lahir",
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
            firstDate: DateTime(1900),
            lastDate: DateTime(2101),
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
          SizedBox(
            height: 50,
            child: DropdownButtonFormField<String>(
              value: _selectedGender.isNotEmpty ? _selectedGender : null,
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
            ),
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
          SizedBox(
            height: 50,
            child: DropdownButtonFormField<String>(
              value: _selectedDistrict.isNotEmpty ? _selectedDistrict : null,
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
            ),
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
          SizedBox(
            height: 50,
            child: DropdownButtonFormField<String>(
              value: _selectedVillage.isNotEmpty ? _selectedVillage : null,
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
            ),
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
          SizedBox(
            height: 50,
            child: DropdownButtonFormField<String>(
              value:
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
            ),
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
