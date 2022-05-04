import 'network_exceptions.dart';

class UnAuthorised extends NetworkException {
  const UnAuthorised([String? msg]) : super(msg);

  @override
  String toString() => msg ?? 'UnAuthorised Error';
}
