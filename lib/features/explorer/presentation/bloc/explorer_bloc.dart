import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/coco_search_result.dart';
import '../../domain/usecases/search_coco_dataset.dart';

part 'explorer_event.dart';
part 'explorer_state.dart';

class ExplorerBloc extends Bloc<ExplorerEvent, ExplorerState> {
  final SearchCocoDataset searchCocoDataset;

  ExplorerBloc({required this.searchCocoDataset})
      : super(const ExplorerInitial()) {
    on<SearchCocoDatasetEvent>((event, emit) async {
      emit(ExplorerLoadingState(page: event.page));

      final resultEither = await searchCocoDataset(
        SearchParams(categoryIds: event.categoryIds, page: event.page),
      );

      resultEither.fold(
        (failure) {
          if (failure is ServerFailure) {
            emit(ExplorerServerErrorState(
              message: failure.message,
              page: event.page,
            ));
          } else if (failure is NetworkFailure) {
            emit(ExplorerNetworkErrorState(
              message: failure.message,
              page: event.page,
            ));
          } else {
            emit(ExplorerServerErrorState(
              message: failure.message,
              page: event.page,
            ));
          }
        },
        (result) {
          emit(ExplorerResultFetchedState(
            result: result,
            page: event.page,
          ));
        },
      );
    });
  }
}
