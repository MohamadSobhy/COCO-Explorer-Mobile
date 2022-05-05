import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/coco_search_result.dart';
import '../repositories/search_repository.dart';

class SearchCocoDataset extends UseCase<CocoSearchResult, List<int>> {
  final SearchRepository repository;

  SearchCocoDataset({required this.repository});

  @override
  Future<Either<Failure, CocoSearchResult>> call(List<int> params) {
    return repository.searchCOCODataset(params);
  }
}
