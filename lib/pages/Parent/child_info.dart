import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jadwali_test_1/modules/child.dart';
import 'package:jadwali_test_1/pages/Parent/child_reports.dart';
import 'package:jadwali_test_1/pages/Parent/child_schedule.dart';
import 'package:jadwali_test_1/pages/Parent/home_parent.dart';

class ChildInformationPage extends StatelessWidget {
  final Child child;
  //String stringDob = child.dob.toDate()
  const ChildInformationPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
          title: const Text(
            'معلومات الطفل',
            textAlign: TextAlign.right,
          ),
          backgroundColor: const Color.fromRGBO(255, 249, 227, 100),
        ),
        body: Stack(children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListView(children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    _buildInfoBox('اسم الطفل', child.name),
                    const SizedBox(height: 20),
                    _buildInfoBox('العمر', '${child.age}'),
                    const SizedBox(height: 20),
                    _buildInfoBox('الجنس', child.gender),
                    const SizedBox(height: 20),
                    _buildInfoBox('الرمز الخاص', child.ucode!),
                  ],
                ),
              ),
            ),
          ]),
        ]),
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
                          childInfo: child,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.analytics_outlined),
                  onPressed: () {
                    // Navigate to page 2
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyChartPage(),
                      ),
                    );
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeParent(),
                      ),
                    );
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
                    // Navigate to page 5
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

  Widget _buildInfoBox(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
