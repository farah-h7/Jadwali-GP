import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

const String collectionChild = "child";

const String childId = 'id';
const String childParentId = 'parent_id';
const String childName = 'name';
const String childDob = 'birth_date';
const String childAge = 'age';
const String childGender = 'gender';
const String childUcode = 'ucode';
const String childBraceletId = 'braceletid';
const String childThreshold = 'threshold';
const String childScheduleId = 'schedule_id';
//DateTime newChildDob = DateTime.now();

class Child {
  String? id;
  final String name;

  ///* final */DateTime? dob;
  //String? dob;
  Timestamp? dob;
  late DateTime dtDob;
  late String sDob;
  late int age; // late: will be initialized later
  final String gender;
  String? ucode;
  String? braceletId;
  late int threshold;
  late String? parentID;
  final String scheduleID;

  int calculateAge(DateTime dob) {
    final now = DateTime.now();
    final difference = now.difference(dob);

    return (difference.inDays / 365).floor();
  }

  int calculateThreshold(int age) {
    ///insert code for calculating threshold
    return 100;
  }

//constructor
  Child({
    this.id,
    this.parentID,
    required this.name,
    this.dob,
    required this.gender,
    required this.ucode,
    required this.scheduleID,
  }) {
    dtDob = dob!.toDate();
    sDob = DateFormat('yyyy-MM-dd').format(dtDob);
    age = calculateAge(dtDob);
    threshold = calculateThreshold(age);
  }

// to map information to database
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      childId: id,
      childParentId: parentID,
      childName: name,
      childDob: dob,
      childAge: age,
      childGender: gender,
      childUcode: ucode,
      //childBraceletId: braceletId,
      childThreshold: threshold,
      childScheduleId: scheduleID,
    };
  }

// to retrieve map from database
  factory Child.fromMap(Map<String, dynamic> map) => Child(
        id: map[childId],
        parentID: map[childParentId],
        name: map[childName],
        dob: map[childDob],
        gender: map[childGender],
        ucode: map[childUcode],
        scheduleID: map[childScheduleId],
        //age: map[childAge],
      ); //return a child object
}

//List<ChildModel> childList = [];
