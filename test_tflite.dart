import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';

void main() async {
  try {
    print('Loading model...');
    final interpreter = await Interpreter.fromFile(File('assets/models/best_float32.tflite'));
    print('Model loaded.');
    
    var inputShape = interpreter.getInputTensor(0).shape;
    var inputType = interpreter.getInputTensor(0).type;
    print('Input Shape: \$inputShape, Type: \$inputType');
    
    var outputShape = interpreter.getOutputTensor(0).shape;
    var outputType = interpreter.getOutputTensor(0).type;
    print('Output Shape: \$outputShape, Type: \$outputType');
  } catch (e) {
    print('Error: \$e');
  }
}
