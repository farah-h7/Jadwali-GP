// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:jadwali_test_1/db/dbSchedule_helper.dart';
import 'package:jadwali_test_1/db/db_helper.dart';
import 'package:jadwali_test_1/modules/child.dart';

class childProvider with ChangeNotifier {
  
  List<Child> childList = [];

  String generateUniqueCode(int length)  {
  const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  String code;

    code = '';
    for (int i = 0; i < length; i++) {
      code += characters[Random().nextInt(characters.length)];
    }  

  return code;
}
//adds child to database
  Future<void> addChildDb(String name, String gender, DateTime dob) async {
  
  // add user to db 
    final String ucode =  generateUniqueCode(6);
    Timestamp TSdob = Timestamp.fromDate(dob);

    final String scheduleID = await DbScheduleHelper.createSchedule();
    
    final newChild = Child(name: name, dob:  TSdob , gender: gender, ucode: ucode, scheduleID: scheduleID );
    return DbHelper.addChildDb(newChild);
  }

  getAllChildren() {
    DbHelper.getAllChildren().listen((snapshot) {
      childList = List.generate(snapshot.docs.length,
          (index) => Child.fromMap(snapshot.docs[index].data()));
    notifyListeners();
    });
  }

 getAllChildrenwithP() {
    DbHelper.getAllChildrenWithSpecificField().listen((snapshot) {
      childList = List.generate(snapshot.docs.length,
          (index) => Child.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }



}
