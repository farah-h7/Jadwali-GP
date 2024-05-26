import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:jadwali_test_1/modules/child.dart';
import 'package:jadwali_test_1/pages/Parent/child_info.dart';
import 'package:jadwali_test_1/pages/Parent/child_schedule.dart'; // To use Cupertino icons

Color themeColor = const Color(0xFFFFF9E3);

class MyChartPage extends StatefulWidget {
  static const String routeName = '/task_reports';
  final Child childInfo;
  const MyChartPage({super.key, required this.childInfo});

  @override
  _MyChartPageState createState() => _MyChartPageState();
}

class _MyChartPageState extends State<MyChartPage> {
  int _selectedIndex = 0;
  Map<String, dynamic>? selectedTask;

  final List<String> tabs = ["معدل النبضات ", " تقرير المهام "];

  void _onTaskTap(Map<String, dynamic> task) {
    setState(() {
      selectedTask = task;
    });
  }

  void _onToggleChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: themeColor,
          elevation: 0,
          title: const Text('إسم الطفل', style: TextStyle(color: Colors.black)),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ToggleButtons(
                  isSelected: List.generate(
                      tabs.length, (index) => index == _selectedIndex),
                  onPressed: _onToggleChanged,
                  borderRadius: BorderRadius.circular(8.0),
                  selectedBorderColor: Colors.grey[400],
                  fillColor: Colors.grey[200],
                  selectedColor: Colors.black,
                  color: Colors.grey,
                  children: tabs
                      .map((tab) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(tab),
                          ))
                      .toList(),
                ),
              ),
              Expanded(
                flex: 1,
                child: _selectedIndex == 0
                    ? const LineChartReport()
                    : TasksPage(
                        selectedTask: selectedTask, onTaskTap: _onTaskTap),
              ),
            ],
          ),
        ),
////////////////////////////navigation bar //////////////////////////////
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
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChildSchedulePage(
                          childInfo: widget.childInfo,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.analytics_outlined),
                  //isSelected: true,
                  onPressed: () {
                    // Navigate to page 2
    
                  },
                ),
            
                GestureDetector(//logo, home 
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
}

class TasksPage extends StatelessWidget {
  final Map<String, dynamic>? selectedTask;
  final Function(Map<String, dynamic>) onTaskTap;

  const TasksPage({super.key, this.selectedTask, required this.onTaskTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: BarGraph(
              taskName: selectedTask?['name'], selectedTask: selectedTask),
        ),
        const Text('قائمة المهام'),
        Expanded(
          flex: 1,
          child: TaskList(onTaskTap: onTaskTap),
        ),
      ],
    );
  }
}

class BarGraph extends StatelessWidget {
  final String? taskName;
  final Map<String, dynamic>? selectedTask;
  const BarGraph({super.key, this.taskName, this.selectedTask});

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups = [];
    if (selectedTask != null && selectedTask!.containsKey('weeklyRecord')) {
      barGroups = List.generate(selectedTask!['weeklyRecord'].length, (index) {
        double height = selectedTask!['weeklyRecord'][index].toDouble();
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: height,
              color: Colors.lightBlueAccent,
            )
          ],
        );
      });
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(' التقرير الأسبوعي لأوقات انتهاء كل مهمة'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Container(
                  height: 300,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      if (taskName != null)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            taskName!, // Display the task name
                            style: const TextStyle(
                              color: Color(0xff939393),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30.0, bottom: 8),
                          child: Container(
                            height: 300,
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: 6,
                                barTouchData: BarTouchData(
                                  enabled: false,
                                ),
                                titlesData: FlTitlesData(
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(
                                        showTitles:
                                            false), // Hides the top titles
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      getTitlesWidget:
                                          (double value, TitleMeta meta) {
                                        String text;
                                        switch (value.toInt()) {
                                          // here each number represents a day of the week, we use this down 3end the bar
                                          case 0:
                                            text = 'س';
                                            break;
                                          case 1:
                                            text = 'ج';
                                            break;
                                          case 2:
                                            text = 'خ';
                                            break;
                                          case 3:
                                            text = 'ر';
                                            break;
                                          case 4:
                                            text = 'ث';
                                            break;
                                          case 5:
                                            text = 'ن';
                                            break;
                                          case 6:
                                            text = 'ح';
                                          default:
                                            text = '';
                                        }
                                        return SideTitleWidget(
                                          axisSide: meta.axisSide,
                                          space:
                                              16, // This is the spacing from the chart
                                          child: Text(
                                            text,
                                            style: const TextStyle(
                                                color: Color(0xff939393),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                    ),
                                  ),
                                ),
                                gridData: const FlGridData(
                                    drawHorizontalLine: true,
                                    drawVerticalLine: false),
                                borderData: FlBorderData(show: false),
                                barGroups: [
                                  //these are the days of the week and bar chart data
                                  BarChartGroupData(
                                    x: 0, //indicates the day of the week
                                    barRods: [
                                      BarChartRodData(
                                        toY: getBarHeight(
                                            selectedTask, 0), //the bar height
                                        color: Colors.lightBlueAccent,
                                      )
                                    ],
                                  ),
                                  BarChartGroupData(
                                    x: 1,
                                    barRods: [
                                      BarChartRodData(
                                        toY: getBarHeight(selectedTask, 1),
                                        color: Colors.greenAccent,
                                      )
                                    ],
                                  ),
                                  BarChartGroupData(
                                    x: 2,
                                    barRods: [
                                      BarChartRodData(
                                        toY: getBarHeight(selectedTask, 2),
                                        color: Colors.pinkAccent,
                                      )
                                    ],
                                  ),
                                  BarChartGroupData(
                                    x: 3,
                                    barRods: [
                                      BarChartRodData(
                                        toY: getBarHeight(selectedTask, 3),
                                        color: Colors.lightGreenAccent,
                                      )
                                    ],
                                  ),
                                  BarChartGroupData(
                                    x: 4,
                                    barRods: [
                                      BarChartRodData(
                                        toY: getBarHeight(selectedTask, 4),
                                        color: Colors.redAccent,
                                      )
                                    ],
                                  ),
                                  BarChartGroupData(
                                    x: 5,
                                    barRods: [
                                      BarChartRodData(
                                        toY: getBarHeight(selectedTask, 5),
                                        color: Colors.yellowAccent,
                                      )
                                    ],
                                  ),
                                  BarChartGroupData(
                                    x: 6,
                                    barRods: [
                                      BarChartRodData(
                                        toY: getBarHeight(selectedTask, 6),
                                        color: Colors.purpleAccent,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

double getBarHeight(Map<String, dynamic>? selectedTask, int dayIndex) {
  if (selectedTask != null) {
    List<int> weeklyRecord = selectedTask['weeklyRecord'];
    if (weeklyRecord.length > dayIndex) {
      return weeklyRecord[dayIndex].toDouble();
    }
  }
  return 0.0;
}

class TaskList extends StatelessWidget {
  final Function(Map<String, dynamic>) onTaskTap;
  const TaskList({super.key, required this.onTaskTap});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tasks = [
      {
        'name': 'المهمة 1',
        'startTime': '09:00',
        'endTime': '10:00',
        'weeklyRecord': [
          3,
          2,
          5,
          0,
          6,
          1,
          4
        ] // Dummy data for each day of the week
      },
      {
        'name': 'المهمة 2',
        'startTime': '11:00',
        'endTime': '12:00',
        'weeklyRecord': [1, 3, 2, 5, 3, 2, 0]
      },
    ];

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Card(
            surfaceTintColor: const Color.fromARGB(255, 236, 236, 236),
            color: Colors.white,
            elevation: 2,
            margin: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () => onTaskTap(tasks[index]),
              child: ListTile(
                title: Text(tasks[index]['name']),
                subtitle: Text(
                    'وقت البداية: ${tasks[index]['startTime']} - وقت النهاية: ${tasks[index]['endTime']}'),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomCircularIndicator extends StatelessWidget {
  final int progress; // Progress as an integer value between 0 and 7
  final int maxProgress = 7; // Maximum progress value is always 7

  const CustomCircularIndicator({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(45, 45), // Size of the circle
      painter: _CircleProgressPainter(progress, maxProgress),
    );
  }
}

class _CircleProgressPainter extends CustomPainter {
  final int progress;
  final int maxProgress;

  _CircleProgressPainter(this.progress, this.maxProgress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint basePaint = Paint()
      ..color = Colors.grey.shade300 // Color for the base circle
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    Paint progressPaint = Paint()
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..color = progress <= 4
          ? const Color.fromARGB(255, 128, 233, 131)
          : const Color.fromARGB(
              255, 253, 129, 120); // Change color based on progress

    // Draw the base circle
    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: size.width,
          height: size.height),
      -math.pi / 2,
      2 * math.pi,
      false,
      basePaint,
    );

    // Only draw the progress if it's greater than 0
    if (progress > 0) {
      double angle = 2 * math.pi * (progress / maxProgress);
      canvas.drawArc(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: size.width,
            height: size.height),
        -math.pi / 2,
        angle,
        false,
        progressPaint,
      );
    }

    // Draw the progress number inside the circle
    TextSpan span = TextSpan(
      style: const TextStyle(
          color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
      text: progress.toString(),
    );
    TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas,
        Offset(size.width / 2 - tp.width / 2, size.height / 2 - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class LineChartReport extends StatelessWidget {
  const LineChartReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 2, // Adjust the flex factor if needed to allocate space
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  height:
                      200, // Adjusted height to accommodate text, chart, and padding
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'معدل نبضات القلب الاسبوعي', // Text is now directly inside the first container
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(
                              16.0), // Added padding around the inner container
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Container(
                              // Inner container for the chart
                              decoration: BoxDecoration(
                                // color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: LineChart(LineChartData(
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  getDrawingHorizontalLine: (value) => FlLine(
                                    color: Colors.blueGrey[100],
                                    strokeWidth: 1,
                                  ),
                                  getDrawingVerticalLine: (value) => FlLine(
                                    color: Colors.blueGrey[100],
                                    strokeWidth: 1,
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 30,
                                      interval: 1,
                                      getTitlesWidget:
                                          (double value, TitleMeta meta) {
                                        return Text(
                                          [
                                            'Mon',
                                            'Tue',
                                            'Wed',
                                            'Thu',
                                            'Fri',
                                            'Sat',
                                            'Sun'
                                          ][value.toInt()],
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      interval: 1,
                                      getTitlesWidget:
                                          (double value, TitleMeta meta) {
                                        return Text(
                                          '${value.toInt()}k',
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: false, // Hide top titles
                                    ),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: false, // Hide right titles
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border.all(
                                      color: Colors.black12, width: 1),
                                ),
                                minX: 0,
                                maxX: 6,
                                minY: 0,
                                maxY: 6,
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: [
                                      const FlSpot(0, 3),
                                      const FlSpot(1, 4),
                                      const FlSpot(2, 1),
                                      const FlSpot(3, 4),
                                      const FlSpot(4, 3),
                                      const FlSpot(5, 6),
                                      const FlSpot(6, 4),
                                    ],
                                    isCurved: true,
                                    color: const Color.fromARGB(
                                        255, 119, 190, 248),
                                    barWidth: 5,
                                    isStrokeCapRound: true,
                                    dotData: const FlDotData(show: false),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: Colors.blue.withOpacity(
                                          0.09), // Single color with opacity
                                    ),
                                  )
                                ],
                              )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two items per row
                  crossAxisSpacing: 10, // Horizontal space between items
                  mainAxisSpacing: 10, // Vertical space between items
                  childAspectRatio: 3 / 2.3, // Aspect ratio of each grid item
                ),
                itemCount: 6, // Total number of items
                itemBuilder: (context, index) {
                  int progress = ((index + 1) * 7 / 6)
                      .round(); // Scale and round the progress properly
                  return Card(
                    color: Colors.white, // Explicitly making the card white
                    elevation: 2,
                    surfaceTintColor: Colors.white,
                    shadowColor: const Color.fromARGB(255, 172, 172, 172),
                    child: ListTile(
                      //leading: CustomCircularIndicator(progress: progress),
                      title: Text(
                        ' مهمة ${index + 1} ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      subtitle: Text(
                          ' عدد مرات التوتر:      $progress من 7 ايام'),
                      trailing: CustomCircularIndicator(progress: progress),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
