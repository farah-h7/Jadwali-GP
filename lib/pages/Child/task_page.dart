import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jadwali_test_1/modules/Task.dart';
import 'package:jadwali_test_1/providers/BLConn_provider.dart';
import 'package:provider/provider.dart';

List<STask> playTasksglobal = [];
int index = 0;

///variables for heart rate monitoring

List<int> buffer = [];
String pulseData = "Waiting for heartbeat...";
int threshold = 100; //  threshold for stress detection
List<DateTime> exceedTimestamps = [];
Timer? checkTimer;
//int heartRate = 0;
DateTime? lastTimeAboveThreshold;
Duration aboveThresholdDuration = Duration.zero;
int toleranceCounter = 0;
const int toleranceLimit = 10;
Duration maxGap = const Duration(seconds: 15); // Adjust the max gap as needed

StreamSubscription<Uint8List>? _dataSubscription;

//connection!.input!.listen(onDataReceived)

class TaskDisplayPage extends StatefulWidget {
  late List<STask> playTasks = [];

  TaskDisplayPage({super.key, required this.playTasks});

  @override
  State<TaskDisplayPage> createState() => _TaskDisplayPageState();
}

class _TaskDisplayPageState extends State<TaskDisplayPage> {
  //methods
  void onDataReceived(Uint8List data) {
    // Accumulate data until delimiter is found
    for (int i = 0; i < data.length; i++) {
      if (data[i] == 44) {
        // ASCII value for ','
        pulseData = String.fromCharCodes(buffer);
        int heartRate = int.tryParse(pulseData) ?? 0;
        if (heartRate > threshold) {
          lastTimeAboveThreshold = DateTime.now();
          toleranceCounter = 0; // Reset the tolerance counter
        } else {
          toleranceCounter++;
          if (toleranceCounter > toleranceLimit) {
            lastTimeAboveThreshold =
                null; // Reset tracking after tolerance exceeded
          }
        }
        buffer.clear();
      } else {
        buffer.add(data[i]);
      }
    }
  }

  void checkForStress() {
    if (lastTimeAboveThreshold != null) {
      Duration timeSinceLastAbove =
          DateTime.now().difference(lastTimeAboveThreshold!);
      if (timeSinceLastAbove <= maxGap /*Duration(seconds: 1)*/) {
        aboveThresholdDuration += const Duration(seconds: 1);
      } else {
        aboveThresholdDuration = Duration.zero;
        //new//
        lastTimeAboveThreshold = null; // Reset tracking after significant pause
      }

      if (aboveThresholdDuration >= const Duration(minutes: 1)) {
        showStressDetectedPopup();
        aboveThresholdDuration = Duration.zero;
      }
    } else {
      aboveThresholdDuration = Duration.zero;
    }
  }

  void showStressDetectedPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Stress Detected"),
          content: const Text(
              "Your heart rate has been elevated for more than 1 minute."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                exceedTimestamps
                    .clear(); // Clear timestamps after showing the alert
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void startRecivingData() {
    _dataSubscription = Provider.of<BLConnProvider>(context, listen: false)
        .connection!
        .input!
        .listen(onDataReceived);
  }

  void stopListening() {
    _dataSubscription?.cancel();
    _dataSubscription = null;
  }

  @override
  void dispose() {
    //what happens after closing the page
    stopListening();
    checkTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (index == 0 && Provider.of<BLConnProvider>(context, listen: false).isConn) {
      startRecivingData();
    }

    checkTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => checkForStress());
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Horizontal Alignment
            mainAxisAlignment: MainAxisAlignment.center, // Vertical Alignment

            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              widget.playTasks[index].imageFile != null
                  ? Image.file(
                      widget.playTasks[index].imageFile!,
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    )
                  : Image.asset('assets/images/logo.png',
                      /*tasks[index].imagePath*/
                      width: 200,
                      height: 200),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    widget.playTasks[index].name,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // if (task.audioPath != null) ...[
              //   // Display audio player if audio path is provided
              //   // Implement audio player widget here
              //   // Placeholder for now
              //   SizedBox(height: 20),
              //   Center(child: Text('Audio Player Placeholder')),
              // ],
              const SizedBox(height: 50),
              IconButton(
                iconSize: 100,
                icon: const Icon(Icons.check_circle, color: Colors.green),
                onPressed: () {
                  // Check if there are more tasks
                  if (index < widget.playTasks.length - 1) {
                    // Move to the next task
                    setState(() {
                      index++;
                    });
                  } else {
                    index = 0;
                    // No more tasks, navigate back
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:jadwali_test_1/modules/Task.dart';

// List<STask> playTasksglobal = [];

// class TaskDisplayPage extends StatelessWidget {
//   late List<STask> playTasks = [];

//   TaskDisplayPage({super.key, required this.playTasks});

//   @override
//   Widget build(BuildContext context) {
//     playTasksglobal = playTasks;
//     return Scaffold(
//         body: TaskbyTask(
//       task: playTasks.first,
//     ));
//   }
// }

// class TaskbyTask extends StatefulWidget {
//   final STask task;

//   const TaskbyTask({super.key, required this.task});

//   @override
//   _TaskbyTaskState createState() => _TaskbyTaskState();
// }

// class _TaskbyTaskState extends State<TaskbyTask> {
//   //get playTasks => null;
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         body: Stack(children: [
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("assets/images/background.png"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Column(
//             crossAxisAlignment:
//                 CrossAxisAlignment.center, // Horizontal Alignment
//             mainAxisAlignment: MainAxisAlignment.center, // Vertical Alignment

//             // crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               widget.task.imageFile != null
//                   ? Image.file(
//                       widget.task.imageFile!,
//                       width: 300,
//                       height: 300,
//                       fit: BoxFit.cover,
//                     )
//                   : Image.asset('assets/images/logo.png',
//                       /*tasks[index].imagePath*/
//                       width: 200,
//                       height: 200),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Center(
//                   child: Text(
//                     widget.task.name,
//                     style: const TextStyle(
//                       fontSize: 36,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),

//               // if (task.audioPath != null) ...[
//               //   // Display audio player if audio path is provided
//               //   // Implement audio player widget here
//               //   // Placeholder for now
//               //   SizedBox(height: 20),
//               //   Center(child: Text('Audio Player Placeholder')),
//               // ],
//               const SizedBox(height: 50),
//               IconButton(
//                 iconSize: 100,
//                 icon: const Icon(Icons.check_circle, color: Colors.green),
//                 onPressed: () {
//                   // Check if there are more tasks
//                   if (playTasksglobal.indexOf(widget.task) <
//                       playTasksglobal.length - 1) {
//                     // Move to the next task
//                     STask nextTask = playTasksglobal[
//                         playTasksglobal.indexOf(widget.task) + 1];
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => TaskbyTask(task: nextTask),
//                       ),
//                     );
//                   } else {
//                     // No more tasks, navigate back
//                     Navigator.pop(context);
//                   }
//                 },
//               ),
//             ],
//           ),
//         ]),
//       ),
//     );
//   }
// }
