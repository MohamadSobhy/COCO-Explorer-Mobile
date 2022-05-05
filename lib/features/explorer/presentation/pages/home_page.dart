import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/constant_data.dart';
import '../delegates/coco_search_delegate.dart';
import '../providers/search_tags_provider.dart';
import '../widgets/selected_search_tags_view.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  final _queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _queryController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'tags',
                        // enabled: false,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15),
                      ),
                      onTap: () => _openSearchDelegate(context),
                      onChanged: (String query) => _openSearchDelegate(context),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      final tags = Provider.of<SearchTagsProvider>(context,
                              listen: false)
                          .searchTags;

                      late List<int> tagsIds;

                      if (tags.isNotEmpty) {
                        tagsIds = categoryToId.entries
                            .where((element) => tags.contains(element.key))
                            .map((e) => e.value)
                            .toList();
                      } else {
                        tagsIds = [-1];
                      }

                      log(tagsIds.toString());
                    },
                    child: Text('Search'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.purple,
                      primary: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SelectedSearchTagsView(),
          ],
        ),
      ),
    );
  }

  void _openSearchDelegate(context) async {
    final tag = await showSearch(
      context: context,
      delegate: COCOSearchDelegate(),
      query: _queryController.text,
    );

    _queryController.clear();
    if (tag != null && tag is String) {
      Provider.of<SearchTagsProvider>(context, listen: false)
          .addNewSearchTag(tag);
    }
  }
}
