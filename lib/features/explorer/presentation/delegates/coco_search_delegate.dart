import 'package:flutter/material.dart';

import '../../../../core/constants/constant_data.dart';

class COCOSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) => null;

  @override
  Widget? buildLeading(BuildContext context) => null;

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    final categories = categoryToId.keys.toList();

    final searchResult = categories
        .where((element) => element.contains(query) || query.contains(element))
        .toList();

    return ListView.builder(
      itemCount: searchResult.length,
      itemBuilder: (ctx, index) {
        return ListTile(
          title: Text(searchResult[index]),
          onTap: () {
            Navigator.of(context).pop(searchResult[index]);
          },
        );
      },
    );
  }
}
