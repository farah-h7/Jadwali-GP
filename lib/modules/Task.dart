import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jadwali_test_1/db/dbSchedule_helper.dart';

const String taskId = 'id';
const String taskName =  'name';
const String taskStartTime = 'start_time';
const String taskEndTime = 'end_time';
const String taskRepetition = 'repititoin';
const String taskColor = 'color';
const String taskAudio = 'audio_ref';
const String taskPicture = 'picture_ref';
const String taskVideo = 'video_ref';

class STask {
  String? id; 
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final String repetition;
  final Color color;
  String? imageURL;// image will be a URL, get from firestore
  File? imageFile;

  STask({
    this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.repetition,
    required this.color,
    this.imageURL,
    this.imageFile,
  });
 
//send map to db 
  Map <String, dynamic> toMap(){

    String colorString = '0x${color.value.toRadixString(16).padLeft(8, '0')}'; // Convert to hexadecimal string
    // print("Color to String: $colorString");
    return <String, dynamic>{
      //db,object
      taskId: id,
      taskName: name,
      taskStartTime: Timestamp.fromDate(startTime),
      taskEndTime: Timestamp.fromDate(endTime),
      taskRepetition: repetition,
      taskColor: colorString,
      taskPicture: imageURL,

    };
  }


//retrive map from db 
 factory STask.fromMap(Map<String, dynamic> map) {

  Timestamp start = map[taskStartTime];
  Timestamp end = map[taskEndTime];
  String c = map[taskColor];

  int colorInt = int.parse(c);
  Color convertedColor = Color(colorInt);

  ///retrive image url and file 
  
  //String ImagePath = map[taskPicture];
  //File imageF =   await DbScheduleHelper.getImageFile(ImagePath);

  return STask(
          //object, dbTask
          id: map[taskId],
          name: map[taskName],
          startTime: start.toDate(),
          endTime: end.toDate(),
          repetition: map[taskRepetition],
          color:convertedColor,
          imageURL: map[taskPicture],
          //imageFile: await DbScheduleHelper.getImageFile(ImagePath);,          
        );
 }
}
