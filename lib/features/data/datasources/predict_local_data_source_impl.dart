import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

import '../../../core/error/exceptions.dart';
import '../models/caries_model.dart';
import 'local_ml_data_source.dart';
import 'remote_data_source.dart';

class PredictLocalDataSourceImpl implements PredictRemoteDataSource {
  final LocalMLDataSource localML;

  PredictLocalDataSourceImpl(this.localML);

  @override
  Future<CariesModel> frontImageClassification(String imageFront) {
    return localML.classifyImage(imageFront);
  }

  @override
  Future<CariesModel> leftImageClassification(String imageLeft) {
    return localML.classifyImage(imageLeft);
  }

  @override
  Future<CariesModel> rightImageClassification(String imageRight) {
    return localML.classifyImage(imageRight);
  }

  @override
  Future<CariesModel> upperImageClassification(String imageUpper) {
    return localML.classifyImage(imageUpper);
  }

  @override
  Future<CariesModel> lowerImageClassification(String imageLower) {
    return localML.classifyImage(imageLower);
  }

  @override
  Future<Uint8List> imageFrontResponse(String imgFrontRes) {
    return _annotateImageLocally(imgFrontRes);
  }

  @override
  Future<Uint8List> imageLeftResponse(String imgLeftRes) {
    return _annotateImageLocally(imgLeftRes);
  }

  @override
  Future<Uint8List> imageLowerResponse(String imgLowerRes) {
    return _annotateImageLocally(imgLowerRes);
  }

  @override
  Future<Uint8List> imageRightResponse(String imgRightRes) {
    return _annotateImageLocally(imgRightRes);
  }

  @override
  Future<Uint8List> imageUpperResponse(String imgUpperRes) {
    return _annotateImageLocally(imgUpperRes);
  }

  Future<Uint8List> _annotateImageLocally(String imagePath) async {
    try {
      return await localML.annotateImage(imagePath);
    } catch (e) {
      throw ServerException();
    }
  }
}
