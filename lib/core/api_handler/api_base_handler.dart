import 'dart:convert';

import 'package:http/http.dart' as http;

import '../errors/errors.dart';

abstract class ApiHandler {
  Future<dynamic> get(String url);
  Future<dynamic> post(String url, {Map<String, dynamic> body});
  Future<dynamic> put(String url, {Map<String, dynamic> body});
  Future<dynamic> patch(String url, {Map<String, dynamic> body});
}

class SimpleApiHandler implements ApiHandler {
  @override
  Future post(String url, {Map<String, dynamic> body = const {}}) async {
    final response = await http.post(Uri.parse(url), body: body);

    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw ServerException(
        message: 'An Error happens while trying to fetch images',
      );
    }
  }

  @override
  Future get(String url) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future patch(String url, {Map<String, dynamic> body = const {}}) {
    // TODO: implement patch
    throw UnimplementedError();
  }

  @override
  Future put(String url, {Map<String, dynamic> body = const {}}) {
    // TODO: implement put
    throw UnimplementedError();
  }
}
