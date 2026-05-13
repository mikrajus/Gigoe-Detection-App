import 'package:flutter_test/flutter_test.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';

void main() {
  test('Print TFLite shapes', () async {
    final interpreter = await Interpreter.fromFile(File('assets/models/best_float32.tflite'));
    print('Input Shape: \${interpreter.getInputTensor(0).shape}'); 
    print('Output Shape: \${interpreter.getOutputTensor(0).shape}');
  });
}
