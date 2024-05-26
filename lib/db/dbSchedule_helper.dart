
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jadwali_test_1/modules/Task.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

const String collectionSchedule = "Schedules";
const String collectionTasks = "Tasks";

class DbScheduleHelper {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<String> createSchedule() async {
    //create a schedule document and send back document id 
     final doc = _db.collection(collectionSchedule).doc();
     doc.set({'status': 'new'});
     return doc.id; 
  }
  
  static Future<void> addTaskDb(STask newTask, String schedule_id, File? TaskImage, File? TaskAudio,) async {

    final scheduleDocRef = _db.collection(collectionSchedule).doc(schedule_id);
    final tasksDocRef = scheduleDocRef.collection(collectionTasks).doc();// creating a subcollection tasks and adding a document to it 
    newTask.id = tasksDocRef.id;

    //sending picture to firbase storage and retriving its url 
    if (TaskImage != null) {
    // Upload to Firebase Storage
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child('uploads/$fileName');
      UploadTask uploadTask = ref.putFile(TaskImage);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await snapshot.ref.getDownloadURL();
      newTask.imageURL = downloadURL;

    } catch (e) {
      print("Error: $e");
    }
  }

  // if (TaskAudio != null) {
  //   // Upload to Firebase Storage
  //   try {
  //     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //     Reference ref = FirebaseStorage.instance.ref().child('uploads/audio/$fileName');
  //     UploadTask uploadTask = ref.putFile(TaskAudio);
  //     TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
  //     String downloadURL = await snapshot.ref.getDownloadURL();
  //     newTask.audioURL = downloadURL;

  //   } catch (e) {
  //     print("Error: $e");
  //   }
  // }
  if (TaskAudio != null) {
    // Upload to Firebase Storage
    try {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref = FirebaseStorage.instance.ref().child('uploads/audio/$fileName');

        // Create custom metadata to specify the content type
        SettableMetadata metadata = SettableMetadata(
            contentType: 'audio/m4a'  // Change according to your file type, 'audio/mpeg' for mp3, 'audio/wav' for wav files, etc.
        );

        UploadTask uploadTask = ref.putFile(TaskAudio, metadata);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
        String downloadURL = await snapshot.ref.getDownloadURL();
        newTask.audioURL = downloadURL;

    } catch (e) {
        print("Error: $e");
    }
}

    return tasksDocRef.set(newTask.toMap());
  }

  static Future<void> deleteTaskDb(String task_id, String schedule_id) async {

    _db.collection(collectionSchedule).doc(schedule_id).collection(collectionTasks).doc(task_id).delete();
  }


  static Stream<QuerySnapshot<Map<String, dynamic>>>
      getAllTasksDb(String schedule_id) {

        final scheduleDocRef = _db.collection(collectionSchedule).doc(schedule_id);
        final tasksCollRef = scheduleDocRef.collection(collectionTasks);

        return tasksCollRef.snapshots();

  }



static Future<File> getImageFile(String imageUrl, String id) async {
  
  
    final tempDir = await getApplicationDocumentsDirectory();
      var directory = Directory('${tempDir.path}/$id.jpg');
      bool directoryExists = await directory.exists();
    if(!directoryExists){
  //final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/$id.jpg';
    final response = await http.get(Uri.parse(imageUrl));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return file;
}
else {
  final file = File('${tempDir.path}/$id.jpg');
    //await file.writeAsBytes(response.bodyBytes);
    return file;

}
  // final tempDir = await getTemporaryDirectory();
  //   final filePath = '${tempDir.path}/$id.jpg';
  //   final response = await http.get(Uri.parse(imageUrl));
  //   final file = File(filePath);
  //   await file.writeAsBytes(response.bodyBytes);
  //   return file;
}


static Future<File> getAudioFile(String audioUrl, String id) async {
  

  final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/$id.m4a';
    final response = await http.get(Uri.parse(audioUrl));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return file;
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