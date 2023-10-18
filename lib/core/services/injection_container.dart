import 'package:benaiah_mobile_app/src/admin/controller/admin_controller.dart';
import 'package:benaiah_mobile_app/src/admin/repository/admin_repository.dart';
import 'package:benaiah_mobile_app/src/auth/controller/auth_controller.dart';
import 'package:benaiah_mobile_app/src/auth/repository/auth_repository.dart';
import 'package:benaiah_mobile_app/src/home/controller/home_controller.dart';
import 'package:benaiah_mobile_app/src/home/repository/home_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initAuth();
  await _initHome();
  await _initAdmin();
}

Future<void> _initAuth() async {
  sl
    ..registerLazySingleton(() => AuthenticationController(sl()))
    ..registerLazySingleton(
      () => AuthRepository(
        firestore: sl(),
        auth: sl(),
      ),
    )
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseAuth.instance);
}

Future<void> _initHome() async {
  sl
    ..registerLazySingleton(() => HomeController(sl()))
    ..registerLazySingleton(
      () => HomeRepository(
        firestore: sl(),
        auth: sl(),
      ),
    );
}

Future<void> _initAdmin() async {
  sl
    ..registerLazySingleton(() => AdminController(sl()))
    ..registerLazySingleton(() => AdminRepository(sl()));
}
