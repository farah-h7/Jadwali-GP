// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'dart:async';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jadwali_test_1/modules/Task.dart';
import 'package:jadwali_test_1/providers/BLConn_provider.dart';
import 'package:jadwali_test_1/providers/Stress_provider.dart';
import 'package:provider/provider.dart';

List<STask> playTasksglobal = [];
int index = 0;
late STask? currentTask;
bool currentlyStressed = false;

///variables for heart rate monitoring

List<int> buffer = [];
String pulseData = "Waiting for heartbeat...";
int threshold = 100; //  threshold for stress detection
List<DateTime> exceedTimestamps = [];
Timer? checkTimer;
Timer? stressTimer;
//int heartRate = 0;
DateTime? lastTimeAboveThreshold;
Duration aboveThresholdDuration = Duration.zero;
int toleranceCounter = 0;
const int toleranceLimit = 10;
Duration maxGap = const Duration(seconds: 15); // Adjust the max gap as needed

StreamSubscription<Uint8List>? _dataSubscription;

///variables for pop ups
//bool isStressed = false; // Indicates if the child is stressed
final audioPlayer = AudioPlayer();
//bool isButtonEnabled = false; // Initially disabled

//connection!.input!.listen(onDataReceived)

class TaskDisplayPage extends StatefulWidget {
  late List<STask> playTasks = [];

  TaskDisplayPage({super.key, required this.playTasks});

  @override
  State<TaskDisplayPage> createState() => _TaskDisplayPageState();
}

class _TaskDisplayPageState extends State<TaskDisplayPage> {
  Timer? countdownTimer;
  String countdown = "Loading...";
  bool showCountdown = false; // Control visibility of the countdown
  bool isButtonEnabled = false;
  bool dis = false;

  ///////////////////////////methods///////////////////////////

  void onDataReceived(Uint8List data) {
    // Accumulate data until delimiter is found
    for (int i = 0; i < data.length; i++) {
      if (data[i] == 44) {
        // ASCII value for ','
        setState(() {
          pulseData = String.fromCharCodes(buffer);
          int heartRate = int.tryParse(pulseData) ?? 0;
          if (heartRate > threshold) {
            lastTimeAboveThreshold = DateTime.now();
            toleranceCounter = 0; // Reset the tolerance counter
          } else {
            toleranceCounter++;
            if (toleranceCounter > toleranceLimit) {
              currentlyStressed = false;
              lastTimeAboveThreshold =
                  null; // Reset tracking after tolerance exceeded
            }
          }
          buffer.clear();
        });
      } else {
        buffer.add(data[i]);
      }
    }
  }

  void checkForStress() {
    if (lastTimeAboveThreshold != null) {
      Duration timeSinceLastAbove =
          DateTime.now().difference(lastTimeAboveThreshold!);
      if (timeSinceLastAbove <= maxGap) {
        aboveThresholdDuration += const Duration(seconds: 1);
      } else {
        aboveThresholdDuration = Duration.zero;
        lastTimeAboveThreshold = null; // Reset tracking after significant pause
      }
      if (aboveThresholdDuration >= const Duration(minutes: 1)) {
        if (!currentlyStressed) {
          //if child was not already in a stressed state, show popup
          currentlyStressed = true;
          if (currentTask == null) {
            showStressPopUp(context, "", Timestamp.now());
          } else {
            showStressPopUp(context, currentTask!.id!, Timestamp.now());
          }
        } else {
          aboveThresholdDuration = Duration.zero;
        }
      }
    } else {
      aboveThresholdDuration = Duration.zero;
    }
  }

  void showStressDetectedPopup() {
    //old
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

  // void startTaskTimer() {
  //   Timer(const Duration(seconds: 5 /*minutes: 2*/), () {
  //     setState(() {
  //       isButtonEnabled = true; // Enable the button after 2 minutes
  //     });
  //   });
  // }

  void startTaskTimer() {
    countdownTimer?.cancel(); // Cancel any existing timer
    dis = false; // Disable the button when task timer starts
    setState(() {}); // Update the UI to reflect the button disabled state

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      DateTime now = DateTime.now();

      if (index < widget.playTasks.length) {
        DateTime taskDateTime = widget.playTasks[index].startTime;
        TimeOfDay taskTime = TimeOfDay(hour: taskDateTime.hour, minute: taskDateTime.minute);
        TimeOfDay nowTime = TimeOfDay(hour: now.hour, minute: now.minute);

        int taskTotalMinutes = taskTime.hour * 60 + taskTime.minute;
        int nowTotalMinutes = nowTime.hour * 60 + nowTime.minute;

        if (taskTotalMinutes > nowTotalMinutes) {
          int diffMinutes = taskTotalMinutes - nowTotalMinutes;
          int hours = diffMinutes ~/ 60;
          int minutes = diffMinutes % 60;
          int seconds = 60 - now.second;

          Duration timeLeft = Duration(hours: hours, minutes: minutes - 1, seconds: seconds);
          setState(() {
            countdown = formatDuration(timeLeft);
            isButtonEnabled = false;
            showCountdown = true;
            currentTask = null;
          });
        } else {
          setState(() {
            countdown = "Task started!";
            isButtonEnabled = true;
            showCountdown = false;
            currentTask = widget.playTasks[index];
            Future.delayed(const Duration(seconds: 10), () {
              // Re-enable the button after 10 seconds for this specific task
              if (mounted) {
                setState(() {
                  
                  dis = true;
                });
              }
            });
          });
          timer.cancel(); // Stop the countdown timer
        }
      } else {
        print(
            "Index out of range: Index - $index, Tasks Length - ${widget.playTasks.length}");
        timer.cancel(); // Stop the countdown timer
      }
    });
  }

  String formatDuration(Duration d) {
    return '${d.inHours.toString().padLeft(2, '0')}:${(d.inMinutes % 60).toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    //what happens after closing the page
    stopListening();
    checkTimer?.cancel();
    countdownTimer?.cancel();

    stressTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    isButtonEnabled = false; // Ensure button is initially disabled

    if (index == 0 &&
        Provider.of<BLConnProvider>(context, listen: false).isConn) {
      startRecivingData();
    }
    if (index == 0) {
      currentTask = widget.playTasks[index];
    }

    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          dis = true; // Enable button after 10 seconds
        });
      }
    });
    startTaskTimer();

    stressTimer = Timer.periodic(const Duration(seconds: 10),
        (_) => showStressPopUp(context, "id", Timestamp.now()));

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

              if (showCountdown) ...[
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                      "الوقت المتبقي للمهمة التالية :",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black ),
                    ),
                    Text(
                      countdown,
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),

                      Image.asset('assets/images/hour-glass.gif'),

                      ],
                    ),
                  ),
                ),
              ] else if (isButtonEnabled) ...[
              const SizedBox(
                height: 40,
              ),

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
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
                      ElevatedButton(
                        onPressed: () async {
                          await audioPlayer
                              .play(AssetSource('audios/audio1.m4a'));
                        },
                        child: const Icon(
                          Icons.volume_up_rounded,
                          size: 50,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
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
                icon: Icon(Icons.check_circle,
                    color: dis ? Colors.green : Colors.grey),
                onPressed: () {
                  if (dis) {
                    showCongratulationsPopUp(context);

                    // Check if there are more tasks
                    if (index < widget.playTasks.length - 1) {
                      //showCongratulationsPopUp(context);
                      // Move to the next task
                      setState(() {
                        index++;
                        isButtonEnabled = false;
                        
                        startTaskTimer();
                       
                      });
                    } else {
                      showCongratulationsPopUp(context);

                      index = 0;
                      // No more tasks, navigate back
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ],
         ] ),
        ]),
      ),
    );
  }
}

void showStressPopUp(BuildContext context, String TaskID, Timestamp now) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Center(
            child: Text(
              'ما هو شعورك الآن ؟',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await audioPlayer.play(AssetSource('audios/audio1.m4a'));
                },
                child: const Icon(
                  Icons.volume_up_rounded,
                  size: 50,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      print("Happy face tapped");
                      currentlyStressed = false;
                      // Handle happy response
                      Provider.of<StressProvider>(context, listen: false)
                          .recordStressResponse(false, now, TaskID);
                      exceedTimestamps.clear();
                      Navigator.of(context).pop();

                      // Reset stress state
                      // kan fe set state 3aleha
                    },
                    child: Ink.image(
                      image: const AssetImage('assets/images/greenFace.png'),
                      width: 100,
                      height: 100,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      print("Sad face tapped");
                      // Handle sad response
                      Provider.of<StressProvider>(context, listen: false)
                          .recordStressResponse(true, now, TaskID);
                      exceedTimestamps.clear();

                      Navigator.of(context).pop();
                      // Possibly take further actions for a stressed response
                    },
                    child: Ink.image(
                      image: const AssetImage('assets/images/redFace.png'),
                      width: 100,
                      height: 100,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showCongratulationsPopUp(BuildContext context) {
  audioPlayer.play(AssetSource('audios/audio2.m4a'));
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.4,
          child: Stack(
            children: [
              Image.asset(
                'assets/images/good-job.gif',
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 10,
              ),
              //   Positioned.fill(
              //     child: Align(
              //       alignment: Alignment.bottomCenter,
              //       child: IconButton(
              //         iconSize: 100,
              //         icon: const Icon(Icons.check_circle, color: Colors.green),
              //         onPressed: () {
              //           Navigator.pop(context);
              //         },
              //       ),
              //     ),
              //   )
            ],
          ),
        ),
      );
    },
  );
  Timer(const Duration(seconds: 3), () {
    //Navigator.of(context).pop();
    Navigator.pop(context);
    audioPlayer.stop();
  });
}
