import 'package:flutter_riverpod/flutter_riverpod.dart';

final validatorProvider = Provider<Validator>((ref) {
  return Validator();
});

class Validator {
  String? validateEmail(String? email) {
    final value = email?.trim() ?? '';

    if (value.isEmpty) {
      return 'Email is required';
    }
    final regExp = RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
    if (!regExp.hasMatch(value)) {
      return 'Invalid email';
    }
    return null;
  }

  String? validatePassword(String? password) {
    final value = password?.trim() ?? '';

    if (value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    final regExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).+$');
    if (!regExp.hasMatch(value)) {
      return 'Password must contain a letter and a number';
    }
    return null;
  }
}
