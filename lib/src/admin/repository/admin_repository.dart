import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AdminRepository {
  AdminRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Future<double> calculateAverageMotivationForDay(
    DateTime date,
  ) async {
    final formattedDate = date.toLocal().toString().substring(0, 10);

    final dailyMotivationRef = _firestore.collection('dailyMotivation');
    final querySnapshot =
        await dailyMotivationRef.where('date', isEqualTo: formattedDate).get();

    if (querySnapshot.docs.isEmpty) {
      return 0.0; // No records for this day.
    }

    var totalMotivation = 0.0;
    var recordCount = 0;

    // Iterate over the documents and sub-collection.
    for (final document in querySnapshot.docs) {
      final individualRecordsRef =
          dailyMotivationRef.doc(document.id).collection('individualRecords');

      final recordsSnapshot = await individualRecordsRef.get();

      for (final recordDoc in recordsSnapshot.docs) {
        final userMotivation = recordDoc.data()['motivationLevel'] as num;
        totalMotivation += userMotivation;
        recordCount++;
      }
    }

    if (recordCount == 0) {
      return 0.0; // No records for the current day.
    }

    final averageMotivation = totalMotivation / recordCount;
    return averageMotivation;
  }

  Future<Map<String, double>> calculateAveragesForLast7Days() async {
    final today = DateTime.now();
    final last7Days =
        List.generate(7, (index) => today.subtract(Duration(days: index)));

    final results = <String, double>{};

    // Define the function to calculate the average for a single day.
    Future<void> calculateAverageForDay(DateTime date) async {
      final formattedDate = date.toLocal().toString().substring(0, 10);
      final average = await calculateAverageMotivationForDay(date);
      results[formattedDate] = average;
    }

    // Use compute to run the calculations in parallel.
    await Future.wait(
      last7Days.map((date) => compute(calculateAverageForDay, date)),
    );

    return results;
  }
}
