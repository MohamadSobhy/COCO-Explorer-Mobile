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
        return Container(
          constraints: const BoxConstraints(
            maxHeight: 120,
          ),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.05),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              padding: provider.searchTags.isEmpty
                  ? EdgeInsets.zero
                  : const EdgeInsets.all(8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    provider.searchTags.map((e) => SearchTag(tag: e)).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
