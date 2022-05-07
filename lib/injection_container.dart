import 'package:get_it/get_it.dart';

import 'core/api_handler/api_base_handler.dart';
import 'core/network/network_info.dart';
import 'features/explorer/data/datasources/coco_search_remote_darasource.dart';
import 'features/explorer/data/repositories/search_repository_impl.dart';
import 'features/explorer/domain/repositories/search_repository.dart';
import 'features/explorer/domain/usecases/search_coco_dataset.dart';
import 'features/explorer/presentation/bloc/explorer_bloc.dart';
import 'features/explorer/presentation/providers/search_tags_provider.dart';

final servLocator = GetIt.instance;

void init() {
  //! Core
  servLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  servLocator.registerLazySingleton<ApiHandler>(() => SimpleApiHandler());

  //! Features ...

  //! Search Tags Provider
  servLocator.registerLazySingleton(() => SearchTagsProvider());

  //! COCO Dataset Explorer Feature
  //! Explorer Bloc
  servLocator.registerFactory(
    () => ExplorerBloc(searchCocoDataset: servLocator()),
  );

  //! SearchCocoaDataset Usecase
  servLocator.registerLazySingleton(
    () => SearchCocoDataset(repository: servLocator()),
  );

  //! Search Repository
  servLocator.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remoteDataSource: servLocator()),
  );

  //! Coca Search datasources
  servLocator.registerLazySingleton<CocoSearchRemoteDataSource>(
    () => CocoSearchRemoteDataSourceImpl(
      apiHandler: servLocator(),
      networkInfo: servLocator(),
    ),
  );
}
