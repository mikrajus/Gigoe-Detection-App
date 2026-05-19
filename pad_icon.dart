import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final bytes = File('assets/images/logo2.png').readAsBytesSync();
  final original = img.decodeImage(bytes)!;
  
  final newWidth = (original.width * 2.0).round();
  final newHeight = (original.height * 2.0).round();
  
  // Create a transparent image
  final padded = img.Image(width: newWidth, height: newHeight, numChannels: 4);
  
  // Draw original image onto padded image centered
  img.compositeImage(padded, original, dstX: (newWidth - original.width) ~/ 2, dstY: (newHeight - original.height) ~/ 2);
  
  File('assets/images/logo2_padded.png').writeAsBytesSync(img.encodePng(padded));
  print('Done');
}
