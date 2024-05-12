import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jadwali_test_1/auth/auth_service.dart';
import 'package:jadwali_test_1/main.dart';
import 'package:jadwali_test_1/modules/Task.dart';
import 'package:jadwali_test_1/modules/child.dart';
import 'package:jadwali_test_1/pages/Child/connect_monitor.dart';
import 'package:jadwali_test_1/pages/Child/profile.dart';
import 'package:jadwali_test_1/pages/Child/task_page.dart';
import 'package:jadwali_test_1/pages/Common/pre_login.dart';
import 'package:jadwali_test_1/providers/Schedule_provider.dart';
import 'package:provider/provider.dart';

class HomeChild extends StatefulWidget {
  static const String routeName = '/homechild';
  late Child user = currentChild!;

  HomeChild({super.key, required this.user});

  @override
  State<HomeChild> createState() => _HomeChildState();
}

class _HomeChildState extends State<HomeChild> {
  @override
  void didChangeDependencies() {
    Provider.of<ScheduleProvider>(context, listen: false)
        .getTasksOfTheDay(widget.user.scheduleID);
    super.didChangeDependencies();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer(); // Open the side drawer
            },
            icon: const Icon(
              Icons.dehaze_rounded,
            ),
          ),
          title: Text(
            widget.user.name,
            textAlign: TextAlign.right,
          ),
          backgroundColor: const Color.fromRGBO(255, 249, 227, 100),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 249, 227, 100),
                ),
                child: Center(
                  child: Text(
                    widget.user.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text(
                  'الملف الشخصي',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(
                        child: widget.user,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text(
                  'الاشعارات',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  // Navigate to the settings page
                },
              ),

              ListTile(
                leading: const Icon(Icons.watch_outlined),
                title: const Text(
                  'ربط سوار قياس معدل ضربات القلب',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  // Navigate to the settings page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConnectMonitor(),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: const Text(
                  'تسجيل خروج',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  AuthService.logout()
                      .then((value) => context.goNamed(PreLogin.routeName));
                },
              ),
              // Add more list tiles for other pages as needed
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'جدول اليوم',
                      style: TextStyle(
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Display tasks with images and green check if done
                Expanded(
                  child: Consumer<ScheduleProvider>(
                      builder: (context, provider, child) {
                    return ListView.builder(
                      itemCount: provider.tasksOfTheDayList.length,
                      itemBuilder: (context, index) {
                        final task = provider.tasksOfTheDayList[index];
                        return ListTile(
                          //leading: tasks[index].isDone ? Icon(Icons.check, color: Colors.green) : null,
                          title: Center(
                              child:
                                  Text(task.name)), //Text(tasks[index].name),
                          subtitle: task.imageFile != null
                              ? Image.file(
                                  task.imageFile!,
                                  width: 300,
                                  height: 300,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset('assets/images/logo.png',
                                  /*tasks[index].imagePath*/
                                  width: 200,
                                  height: 200),

                          // Image.asset('assets/images/logo.png',
                          //     /*tasks[index].imagePath*/
                          //     width: 200,
                          //     height: 200),
                          onTap: () {
                            // Navigate to task details page
                          },
                          // trailing: tasks[index].isDone
                          //     ? const Icon(Icons.check, color: Colors.green)
                          //     : null,
                        );
                      },
                    );
                  }),
                ),
                // Play button
                SizedBox(
                  height: 120, // Adjust height as needed
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      iconSize: 100,
                      icon: const Icon(Icons.play_circle_rounded),
                      onPressed: () {
                        List<STask> TS = Provider.of<ScheduleProvider>(context,
                                listen: false)
                            .tasksOfTheDayList;
                        if (TS.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TaskDisplayPage(playTasks: TS),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// class Task {
//   final String name;
//   final String imagePath;
//   final String? audioPath;
//   bool isDone;

//   Task({
//     required this.name,
//     required this.imagePath,
//     this.audioPath,
//     this.isDone = false,
//   });
// }
