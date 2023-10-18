import 'package:benaiah_mobile_app/src/home/models/local_user.dart';
import 'package:benaiah_mobile_app/src/home/repository/home_repository.dart';

class HomeController {
  const HomeController(this._repository);

  final HomeRepository _repository;

  Future<LocalUser> fetchUserData() async => _repository.fetchUserData();

  Future<void> submitMotivationLevel(int motivationLevel) async =>
      _repository.submitMotivationLevel(motivationLevel);
}
