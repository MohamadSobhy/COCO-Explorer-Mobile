import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/coco_search_result.dart';

abstract class SearchRepository {
  Future<Either<Failure, CocoSearchResult>> searchCOCODataset(
    List<int> categoryIds, {
    int page = 0,
  });
}
