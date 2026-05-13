import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

import '../models/caries_model.dart';
import '../models/prediction_model.dart';

class BBox {
  final double left, top, right, bottom, score;
  final int classIndex;
  final String label;

  BBox(this.left, this.top, this.right, this.bottom, this.score, this.classIndex, this.label);

  double get area => max(0, right - left) * max(0, bottom - top);
}

double computeIoU(BBox a, BBox b) {
  double xA = max(a.left, b.left);
  double yA = max(a.top, b.top);
  double xB = min(a.right, b.right);
  double yB = min(a.bottom, b.bottom);

  double interArea = max(0, xB - xA) * max(0, yB - yA);
  if (interArea == 0) return 0.0;

  return interArea / (a.area + b.area - interArea);
}

class LocalMLDataSource {
  Interpreter? _interpreter;
  List<String>? _labels;

  LocalMLDataSource() {
    _loadModel();
    _loadLabels();
  }

  Future<void> _loadModel() async {}

  Future<void> _loadLabels() async {}

  img.Image? _preProcessImage(img.Image originalImage) {
    return img.copyResize(originalImage, width: 640, height: 640);
  }

  static final Map<String, Future<List<BBox>>> _inferenceFutures = {};

  Future<List<BBox>> _getNMSBoxes(String imagePath) {
    if (!_inferenceFutures.containsKey(imagePath)) {
      _inferenceFutures[imagePath] = _performInference(imagePath).catchError((e) {
        _inferenceFutures.remove(imagePath); // Remove failed cache so it can retry
        throw e;
      });
    }
    return _inferenceFutures[imagePath]!;
  }

  Future<List<BBox>> _performInference(String imagePath) async {
    try {
      final modelData = await rootBundle.load('assets/models/best_float32.tflite');
      final modelBytes = modelData.buffer.asUint8List();

      final labelData = await rootBundle.loadString('assets/models/labels.txt');
      final labels = labelData.split('\n').where((l) => l.trim().isNotEmpty).map((l) {
        if (l.contains(':')) {
          return l.split(':')[1].trim();
        }
        return l.trim();
      }).toList();

      return await compute(_runInferenceInIsolate, {
        'modelBytes': modelBytes,
        'labels': labels,
        'imagePath': imagePath,
      });
    } catch (e) {
      print("Error loading assets for isolate: \$e");
      rethrow;
    }
  }

  static Future<List<BBox>> _runInferenceInIsolate(Map<String, dynamic> params) async {
    final Uint8List modelBytes = params['modelBytes'];
    final List<String> labels = params['labels'];
    final String imagePath = params['imagePath'];

    final interpreter = Interpreter.fromBuffer(modelBytes);

    try {
      final bytes = File(imagePath).readAsBytesSync();
      img.Image? originalImage = img.decodeImage(bytes);
      if (originalImage == null) throw Exception('Failed to load image');

      final image = img.copyResize(originalImage, width: 640, height: 640);

      var input = List<List<List<List<double>>>>.generate(
        1,
        (i) => List<List<List<double>>>.generate(
          640,
          (y) => List<List<double>>.generate(
            640,
            (x) {
              final pixel = image.getPixel(x, y);
              return <double>[
                pixel.r / 255.0,
                pixel.g / 255.0,
                pixel.b / 255.0,
              ];
            },
            growable: false,
          ),
          growable: false,
        ),
        growable: false,
      );

      var output = List<List<List<double>>>.generate(
        1,
        (i) => List<List<double>>.generate(
          7,
          (j) => List<double>.filled(8400, 0.0, growable: false),
          growable: false,
        ),
        growable: false,
      );

      interpreter.run(input, output);

      List<BBox> allBoxes = [];
      double originalWidth = originalImage.width.toDouble();
      double originalHeight = originalImage.height.toDouble();
      
      double scaleX = 1.0;
      double scaleY = 1.0;
      
      // Auto-detect if coordinates are normalized (0.0-1.0) or absolute (0-640)
      if ((output)[0][2][0] <= 1.5) {
        scaleX = originalWidth;
        scaleY = originalHeight;
        print("SCALE MODE: NORMALIZED (0-1)");
      } else {
        scaleX = originalWidth / 640.0;
        scaleY = originalHeight / 640.0;
        print("SCALE MODE: ABSOLUTE (0-640)");
      }

      for (int anchor = 0; anchor < 8400; anchor++) {
        double maxClassScore = 0;
        int classIndex = -1;
        
        for (int c = 4; c < 7; c++) {
          double score = (output)[0][c][anchor];
          if (score > maxClassScore) {
            maxClassScore = score;
            classIndex = c - 4;
          }
        }

        if (maxClassScore > 0.20) {
          double cx = (output)[0][0][anchor];
          double cy = (output)[0][1][anchor];
          double w = (output)[0][2][anchor];
          double h = (output)[0][3][anchor];

          double left = (cx - w / 2) * scaleX;
          double top = (cy - h / 2) * scaleY;
          double right = (cx + w / 2) * scaleX;
          double bottom = (cy + h / 2) * scaleY;

          String labelName = classIndex < labels.length ? labels[classIndex] : "Unknown";
          allBoxes.add(BBox(left, top, right, bottom, maxClassScore, classIndex, labelName));
        }
      }

      List<BBox> finalBoxes = [];
      allBoxes.sort((a, b) => b.score.compareTo(a.score));

      while (allBoxes.isNotEmpty) {
        BBox current = allBoxes.first;
        finalBoxes.add(current);
        allBoxes.removeAt(0);

        allBoxes.removeWhere((box) {
          if (box.classIndex != current.classIndex) return false;
          double iou = computeIoU(current, box);
          return iou > 0.45;
        });
      }

      return finalBoxes;
    } finally {
      interpreter.close(); // ALWAYS release native memory to prevent Out-Of-Memory crashes!
    }
  }

  Future<CariesModel> classifyImage(String imagePath) async {
    if (imagePath.isEmpty || imagePath == "null") {
      return CariesModel(time: 0.0, predictions: []);
    }
    try {
      List<BBox> boxes = await _getNMSBoxes(imagePath);
      
      List<PredictionModel> predictions = boxes.map((box) => PredictionModel(
        confidence: box.score,
        predictionClass: box.label,
      )).toList();

      return CariesModel(
        time: 0.1,
        predictions: predictions,
      );
    } catch (e) {
      print("CLASSIFICATION ERROR: \$e");
      rethrow;
    }
  }

  Future<Uint8List> annotateImage(String imagePath) async {
    if (imagePath.isEmpty || imagePath == "null") {
      return Uint8List(0);
    }
    try {
      List<BBox> boxes = await _getNMSBoxes(imagePath);

      return await compute(_drawAndEncodeInIsolate, {
        'boxes': boxes,
        'imagePath': imagePath,
      });
    } catch (e) {
      print("ANNOTATION ERROR: \$e");
      final bytes = File(imagePath).readAsBytesSync();
      return Uint8List.fromList(bytes);
    }
  }

  static Future<Uint8List> _drawAndEncodeInIsolate(Map<String, dynamic> params) async {
    List<BBox> boxes = params['boxes'];
    final String imagePath = params['imagePath'];
    
    final bytes = File(imagePath).readAsBytesSync();
    img.Image? originalImage = img.decodeImage(bytes);
    if (originalImage == null) return Uint8List.fromList(bytes);

    for (var box in boxes) {
      img.Color color;
      if (box.label.toLowerCase() == 'karies') {
        color = img.ColorRgb8(255, 0, 0);
      } else if (box.label.toLowerCase() == 'tambal') {
        color = img.ColorRgb8(0, 0, 255);
      } else if (box.label.toLowerCase() == 'hilang') {
        color = img.ColorRgb8(255, 255, 0);
      } else {
        color = img.ColorRgb8(0, 255, 0);
      }

      img.drawRect(
        originalImage,
        x1: box.left.toInt(),
        y1: box.top.toInt(),
        x2: box.right.toInt(),
        y2: box.bottom.toInt(),
        color: color,
        thickness: 5,
      );

      img.drawString(
        originalImage,
        box.label + " " + (box.score * 100).toInt().toString() + "%",
        font: img.arial24,
        x: box.left.toInt(),
        y: max(0, box.top.toInt() - 28),
        color: color,
      );
    }

    return Uint8List.fromList(img.encodeJpg(originalImage));
  }
}
