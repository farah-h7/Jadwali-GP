

// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jadwali_test_1/modules/Task.dart';

final String collectionSchedule = "Schedules";
final String collectionTasks = "Tasks";

class DbScheduleHelper {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<String> createSchedule() async {
    //create a schedule document and send back document id 
     final doc = _db.collection(collectionSchedule).doc();
     doc.set({'status': 'new'});
     return doc.id; 
  }
  
  static Future<void> addTaskDb(Task newTask, String schedule_id) async {

    final scheduleDocRef = _db.collection(collectionSchedule).doc(schedule_id);
    final tasksDocRef = scheduleDocRef.collection(collectionTasks).doc();// creating a subcollection tasks and adding a document to it 
    newTask.id = tasksDocRef.id;
    return tasksDocRef.set(newTask.toMap());
  }

  static Future<void> deleteTaskDb(String task_id, String schedule_id) async {

    final scheduleDocRef = _db.collection(collectionSchedule).doc(schedule_id);
    final tasksDocRef = scheduleDocRef.collection(collectionTasks).doc(task_id);// creating a subcollection tasks and adding a document to it 
    tasksDocRef.delete();
  }


  static Stream<QuerySnapshot<Map<String, dynamic>>>
      getAllTasksDb(String schedule_id) {

        final scheduleDocRef = _db.collection(collectionSchedule).doc(schedule_id);
        final tasksCollRef = scheduleDocRef.collection(collectionTasks);

        return tasksCollRef.snapshots();

  }


  //   static Stream<QuerySnapshot<Map<String, dynamic>>>
  //     getTasksOfTheDay(String schedule_id) {

  //       final scheduleDocRef = _db.collection(collectionSchedule).doc(schedule_id);
  //       final tasksCollRef = scheduleDocRef.collection(collectionTasks).get().then((snapshot) {
  //       var filteredDocs = snapshot.docs.where((doc) =>
  //       doc.data()['repitition'].contains('searchSubstring'));
  //     // Handle filtered documents
  //   });


  //       return tasksCollRef;

  // }



}