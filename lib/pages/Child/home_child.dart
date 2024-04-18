
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jadwali_test_1/auth/auth_service.dart';
import 'package:jadwali_test_1/main.dart';
import 'package:jadwali_test_1/modules/child.dart';
import 'package:jadwali_test_1/pages/Common/pre_login.dart';

class homeChild extends StatelessWidget {
   static const String routeName = '/homechild';
   late Child user = currentChild!;
  //String stringDob = child.dob.toDate()
   homeChild({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(user.name),
          actions: [
              IconButton(
                onPressed: () {
                  AuthService.logout().then((value) => context.goNamed(PreLogin
                      .routeName)); // .then: ino sho ye3mal after logout
                },
                icon: const Icon(Icons.logout),
              )
            ]
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Name: ${user.name}'),
              Text('Gender: ${user.gender}'),
              Text('Date of Birth: ${user.sDob}'),
              Text('age: ${user.age}'),
              Text('threshold: ${user.threshold}'),
              Text('ucode: ${user.ucode}'),
            ],
          ),
        ),
      ),
    );
  }
}