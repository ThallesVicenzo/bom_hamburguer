import 'package:bom_hamburguer/services/errors/failure.dart';

class GenericFailure extends Failure {
  const GenericFailure(super.message);
}

class ServiceError extends Failure {
  const ServiceError([String? message]) : super(message ?? 'Service error');
}

class DatabaseFailure extends Failure {
  const DatabaseFailure([String? message]) : super(message ?? 'Database error');
}
