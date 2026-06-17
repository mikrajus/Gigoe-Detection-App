import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../../../core/network/network_info.dart';
import '../../domain/entities/caries.dart';
import '../../domain/repositories/predict_repository.dart';
import '../datasources/remote_data_source.dart';
import '../datasources/predict_local_data_source_impl.dart';

class PredictRepositoryImpl implements PredictRepository {
  final PredictRemoteDataSource remoteDataSource;
  final PredictLocalDataSourceImpl localDataSource;
  final NetworkInfo networkInfo;

  PredictRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Caries>> frontImageClassification(
    String imageFront,
  ) {
    return _hybridClassification(
      () => remoteDataSource.frontImageClassification(imageFront),
      () => localDataSource.frontImageClassification(imageFront),
    );
  }

  @override
  Future<Either<Failure, Caries>> leftImageClassification(String imageLeft) {
    return _hybridClassification(
      () => remoteDataSource.leftImageClassification(imageLeft),
      () => localDataSource.leftImageClassification(imageLeft),
    );
  }

  @override
  Future<Either<Failure, Caries>> rightImageClassification(String imageRight) {
    return _hybridClassification(
      () => remoteDataSource.rightImageClassification(imageRight),
      () => localDataSource.rightImageClassification(imageRight),
    );
  }

  @override
  Future<Either<Failure, Caries>> upperImageClassification(String imageUpper) {
    return _hybridClassification(
      () => remoteDataSource.upperImageClassification(imageUpper),
      () => localDataSource.upperImageClassification(imageUpper),
    );
  }

  @override
  Future<Either<Failure, Caries>> lowerImageClassification(String imageLower) {
    return _hybridClassification(
      () => remoteDataSource.lowerImageClassification(imageLower),
      () => localDataSource.lowerImageClassification(imageLower),
    );
  }

  Future<Either<Failure, Caries>> _hybridClassification(
    Future Function() remoteFunction,
    Future Function() localFunction,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteFunction();
        return Right(result.toEntity());
      } on ServerException {
        // Fallback to local if server fails
        final result = await localFunction();
        return Right(result.toEntity());
      } on SocketException {
        // Fallback to local if connection fails
        final result = await localFunction();
        return Right(result.toEntity());
      }
    } else {
      try {
        final result = await localFunction();
        return Right(result.toEntity());
      } catch (e) {
        return const Left(ServerFailure('Local Inference Failed'));
      }
    }
  }

  @override
  Future<Either<Failure, Uint8List>> imgFrontResponse(String imgFront) {
    return _hybridImageResponse(
      () => remoteDataSource.imageFrontResponse(imgFront),
      () => localDataSource.imageFrontResponse(imgFront),
    );
  }

  @override
  Future<Either<Failure, Uint8List>> imgLeftResponse(String imgLeft) {
    return _hybridImageResponse(
      () => remoteDataSource.imageLeftResponse(imgLeft),
      () => localDataSource.imageLeftResponse(imgLeft),
    );
  }

  @override
  Future<Either<Failure, Uint8List>> imgLowerResponse(String imgLower) {
    return _hybridImageResponse(
      () => remoteDataSource.imageLowerResponse(imgLower),
      () => localDataSource.imageLowerResponse(imgLower),
    );
  }

  @override
  Future<Either<Failure, Uint8List>> imgRightResponse(String imgRight) {
    return _hybridImageResponse(
      () => remoteDataSource.imageRightResponse(imgRight),
      () => localDataSource.imageRightResponse(imgRight),
    );
  }

  @override
  Future<Either<Failure, Uint8List>> imgUpperResponse(String imgUpper) {
    return _hybridImageResponse(
      () => remoteDataSource.imageUpperResponse(imgUpper),
      () => localDataSource.imageUpperResponse(imgUpper),
    );
  }

  Future<Either<Failure, Uint8List>> _hybridImageResponse(
    Future Function() remoteFunction,
    Future Function() localFunction,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteFunction();
        return Right(result);
      } on ServerException {
        // Fallback to local
        final result = await localFunction();
        return Right(result);
      } on SocketException {
        final result = await localFunction();
        return Right(result);
      }
    } else {
      try {
        final result = await localFunction();
        return Right(result);
      } catch (e) {
        return const Left(ServerFailure('Local Annotation Failed'));
      }
    }
  }
}
