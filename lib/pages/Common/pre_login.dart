import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class PreLogin extends StatefulWidget {
  static const String routeName = '/pre_login';
  const PreLogin({super.key});

  @override
  State<PreLogin> createState() => _PreLoginState();
}

class _PreLoginState extends State<PreLogin> {
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
                  'تسجيل دخول',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.black,
                        ),),


                  const SizedBox(height: 25),


                  Container(
                    width: 330, // Adjust width as needed
                    height: 50, // Adjust height as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), // Adjust the radius for rounded edges
                      color: Colors.white, // Set background color to white
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1), // Shadow color
                          spreadRadius: 2, // Spread radius
                          blurRadius: 4, // Blur radius
                          offset: const Offset(0, 4), // Offset to control the position of the shadow
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // GoRouter.of(context).go(LoginParent.routeName);
                        context.go('/pre_login/login_parent');
                        //context.goNamed(LoginParent.routeName);
                        // Action for the first button
                      },
                      style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.transparent), // Transparent background
                            elevation: MaterialStateProperty.all(0), // No elevation
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), // Same radius as container
                              ),
                            ),
                          ),
                      child: const Text('ولي الأمر',
                      style: TextStyle(
                      color: Colors.black, // Text color
                      fontSize: 22, // Text size
                      //fontWeight: FontWeight.bold,
                       // Text weight
                    ),
                    textAlign: TextAlign.right,
                  ),
                      
                    ),
                  ),
                  const SizedBox(height: 15),


                  Container(
                    width: 330, // Adjust width as needed
                    height: 50, // Adjust height as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), // Adjust the radius for rounded edges
                      color: Colors.white, // Set background color to white
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1), // Shadow color
                          spreadRadius: 2, // Spread radius
                          blurRadius: 4, // Blur radius
                          offset: const Offset(0, 4), // Offset to control the position of the shadow
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                       context.go('/pre_login/login_child');
                      },
                      style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.transparent), // Transparent background
                              elevation: MaterialStateProperty.all(0), // No elevation
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), // Same radius as container
                                ),
                              ),
                            ),
                      child: const Text('الطفل',
                      style: TextStyle(
                      color: Colors.black, // Text color
                      fontSize: 22, // Text size
                      //fontWeight: FontWeight.bold,
                       // Text weight
                    ),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
