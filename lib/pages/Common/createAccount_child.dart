// ignore_for_file: file_names, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:jadwali_test_1/auth/child_auth.dart';
import 'package:jadwali_test_1/db/db_helper.dart';
import 'package:jadwali_test_1/main.dart';
import 'package:jadwali_test_1/modules/child.dart';
import 'package:jadwali_test_1/modules/users.dart';
import 'package:jadwali_test_1/pages/Child/home_child.dart';
import 'package:jadwali_test_1/pages/Common/pre_login.dart';

class CreateChildUser extends StatefulWidget {
  static const String routeName = 'createAccount_child';
  const CreateChildUser({super.key});

  @override
  State<CreateChildUser> createState() => _CreateChildUserState();
}

class _CreateChildUserState extends State<CreateChildUser> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ucodeController = TextEditingController();
  final _ParentEmailController = TextEditingController();

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
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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

                    Form(
                      key: _formKey,
                      child: ListView(
                        padding: const EdgeInsets.all(24.0),
                        shrinkWrap: true,
                        children: [
////////////////////////////////////////////////////child mail text box
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              //textAlign: TextAlign.right,
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              decoration: const InputDecoration(
                                filled: true,
                                prefixIcon: Icon(Icons.email),
                                labelText: 'البريد الإلكتروني الخاص بالطفل',
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
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
/////////////////////////////////child password textbox
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              //textAlign: TextAlign.right,
                              obscureText: true, // to hide password
                              controller: _passwordController,
                              decoration: const InputDecoration(
                                filled: true,
                                prefixIcon: Icon(Icons.password),
                                labelText:
                                    'الرمز السري (at least 6 characters)',
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
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

//////////////////////////////confirm password
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              //textAlign: TextAlign.right,
                              obscureText: true, // to hide password
                              decoration: const InputDecoration(
                                filled: true,
                                prefixIcon: Icon(Icons.email),
                                labelText: "تأكيد الرمز السري",
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value != _passwordController.text) {
                                  return 'الرمز السري غير مطابق ';
                                }
                                return null;
                              },
                            ),
                          ),
                          /////////////////////parent emial
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              //textAlign: TextAlign.right,
                              keyboardType: TextInputType.emailAddress,
                              controller: _ParentEmailController,
                              decoration: const InputDecoration(
                                filled: true,
                                prefixIcon: Icon(Icons.email),
                                labelText:
                                    ' البريد الإلكتروني الخاص بولي الأمر',
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
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
//////////////////////////////child ucode
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              //textAlign: TextAlign.right,
                              controller: _ucodeController,
                              decoration: const InputDecoration(
                                filled: true,
                                prefixIcon: Icon(Icons.email),
                                labelText: "الرمز الخاص بالطفل",
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء إدخال الرمز الخاص بالطفل ';
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
                                'إنشاء حساب',
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
                        ],
                      ),
                    ),
                    //back button
                    IconButton(
                      onPressed: () {
                        context.goNamed(PreLogin
                            .routeName); // .then: ino sho ye3mal after logout
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ],
                ),
              ],
            ),
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
      final ucode = _ucodeController.text;
      final parentEmail = _ParentEmailController.text;

      // check ucode and and parent match
      bool validUcode = await DbHelper.checkValidUcode(ucode, parentEmail);
      if (!validUcode) {  // if ucode and parent email dont match
        EasyLoading.dismiss();
        setState(() {
          _errMsg =
              ' هناك خطأ في المعلومات المدخلة(رمز الطفل أو بريد ولي الأمر)';
        });
      } else {
        User? usern;
        try {
          //creating child account
          UserCredential userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
          // adding new child user in user collection
          usern = userCredential.user;
          user newuserchild =
              user(email: email, name: "name", accountType: "c", ucode: ucode);
          DbHelper.addChilduserDb(newuserchild, usern!.uid);

          //need to update ucode
          DbHelper.updateUcode(ucode, usern.uid);

          //retriving child profile
          Child getchild =
              await childAuth().getChildWithSpecificUcode(ucode) as Child;
          currentChild = getchild;
          context.goNamed(HomeChild.routeName);

          EasyLoading.dismiss();
        } catch (error) {
          EasyLoading.dismiss();
          setState(() {
            _errMsg = error.toString();
            // _errMsg = ' هناك خطأ في المعلومات المدخلة';
          });
        }
      }
    }
  }
}

/*

 User? usern;
    try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: childemail,
      password: childpassword,
    );
    // User successfully created, now sign in
    // User successfully created
    usern = userCredential.user;
    AuthService.logout();

    print('User created: ${usern?.uid}');
  } catch (e) {
    // Error occurred during user creation
    print('Error creating user: $e');
  }


 user newuserchild = user(email: childemail, name: name, accountType: "c", ucode: ucode);
    DbHelper.addChilduserDb(newuserchild, usern!.uid);
    
    */
