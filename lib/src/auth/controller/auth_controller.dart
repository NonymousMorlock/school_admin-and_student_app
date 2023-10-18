import 'package:benaiah_mobile_app/src/auth/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationController {
  const AuthenticationController(this._repository);

  final AuthRepository _repository;

  Future<void> register(String fullName) async =>
      _repository.register(fullName);
}
