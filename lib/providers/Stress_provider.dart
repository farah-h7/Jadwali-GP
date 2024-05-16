import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jadwali_test_1/db/db_reports.dart';
import 'package:jadwali_test_1/modules/stressEvent.dart';

class StressProvider with ChangeNotifier {
  void recordStressResponse(bool result, Timestamp time, String taskId) {
    StressEvent e = StressEvent(time: time, isStressed: result, taskId: taskId);

//send to db
    DbReportsHelper.recordStressEvent(e);
  }
}
