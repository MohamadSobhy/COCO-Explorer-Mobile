import 'package:flutter/material.dart';

class SearchTagsProvider extends ChangeNotifier {
  final List<String> _searchTags = [];

  void addNewSearchTag(String tag) {
    if (!_searchTags.contains(tag)) {
      _searchTags.add(tag);
      notifyListeners();
    }
  }

  void removeSearchTag(String tag) {
    if (_searchTags.contains(tag)) {
      _searchTags.remove(tag);
      notifyListeners();
    }
  }

  List<String> get searchTags => [..._searchTags];
}
