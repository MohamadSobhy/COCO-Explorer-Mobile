import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/explorer/presentation/pages/home_page.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: servLocator<SearchTagsProvider>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}
