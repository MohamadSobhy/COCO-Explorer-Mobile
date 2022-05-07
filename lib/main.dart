import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'features/explorer/presentation/bloc/explorer_bloc.dart';
import 'features/explorer/presentation/pages/coco_explorer_page.dart';
import 'features/explorer/presentation/providers/search_tags_provider.dart';
import 'injection_container.dart';

void main() {
  init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: servLocator<ExplorerBloc>()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: servLocator<SearchTagsProvider>(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: CocoExplorerPage(),
        ),
      ),
    );
  }
}
