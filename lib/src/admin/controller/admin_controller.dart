
import 'package:benaiah_mobile_app/src/admin/repository/admin_repository.dart';

class AdminController {
  const AdminController(this._repository);

  final AdminRepository _repository;

  Future<Map<String, double>> calculateAveragesForLast7Days() => _repository
      .calculateAveragesForLast7Days();
}
