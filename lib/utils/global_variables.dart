import 'package:logger/logger.dart';

const webScreenSize = 600;

enum Status {
  initial,
  submitting,
  success,
  error;

  bool get isInitial => this == initial;
  bool get isSubmitting => this == submitting;
  bool get isSuccess => this == success;
  bool get isError => this == error;
}

final log = Logger();
