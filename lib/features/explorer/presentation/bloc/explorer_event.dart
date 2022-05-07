part of 'explorer_bloc.dart';

abstract class ExplorerEvent extends Equatable {
  const ExplorerEvent();
}

class SearchCocoDatasetEvent extends ExplorerEvent {
  final List<int> categoryIds;
  final int page;

  const SearchCocoDatasetEvent({required this.categoryIds, this.page = 1});

  @override
  List<Object?> get props => [categoryIds, page];
}
