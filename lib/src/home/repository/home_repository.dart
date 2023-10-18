import 'package:benaiah_mobile_app/src/home/models/local_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeRepository {
  const HomeRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Future<LocalUser> fetchUserData() async {
    final userData =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    final user = LocalUser(
      id: _auth.currentUser!.uid,
      isStaff: userData['isStaff'] as bool,
    );
    final today = DateTime.now().toLocal().toString().substring(0, 10);
    final todayDocumentRef = await _firestore
        .collection('dailyMotivation')
        .where('date', isEqualTo: today)
        .get();
    if (todayDocumentRef.docs.isEmpty) return user;

    final userMotivationDoc = await _firestore
        .collection('dailyMotivation')
        .doc(todayDocumentRef.docs.first.id)
        .collection('individualRecords')
        .doc(_auth.currentUser!.uid)
        .get();

    if (!userMotivationDoc.exists) return user;

    return user.copyWith(
      motivationLevelToday:
          (userMotivationDoc['motivationLevel'] as num).toInt(),
    );
  }

  //  I don't think using firestore's timestamp is the best case here because
  //  if I use it's timestamp, it means all users will be using the same
  //  timezone, wouldn't it?, if I upload a motivation level using the server
  //  time, then, what if the current user is in saturday, but server time
  //  UTC is in sunday? or vice versa, then what? user's logs will show they
  //  haven't logged anything for saturday, so, I think I prefer they use
  //  their local time, because this way, even if other people have logged
  //  for sunday, and this person is still in saturday, they will still be
  //  able to log for their saturday motivation level, which for their
  //  timezone is "today"
  Future<void> submitMotivationLevel(int motivationLevel) async {
    final documentReference =
        await _firestore.collection('dailyMotivation').add({
      'date': DateTime.now().toLocal().toString().substring(0, 10),
    });

    await _firestore
        .collection('dailyMotivation')
        .doc(documentReference.id)
        .collection('individualRecords')
        .doc(_auth.currentUser!.uid).set({'motivationLevel': motivationLevel});
  }
}
