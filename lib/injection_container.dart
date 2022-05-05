import 'package:get_it/get_it.dart';

import 'features/explorer/presentation/providers/search_tags_provider.dart';

final servLocator = GetIt.instance;

void init() {
  //! Search Tags Provider
  servLocator.registerLazySingleton(() => SearchTagsProvider());
}
