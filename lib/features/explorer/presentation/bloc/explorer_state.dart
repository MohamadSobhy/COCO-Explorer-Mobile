part of 'explorer_bloc.dart';

abstract class ExplorerState extends Equatable {
  final int page;
  const ExplorerState({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class ExplorerInitial extends ExplorerState {
  const ExplorerInitial({int page = 1}) : super(page: page);
}

class ExplorerLoadingState extends ExplorerState {
  const ExplorerLoadingState({int page = 1}) : super(page: page);
}

class ExplorerServerErrorState extends ExplorerState {
  final String message;

  const ExplorerServerErrorState({required this.message, int page = 1})
      : super(page: page);

  @override
  List<Object?> get props => [message];
}

class ExplorerNetworkErrorState extends ExplorerState {
  final String message;

  const ExplorerNetworkErrorState({required this.message, int page = 1})
      : super(page: page);

  @override
  List<Object?> get props => [message];
}

class ExplorerResultFetchedState extends ExplorerState {
  final CocoSearchResult result;

  const ExplorerResultFetchedState({required this.result, int page = 1})
      : super(page: page);

  @override
  List<Object?> get props => [result];
}
