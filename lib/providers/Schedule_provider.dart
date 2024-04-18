
// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jadwali_test_1/db/dbSchedule_helper.dart';
import 'package:jadwali_test_1/modules/Task.dart';

class ScheduleProvider with ChangeNotifier{

List<Task> taskList = [];

//add task to db
Future<void> addTask(String name, DateTime startTime, DateTime endTime, String repetition, Color color, String scheduleid) async {
   
   // Timestamp TSdob = Timestamp.fromDate(dob);
    
    final newTask = Task(name: name, startTime: startTime, endTime: endTime, repetition: repetition, color: color);
    
    return DbScheduleHelper.addTaskDb(newTask,scheduleid);
  }

//remove task from db 

Future<void> deleteTask(String task_id, String schedule_id)async{

DbScheduleHelper.deleteTaskDb(task_id, schedule_id);

}

//getall tasks 

getTasks(String schedule_id){
  DbScheduleHelper.getAllTasksDb(schedule_id).listen((snapshot) { 
    taskList = List.generate(snapshot.docs.length, (index) => Task.fromMap(snapshot.docs[index].data()));
      notifyListeners();

  });
}




}