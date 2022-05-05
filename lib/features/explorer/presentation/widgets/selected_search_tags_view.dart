import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/search_tags_provider.dart';
import 'search_tag.dart';

class SelectedSearchTagsView extends StatelessWidget {
  const SelectedSearchTagsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchTagsProvider>(
      builder: (ctx, provider, child) {
        return Wrap(
          children: provider.searchTags.map((e) => SearchTag(tag: e)).toList(),
        );
      },
    );
  }
}
