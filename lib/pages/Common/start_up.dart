import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jadwali_test_1/pages/Common/pre_login.dart';


class StratUp extends StatefulWidget {
  static const String routeName = '/pre_login';
  const StratUp({super.key});

  @override
  State<StratUp> createState() => _StratUpState();
}

class _StratUpState extends State<StratUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromRGBO(255, 253, 245, 1),
          Color.fromRGBO(255, 245, 208, 1)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: ListView(
              children:[ Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        top: -50,
                        child: Transform.scale(
                          scale: 1.3,
                          child: Image.asset(
                          'assets/images/logo4.png', 
                          width: 400,
                          fit: BoxFit.cover,
                          
                                            ),
                        ),
                      ),

                    const Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 320.0),
                      child: Text(
                        'جدولي',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 75,
                        ),
                      ),
                    ),
                  ),
                ]),

                const SizedBox(height: 60),

                const Text(
                  ' رتب و نظم جدول أطفالك بأدق التفاصيل',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.black,
                        ),),
                 

                 IconButton(
                  onPressed: () {
                    context.goNamed(
                        PreLogin.routeName); // .then: ino sho ye3mal after logout
                  },
                  icon: const Icon(Icons.arrow_back),
                                )
                ],


                
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
