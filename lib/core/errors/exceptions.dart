/// Base class for all business-logic exceptions.
/// We use exceptions to handle errors in the Data layer,
/// which are then caught and mapped to Failures in the Repository.
class ServerException implements Exception {
  final String message;
  ServerException({this.message = 'Server error occurred'});
}

class CacheException implements Exception {
  final String message;
  CacheException({this.message = 'Cache error occurred'});
}
