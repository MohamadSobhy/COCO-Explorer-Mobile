import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/search_tags_provider.dart';

class SearchTag extends StatelessWidget {
  final String tag;

  const SearchTag({Key? key, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<SearchTagsProvider>(context, listen: false)
            .removeSearchTag(tag);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.pink.withOpacity(0.15),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          tag,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(color: Colors.purple),
        ),
      ),
    );
  }
}
