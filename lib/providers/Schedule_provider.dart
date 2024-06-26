// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jadwali_test_1/db/dbSchedule_helper.dart';
import 'package:jadwali_test_1/modules/Task.dart';
import 'package:path_provider/path_provider.dart';

class ScheduleProvider with ChangeNotifier {
  List<STask> taskList = [];
  List<STask> tasksOfTheDayList = [];

//add task to db
  Future<void> addTask(
      String name,
      DateTime startTime,
      DateTime endTime,
      String repetition,
      Color color,
      String scheduleid,
      File? TaskImage,
      File? TaskAudio) async {
    // Timestamp TSdob = Timestamp.fromDate(dob);

    final newTask = STask(
        name: name,
        startTime: startTime,
        endTime: endTime,
        repetition: repetition,
        color: color);
    DbScheduleHelper.addTaskDb(newTask, scheduleid, TaskImage, TaskAudio);

    return notifyListeners();
  }

//remove task from db

  Future<void> deleteTask(String task_id, String schedule_id) async {
    DbScheduleHelper.deleteTaskDb(task_id, schedule_id);
  }

//getall tasks

  getTasks(String schedule_id) {
    DbScheduleHelper.getAllTasksDb(schedule_id).listen((snapshot) async {
      taskList = List.generate(snapshot.docs.length,
          (index) => STask.fromMap(snapshot.docs[index].data()));

      //     for (STask task in taskList) {
      //   if (task.imageURL != null) {
      //     String url = task.imageURL!;
      //     task.imageFile = await DbScheduleHelper.getImageFile(url, task.id!);
      //   }
      // }
      notifyListeners();
    });
  }

  getTasksOfTheDay(String schedule_id) {
    DbScheduleHelper.getAllTasksDb(schedule_id).listen((snapshot) async {
      taskList = List.generate(snapshot.docs.length,
          (index) => STask.fromMap(snapshot.docs[index].data()));
      final List<String> weekDays = [
        'الأحد',
        'الاثنين',
        'الثلاثاء',
        'الأربعاء',
        'الخميس',
        'الجمعة',
        'السبت',
      ];

      DateTime today = DateTime.now();

      tasksOfTheDayList = taskList.where((task) {
        // Check if the task repeats every day
        if (task.repetition == 'كل يوم') {
          return true;
        }
        // Check if the selected day matches any repetition day of the task
        if (task.repetition.contains(weekDays[(today.weekday + 7) % 7])) {
          return true;
        }
        return false;
      }).toList();

      tasksOfTheDayList.sort((a, b) {
        int compareHour = a.startTime.hour.compareTo(b.startTime.hour);
        if (compareHour == 0) {
          // if hours are equal, then compare minutes
          return a.startTime.minute.compareTo(b.startTime.minute);
        }
        return compareHour;
      });

      for (STask task in tasksOfTheDayList) {
        if (task.imageURL != null) {
          String url = task.imageURL!;
          task.imageFile = await DbScheduleHelper.getImageFile(url, task.id!);
        }
      }

      for (STask task in tasksOfTheDayList) {
        if (task.audioURL != null) {
          String url = task.audioURL!;
          task.audioFile = await DbScheduleHelper.getAudioFile(url, task.id!);
          //task.localAudioPath?.writeAsBytes(await task.audioFile!.readAsBytes());
          

      //Directory appDocDir = await getApplicationDocumentsDirectory();
      //String localFilePath = '${appDocDir.path}/temp.m4a'; // Provide a desired local file name
      
     // await task.audioFile!.copy(localFilePath);

      //task.localAudioPath = localFilePath;
       task.localAudioPath = task.audioFile!.path;
      
      // task.localAudioPath = File(localFilePath);
      // await task.localAudioPath!.writeAsBytes(await  task.audioFile!.readAsBytes());
      

      // Directory appDocDir = await getApplicationDocumentsDirectory();
      // String _localFilePath = '${appDocDir.path}/$url';
      
      // File task.localAudioPath = File(_localFilePath);
      // if (!task.localAudioPath.existsSync()) {
      //   await .writeToFile(audioFile);
      //   }
      }

      notifyListeners();
    }});
  }
}
