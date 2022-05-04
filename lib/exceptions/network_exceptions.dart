class NetworkException implements Exception {
  final String? msg;

  const NetworkException([this.msg]);

  @override
  String toString() => msg ?? 'Network Error';
}
