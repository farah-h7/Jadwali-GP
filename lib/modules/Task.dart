import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const String taskId = 'id';
const String taskName =  'name';
const String taskStartTime = 'start_time';
const String taskEndTime = 'end_time';
const String taskRepetition = 'repititoin';
const String taskColor = 'color';
const String taskAudio = 'audio_ref';
const String taskPicture = 'picture_ref';
const String taskVideo = 'video_ref';

class Task {
  String? id; 
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final String repetition;
  final Color color;

  Task({
    this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.repetition,
    required this.color,
  });

//send map to db 
  Map <String, dynamic> toMap(){
    return <String, dynamic>{
      //db,object
      taskId: id,
      taskName: name,
      taskStartTime: Timestamp.fromDate(startTime),
      taskEndTime: Timestamp.fromDate(endTime),
      taskRepetition: repetition,
      taskColor: color.toString(),

    };
  }

//retrive map from db 
 factory Task.fromMap(Map<String, dynamic> map) {

  Timestamp start = map[taskStartTime];
  Timestamp end = map[taskEndTime];
  String c = map[taskColor];

  int colorValue = int.parse(c.replaceAll('0x', ''), radix: 16);

  return Task(
          //object, dbTask
          id: map[taskId],
          name: map[taskName],
          startTime: start.toDate(),
          endTime: end.toDate(),
          repetition: map[taskRepetition],
          color:Color(colorValue),
          
        );
 }
}
