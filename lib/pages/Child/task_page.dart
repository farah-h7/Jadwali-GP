import 'package:flutter/material.dart';
import 'package:jadwali_test_1/modules/Task.dart';

List<Task> playTasksglobal = [];

class TaskDisplayPage extends StatelessWidget {
  late List<Task> playTasks = [];

  TaskDisplayPage({super.key, required this.playTasks});

  @override
  Widget build(BuildContext context) {
    playTasksglobal = playTasks;
    return Scaffold(
        body: TaskbyTask(
      task: playTasks.first,
    ));
  }
}

class TaskbyTask extends StatefulWidget {
  final Task task;

  const TaskbyTask({super.key, required this.task});

  @override
  _TaskbyTaskState createState() => _TaskbyTaskState();
}

class _TaskbyTaskState extends State<TaskbyTask> {
  //get playTasks => null;
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
            crossAxisAlignment: CrossAxisAlignment.center, // Horizontal Alignment
            mainAxisAlignment: MainAxisAlignment.center, // Vertical Alignment

           // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 300,
                height: 300,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    widget.task.name,
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
                  if (playTasksglobal.indexOf(widget.task) <
                      playTasksglobal.length - 1) {
                    // Move to the next task
                    Task nextTask = playTasksglobal[
                        playTasksglobal.indexOf(widget.task) + 1];
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskbyTask(task: nextTask),
                      ),
                    );
                  } else {
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
