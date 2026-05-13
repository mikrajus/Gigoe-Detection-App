import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gigoe_detection_app/features/domain/usecases/get_data_chart.dart';

part 'data_chart_event.dart';
part 'data_chart_state.dart';

class DataChartBloc extends Bloc<DataChartEvent, DataChartState> {
  final GetDataChartFromFirebase _getDataChartFromFirebase;

  DataChartBloc(this._getDataChartFromFirebase) : super(DataChartInitial()) {
    on<OnGetDataChartEvent>((event, emit) async {
      emit(DataChartLoading());

      final result = await _getDataChartFromFirebase.execute();

      // Membuka result (Either) menggunakan fold
      // Ini memastikan kita hanya memproses data jika result-nya 'Right' (sukses)
      await result.fold(
        (failure) async {
          emit(DataChartError(failure.message));
        },
        (dataList) async {
          // dataList di sini adalah List murni dari Firebase/Repository
          try {
            final Map<String, double> hasilAkhir = await getHasil(dataList);
            emit(DataChartHasData(hasilAkhir));
          } catch (e) {
            emit(DataChartError("Gagal mengolah data: ${e.toString()}"));
          }
        },
      );
    });
  }
}

/// Fungsi untuk menghitung total kerusakan dari satu item data
/// Menggunakan try-catch atau num.parse untuk keamanan tipe data
Future<int> getTotalKerusakan(dynamic item) async {
  try {
    // Pastikan konversi ke int aman, terkadang Firebase mengembalikan double/int
    final hilang = (item['total_hilang'] ?? 0).toInt();
    final karies = (item['total_karies'] ?? 0).toInt();
    final tambal = (item['total_tambal'] ?? 0).toInt();
    
    return hilang + karies + tambal;
  } catch (e) {
    return 0;
  }
}

/// Fungsi utama pengolahan data chart per kecamatan
Future<Map<String, double>> getHasil(List<dynamic> data) async {
  const listKecamatan = [
    'Baiturrahman',
    'Kuta Alam',
    'Meuraxa',
    'Syiah Kuala',
    'Lueng Bata',
    'Kuta Raja',
    'Banda Raya',
    'Jaya Baru',
    'Ulee Kareng'
  ];

  Map<String, double> hasil = {};

  for (var kecamatan in listKecamatan) {
    // 1. Filter data berdasarkan kecamatan yang sedang diiterasi
    // Kita cek apakah 'item' adalah Map dan punya key 'kecamatan'
    final filteredData = data.where((item) {
      if (item is Map) {
        return item['kecamatan'] == kecamatan;
      }
      return false;
    }).toList();

    double totalKerusakanKecamatan = 0;

    // 2. Hitung total kerusakan dari data yang sudah difilter
    for (var item in filteredData) {
      // Validasi null check sebelum memproses
      if (item['total_hilang'] != null || 
          item['total_karies'] != null || 
          item['total_tambal'] != null) {
        
        final int kerusakan = await getTotalKerusakan(item);
        totalKerusakanKecamatan += kerusakan.toDouble();
      }
    }

    // 3. Masukkan ke dalam map hasil
    hasil[kecamatan] = totalKerusakanKecamatan;
  }

  return hasil;
}