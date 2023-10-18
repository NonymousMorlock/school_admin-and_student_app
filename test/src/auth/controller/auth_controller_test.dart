
// Mock the dependencies as my unit follows the Dependency Inversion
// Principle of the SOLID principles

import 'package:benaiah_mobile_app/src/auth/controller/auth_controller.dart';
import 'package:benaiah_mobile_app/src/auth/repository/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  // Setting up the test dependencies
  late AuthRepository repo;
  late AuthenticationController controller;

  setUp(() {
    repo = MockAuthRepository();
    controller = AuthenticationController(repo);
  });

  group('register', () {
    test('should call the [AuthRepository.register]', () async {
      // Arrange
      // for our arrangement, we want to stub the call to `register`
      when(() => repo.register(any())).thenAnswer((_) async => Future.value());

      // Act
      // we don't need to get the result of the call, as it returns void
      await controller.register('fullName');

      // Assert
      // we verify that the call was made to the dependency(repository)
      // .register and  that it was called with the same argument as was
      // passed to the  controller.register
      verify(() => repo.register('fullName')).called(1);
      // we also make sure the call was not made more than once


      // We verify there's no more interaction with the dependency after we
      // get our result
      verifyNoMoreInteractions(repo);
    });
  });
}
