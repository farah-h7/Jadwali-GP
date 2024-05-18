import 'package:flutter/material.dart';
import 'package:jadwali_test_1/modules/child.dart';

class Profile extends StatelessWidget {
  final Child child;
  //String stringDob = child.dob.toDate()
  const Profile({super.key, required this.child});
  
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
            
            ListView(
              children: [Center(
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
                    _buildInfoBox('الجنس', child.gender == "Female"? "أنثى" : "ذكر"),
                    const SizedBox(height: 20),
                    _buildInfoBox('الرمز الخاص', child.ucode!),
                  ],
                ),
              ),
                      ),
          ]),
        ]),
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