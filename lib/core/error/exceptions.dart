class ServerException implements Exception {
  final String message;
  final int? status;
  ServerException({this.message = '', this.status});
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = '']);
}
