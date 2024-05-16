import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jadwali_test_1/modules/stressEvent.dart';

const String collectionEvent = "Stress_Event";

class DbReportsHelper {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> recordStressEvent(StressEvent e) async {
    final doc = _db.collection(collectionEvent).doc();

    e.id = doc.id;

    doc.set(e.toMap());
  }
}
