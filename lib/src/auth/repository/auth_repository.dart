import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  const AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Future<void> register(String fullName) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
      'id': _auth.currentUser!.uid,
      'fullName': fullName,
      'isStaff': false,
      'isStudent': true,
    });
  }
}
