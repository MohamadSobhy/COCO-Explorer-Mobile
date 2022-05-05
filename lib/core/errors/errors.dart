class ServerException implements Exception {
  final String message;

  ServerException({required this.message});
}

class NetworkException implements Exception {
  final String message;

  NetworkException({required this.message});
}
