import 'package:flutter/material.dart';
import 'package:gigoe_detection_app/core/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import '../features/presentation/pages/patient_detail_page.dart';

class FetchDataResults extends StatefulWidget {
  const FetchDataResults({Key? key}) : super(key: key);
  @override
  State<FetchDataResults> createState() => _FetchDataResultsState();
}

class _FetchDataResultsState extends State<FetchDataResults> {
  Query dbRef = FirebaseDatabase.instance.ref().child('data');

  late DatabaseReference dbReff;

  String _sortBy = 'nama';

  @override
  void initState() {
    super.initState();

    dbRef = FirebaseDatabase.instance.ref().child('data');
  }


  Widget listItem({required Map results}) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Container(
          height: 120,
          width: 300,
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
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      results['nama'],
                      style: GoogleFonts.poppins(
                        color: AppColors.darkBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.credit_card_rounded,
                          size: 20,
                          color: AppColors.primaryBlue,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          results['nik'],
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
                          Icons.location_pin,
                          size: 20,
                          color: AppColors.primaryBlue,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          results['kecamatan'].toString(),
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
                          Icons.calendar_today_rounded,
                          size: 20,
                          color: AppColors.primaryBlue,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          results['tanggal_pemeriksaan']?.toString() ?? 'Belum ada tanggal',
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.primaryBlue,
                  size: 28,
                ),
                const SizedBox(width: 15),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientDetailPage(patientData: results),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: double.infinity,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Urutkan berdasarkan:",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryBlue,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _sortBy,
                      icon: const Icon(Icons.arrow_drop_down,
                          color: AppColors.primaryBlue),
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.black),
                      onChanged: (String? newValue) {
                        setState(() {
                          _sortBy = newValue!;
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'nama',
                          child: Text('Nama (A-Z)'),
                        ),
                        DropdownMenuItem(
                          value: 'kecamatan',
                          child: Text('Kecamatan'),
                        ),
                        DropdownMenuItem(
                          value: 'tanggal_pemeriksaan',
                          child: Text('Tanggal Pemeriksaan'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream:
                  FirebaseDatabase.instance.ref().child('data_pasien').onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primaryBlue));
                }
                if (!snapshot.hasData ||
                    snapshot.data!.snapshot.value == null) {
                  return Center(
                    child: Text(
                      "Belum ada data pasien.",
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  );
                }

                Map<dynamic, dynamic> map =
                    snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                List<Map<dynamic, dynamic>> listData = [];
                map.forEach((key, value) {
                  Map<dynamic, dynamic> patientMap =
                      value as Map<dynamic, dynamic>;
                  patientMap['key'] = key;
                  listData.add(patientMap);
                });

                listData.sort((a, b) {
                  if (_sortBy == 'kecamatan') {
                    final namePlaceList = [
                      'baiturrahman',
                      'kuta alam',
                      'meuraxa',
                      'syiah kuala',
                      'lueng bata',
                      'kuta raja',
                      'banda raya',
                      'jaya baru',
                      'ulee kareng',
                    ];
                    int getKecamatanIndex(String? val) {
                      if (val == null) return namePlaceList.length;
                      final cleanVal = val.toLowerCase().trim();
                      final index = namePlaceList.indexOf(cleanVal);
                      return index == -1 ? namePlaceList.length : index;
                    }
                    int indexA = getKecamatanIndex(a['kecamatan']?.toString());
                    int indexB = getKecamatanIndex(b['kecamatan']?.toString());
                    int res = indexA.compareTo(indexB);
                    if (res != 0) return res;
                    // Fallback to name if kecamatan is same
                    return (a['nama'] ?? '')
                        .toString()
                        .toLowerCase()
                        .compareTo((b['nama'] ?? '').toString().toLowerCase());
                  } else if (_sortBy == 'tanggal_pemeriksaan') {
                    String valA = (a['tanggal_pemeriksaan'] ?? '').toString();
                    String valB = (b['tanggal_pemeriksaan'] ?? '').toString();

                    // Basic date parsing logic if format is dd/MM/yyyy
                    if (valA.contains('/') && valA.length == 10) {
                      var parts = valA.split('/');
                      valA = "${parts[2]}-${parts[1]}-${parts[0]}";
                    }
                    if (valB.contains('/') && valB.length == 10) {
                      var parts = valB.split('/');
                      valB = "${parts[2]}-${parts[1]}-${parts[0]}";
                    }

                    // Sort descending: newest (higher date) to oldest (lower date)
                    int res = valB.compareTo(valA);
                    if (res != 0) return res;
                    // Fallback to name
                    return (a['nama'] ?? '')
                        .toString()
                        .toLowerCase()
                        .compareTo((b['nama'] ?? '').toString().toLowerCase());
                  } else {
                    String valA = (a['nama'] ?? '').toString().toLowerCase();
                    String valB = (b['nama'] ?? '').toString().toLowerCase();
                    return valA.compareTo(valB);
                  }
                });

                return ListView.builder(
                  itemCount: listData.length,
                  itemBuilder: (context, index) {
                    return listItem(results: listData[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
