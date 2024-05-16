import 'package:cloud_firestore/cloud_firestore.dart';

const String eventID = "event_id";
const String eventTime = "event_time";
const String eventTaskID = "task_id";
const String eventIsStressed = "is_stressed";

class StressEvent {
  late String? id;
  final Timestamp time;
  final String taskId;
  final bool isStressed;

  StressEvent(
      {this.id,
      required this.time,
      required this.isStressed,
      required this.taskId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      eventID: id,
      eventTime: time,
      eventTaskID: taskId,
      eventIsStressed: isStressed
    };
  }

  factory StressEvent.fromMap(Map<String, dynamic> map) => StressEvent(
        id: map[eventID],
        time: map[eventID],
        isStressed: map[eventIsStressed],
        taskId: map[eventID],
      );
}
