
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:jadwali_test_1/auth/auth_service.dart';

import 'package:jadwali_test_1/auth/child_auth.dart';
import 'package:jadwali_test_1/main.dart';
import 'package:jadwali_test_1/modules/child.dart';
import 'package:jadwali_test_1/pages/Common/createAccount_child.dart';
import 'package:jadwali_test_1/pages/Child/home_child.dart';
import 'package:jadwali_test_1/pages/Common/pre_login.dart';

class LoginChild extends StatefulWidget {
  static const String routeName = 'login_child';
  const LoginChild({super.key});

  @override
  State<LoginChild> createState() => _LoginChildState();
}

class _LoginChildState extends State<LoginChild> {
  final _formKey = GlobalKey<FormState>();
  //final _ucodeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errMsg = ''; // this will be managed bire firebase authentication

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
          textDirection:
              TextDirection.rtl, // make everything from right to left (arabic)
          child: Center(
            child:
                ListView(
                  children: [Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Stack(children: [
                  Image.asset(
                    'assets/images/logo2.png',
                    width: 450,
                  ),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 162.0),
                      child: Text(
                        'جدولي',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 50,
                        ),
                      ),
                    ),
                  ),
                                ]),
                  
                                const Text(
                  "الطفل",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                                ),
                                // Image.asset(
                                //     'assets/logo.png',
                                //     width: 200,
                                //     height: 200,
                                //   ),
                                Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(24.0),
                    shrinkWrap: true,
                    children: [
                      //email text box
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          //textAlign: TextAlign.right,
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          decoration: const InputDecoration(
                            filled: true,
                            prefixIcon: Icon(Icons.email),
                            labelText: 'البريد الإلكتروني',
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال بريد الكتروني ';
                            }
                            return null;
                          },
                        ),
                      ),
                      //password textbox
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          //textAlign: TextAlign.right,
                          obscureText: true, // to hide password
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            filled: true,
                            prefixIcon: Icon(Icons.password),
                            labelText: 'الرمز السري',
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ' الرجاء إدخال رمز سري';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: ElevatedButton(
                          onPressed: _authenticate,
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(96, 80, 80, 80)),
                          ),
                          child: const Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      //text widget to show error
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          _errMsg,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 244, 130, 54),
                          ),
                        ),
                      ),
                  
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'ليس لديك حساب ؟',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 80, 80, 80),
                                  fontSize: 20,
                                  //fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              TextButton(
                                  onPressed: () {
                                    //context.go('/pre_login/login_parent');
                                    context.goNamed(CreateChildUser.routeName);
                                  },
                                  child: const Text(
                                    ' انشاء حساب',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20,
                                      //fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                                ),
                                //back button
                                IconButton(
                  onPressed: () {
                    context.goNamed(
                        PreLogin.routeName); // .then: ino sho ye3mal after logout
                  },
                  icon: const Icon(Icons.arrow_circle_right_outlined,
                  size: 60,
                  color: Color.fromARGB(255, 148, 148, 148),),
                                )
                              ]),
                ]),
          ),
        ),
      ),
    );
  }

//////////////methods////////////////////
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  } //dispose

  void _authenticate() async {
    if (_formKey.currentState!.validate()) {
      //validate input
      EasyLoading.show(status: 'الرجاء الإنتظار');
      //retrive email and pass from textfield
      final email = _emailController.text;
      final pass = _passwordController.text;
      try {
        final status = await AuthService.loginC(email,
            pass); // loginp is a future method so need to use await with it
        EasyLoading.dismiss();
        if (status) {
          String code = await AuthService.getcurrentusercode();
          
          Child user = await childAuth().getChildWithSpecificUcode(code) as Child;
          currentChild = user;

          EasyLoading.dismiss();
          context.goNamed(HomeChild.routeName);
              //if user exist and is a parent
         
        } else {
          await AuthService.logout();
          setState(() {
            _errMsg = "this is not a child account";
          });
        }
      } on FirebaseAuthException catch (error) {
        //  use a firebase exception class
        EasyLoading.dismiss();
        setState(() {
          _errMsg = error.message!;
          _errMsg = ' هناك خطأ في المعلومات المدخلة';
        });
      }
    }
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//             gradient: LinearGradient(colors: [
//           Color.fromRGBO(255, 253, 245, 1),
//           Color.fromRGBO(255, 245, 208, 1)
//         ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
//         child: Directionality(
//           textDirection:
//               TextDirection.rtl, // make everything from right to left (arabic)
//           child: Center(
//             child: ListView(children: [
//               Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//                 Stack(children: [
//                   Image.asset(
//                     'assets/images/logo2.png',
//                     width: 450,
//                   ),
//                   const Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Padding(
//                       padding: EdgeInsets.only(top: 162.0),
//                       child: Text(
//                         'جدولي',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 50,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ]),

//                 const Text(
//                   'طفل',
//                   style: TextStyle(
//                     fontSize: 25,
//                   ),
//                 ),
//                 // Image.asset(
//                 //     'assets/logo.png',
//                 //     width: 200,
//                 //     height: 200,
//                 //   ),
//                 Form(
//                   key: _formKey,
//                   child: ListView(
//                     padding: const EdgeInsets.all(24.0),
//                     shrinkWrap: true,
//                     children: [
// //special code
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: TextFormField(
//                           //textAlign: TextAlign.right,
//                           controller: _ucodeController,
//                           decoration: const InputDecoration(
//                             filled: true,
//                             prefixIcon: Icon(Icons.email),
//                             labelText: 'الرمز الخاص بالطفل',
//                             fillColor: Colors.white,
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 width: 0,
//                                 style: BorderStyle.none,
//                               ),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(10)),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'الرجاء إدخال رمز صحيح ';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),

//                       //email text box
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: TextFormField(
//                           //textAlign: TextAlign.right,
//                           keyboardType: TextInputType.emailAddress,
//                           controller: _emailController,
//                           decoration: const InputDecoration(
//                             filled: true,
//                             prefixIcon: Icon(Icons.email),
//                             labelText: 'البريد الإلكتروني',
//                             fillColor: Colors.white,
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 width: 0,
//                                 style: BorderStyle.none,
//                               ),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(10)),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'الرجاء إدخال بريد الكتروني ';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                       //password textbox
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: TextFormField(
//                           //textAlign: TextAlign.right,
//                           obscureText: true, // to hide password
//                           controller: _passwordController,
//                           decoration: const InputDecoration(
//                             filled: true,
//                             prefixIcon: Icon(Icons.password),
//                             labelText: 'الرمز السري (at least 6 characters)',
//                             fillColor: Colors.white,
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 width: 0,
//                                 style: BorderStyle.none,
//                               ),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(10)),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return ' الرجاء إدخال رمز سري';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 20.0),
//                         child: ElevatedButton(
//                           //login action 
//                           onPressed: _authenticate,

//                           style: const ButtonStyle(
//                             backgroundColor: MaterialStatePropertyAll(
//                                 Color.fromARGB(96, 80, 80, 80)),
//                           ),
//                           child: const Text(
//                             'تسجيل الدخول',
//                             style: TextStyle(
//                                 fontSize: 20,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                       //text widget to show error
//                       Padding(
//                         padding: const EdgeInsets.all(6.0),
//                         child: Text(
//                           _errMsg,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             color: Color.fromARGB(255, 244, 130, 54),
//                           ),
//                         ),
//                       ),

//                       Center(
//                         child: Padding(
//                           padding: const EdgeInsets.all(3.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Text(
//                                 'ليس لديك حساب ؟',
//                                 style: TextStyle(
//                                   color: Color.fromARGB(255, 80, 80, 80),
//                                   fontSize: 20,
//                                   //fontWeight: FontWeight.bold,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                               TextButton(
//                                   onPressed: () {},
//                                   child: const Text(
//                                     ' انشاء حساب',
//                                     style: TextStyle(
//                                       color: Colors.blue,
//                                       fontSize: 20,
//                                       //fontWeight: FontWeight.bold,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ))
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 //back button
//                 IconButton(
//                   onPressed: () {
//                     context.goNamed(PreLogin
//                         .routeName); // .then: ino sho ye3mal after logout
//                   },
//                   icon: const Icon(Icons.arrow_back),
//                 )
//               ]),
//             ]),
//           ),
//         ),
//       ),
//     );
//   }

// //////////////methods////////////////////
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();

//     super.dispose();
//   } //dispose

//   void _authenticate() async {
//     if (_formKey.currentState!.validate()) {
//       //validate input
//       EasyLoading.show(status: 'الرجاء الإنتظار');
//       //retrive email and pass from textfield
//       final code = _ucodeController.text;
//       final email = _emailController.text;
//       final pass = _passwordController.text;

//       Child user = await childAuth().getChildWithSpecificUcode(code, email) as Child;
//       EasyLoading.dismiss();
//       currentChild = user;

//      Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 homeChild(
//                                                     user: user),
//                                           ),
//                                         );
      
//     }
//   }
// }
