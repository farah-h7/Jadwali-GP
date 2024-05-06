
import 'package:jadwali_test_1/modules/child.dart';
import 'package:flutter/material.dart';
import 'package:jadwali_test_1/pages/Parent/add_task_screen.dart';
import 'package:jadwali_test_1/pages/Parent/child_info.dart';
import 'package:jadwali_test_1/providers/Schedule_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart' show DateFormat; // Import only DateFormat
import 'package:jadwali_test_1/modules/Task.dart';

class ChildSchedulePage extends StatefulWidget {
  final Child childInfo;
  const ChildSchedulePage({super.key, required this.childInfo});

  @override
  State<ChildSchedulePage> createState() => _ChildSchedulePageState();
}

class _ChildSchedulePageState extends State<ChildSchedulePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<ScheduleProvider>(context, listen: true)
        .getTasks(widget.childInfo.scheduleID);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tasks = Provider.of<ScheduleProvider>(context, listen: false).taskList;
      setState(() {
        _updateSelectedTasks(
            _focusedDay); // Calling the function after the frame is built
      });
    });
  }

  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  void _updateSelectedTasks(DateTime selectedDay) {
    setState(() {
      selectedTasks = _filterTasksForSelectedDay(selectedDay);
    });
  }

  final List<String> _weekDays = [
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
  ];

  List<Task> selectedTasks = [];
  List<Task> tasks = [];

  List<Task> _filterTasksForSelectedDay(DateTime selectedDay) {
    tasks = Provider.of<ScheduleProvider>(context, listen: false).taskList;
    List<Task> filteredTasks = tasks.where((task) {
      // Check if the task repeats every day
      if (task.repetition == 'كل يوم') {
        return true;
      }
      
      // Check if the selected day matches any repetition day of the task
      if (task.repetition.contains(_weekDays[(selectedDay.weekday + 7) % 7])) {
        return true;
      }
      return false;
    }).toList();

    setState(() {
      selectedTasks = filteredTasks;
      selectedTasks.sort((a, b) {
    int compareHour = a.startTime.hour.compareTo(b.startTime.hour);
    if (compareHour == 0) { // if hours are equal, then compare minutes
      return a.startTime.minute.compareTo(b.startTime.minute);
    }
    return compareHour;
  });
      
    });

    return filteredTasks;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _updateSelectedTasks(_focusedDay);
    });
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.person, color: Colors.black),
          title: Text(
            widget.childInfo.name,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: const Color.fromRGBO(255, 249, 227, 100),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _getArabicDate(),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            // Calendar
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TableCalendar(
                firstDay: DateTime.utc(2022, 1, 1),
                lastDay: DateTime.utc(DateTime.now().year + 1, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _updateSelectedTasks(selectedDay);
                  });
                },
                headerVisible: false, // Hide the header
              ),
            ),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'جدول اليوم',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Tasks
            Expanded(
              child: ListView.builder(
                itemCount: selectedTasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(8),
                    color: selectedTasks[index].color,
                    child: ListTile(
                      title: Text(selectedTasks[index].name),
                      // subtitle: Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Text('Start Time: ${tasks[index].startTime.day}'),
                      //     // Text('End Time: ${tasks[index].endTime}'),
                      //     // Text('Repetition: ${tasks[index].repetition}'),
                      //   ],
                      // ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            Provider.of<ScheduleProvider>(context, listen: false).deleteTask(selectedTasks[index].id!, widget.childInfo.scheduleID);
                        
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _navigateToAddTaskScreen(context, widget.childInfo.scheduleID);
          },
          child: const Icon(Icons.add),
          backgroundColor: const Color.fromARGB(255, 201, 201, 201),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            decoration: BoxDecoration(
              color:
                  const Color.fromRGBO(255, 249, 227, 100), // Background color
              borderRadius: BorderRadius.circular(15.0), // Border radius
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.calendar_today_outlined),
                  onPressed: () {
                    // Navigate to page 1
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.analytics_outlined),
                  onPressed: () {
                    // Navigate to page 2
                  },
                ),
                // IconButton(
                //   icon: Icon(Icons.games),
                //   onPressed: () {
                //     // Navigate to page 3
                //   },
                // ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    //context.goNamed(HomeParent.routeName);
                    // Navigate to page 3
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(10.0), // Button border radius
                    ),
                    child: Image.asset(
                      'assets/images/logo5.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChildInformationPage(
                          child: widget.childInfo,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    // Navigate to page 5
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToAddTaskScreen(BuildContext context, String SId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddTaskScreen(
                scheduleID: SId,
              )),
    );
  }

  // void _addTask(Task task) {
  //   setState(() {
  //     // tasks.add(task);
  //     _updateSelectedTasks(_selectedDay);
  //   });
  // }
}

String _getArabicDate() {
  final DateTime now = DateTime.now();
  final List<String> arabicDays = [
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت'
  ];
  final List<String> arabicMonths = [
    'كانون الثاني',
    'شباط',
    'آذار',
    'نيسان',
    'أيار',
    'حزيران',
    'تموز',
    'آب',
    'أيلول',
    'تشرين الأول',
    'تشرين الثاني',
    'كانون الأول'
  ];
  return '${arabicDays[now.weekday]}- ${arabicMonths[now.month - 1]}';
}
