import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/coco_search_result.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/coco_search_remote_darasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  final CocoSearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CocoSearchResult>> searchCOCODataset(
    List<int> categoryIds, {
    int page = 1,
  }) async {
    try {
      final result =
          await remoteDataSource.searchCocoDataset(categoryIds, page: page);

      return Right(result);
    } on ServerException catch (err) {
      return Left(ServerFailure(message: err.message));
    } on NetworkException catch (err) {
      return Left(ServerFailure(message: err.message));
    }
    // catch (err) {
    //   return Left(ServerFailure(message: err.toString()));
    // }
  }
}
