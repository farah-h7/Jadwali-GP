// ignore_for_file: camel_case_types

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jadwali_test_1/providers/child_provider.dart';
import 'package:provider/provider.dart';

class addChildPage extends StatefulWidget {
  static const String routeName = 'add_child';
  addChildPage({super.key});

  @override
  State<addChildPage> createState() => _addChildPageState();
}

class _addChildPageState extends State<addChildPage> {
  final _childformKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  String _gender = "";
  DateTime _dob = DateTime.now();
  final _dobControler = TextEditingController();
  String genderErr = "";
  

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('أضف طفل'),
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
              children: [
                Expanded(
                  child: Form(
                    key: _childformKey,
                    //autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: ListView(
                      padding: const EdgeInsets.all(24.0),
                      shrinkWrap: true,
                      children: [
                        
                      
                        // Name input field
                        TextFormField(
                          controller: _name,
                          textDirection: TextDirection.rtl,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'إسم الطفل',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال إسم الطفل';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),
                        // Gender selection

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Row(
                            children: [
                              const Text(
                                'الجنس',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Radio(
                                value: 'Male',
                                groupValue: _gender,
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value.toString();
                                    genderErr = "";
                                  });
                                },
                              ),
                              const Text('ذكر'),
                              Radio(
                                value: 'Female',
                                groupValue: _gender,
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value.toString();
                                    genderErr = "";
                                  });
                                },
                              ),
                              const Text('انثى'),
                            ],
                          ),
                        ),
                        Text(
                          genderErr,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),

                        const SizedBox(height: 20),
                        // Date of birth input field
                        GestureDetector(
                          onTap: () => _selectDob(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _dobControler,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'تاريخ الميلاد',
                                prefixIcon: Icon(Icons.edit_calendar_rounded),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ' الرجاء إختيار تاريخ الميلاد';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Submit button
                        ElevatedButton(
                          onPressed: () {
                            _childformKey.currentState!.validate();
                            if (_gender == "") {
                              setState(() {
                                genderErr = "الرجاء إختيار الجنس";
                              });
                            } else if (_childformKey.currentState!.validate()) {
                              // Simulate adding a new child
                              EasyLoading.show(status: "الرجاء الإنتظار");
                              //addong child, sending to provider
                              Provider.of<childProvider>(context, listen: false)
                                  .addChildDb(
                                _name.text,
                                _gender,
                                _dob,
                              )
                                  .then((value) {
                                EasyLoading.dismiss();
                                showMSG(context, "تم إضافة طفلك");
                                Navigator.pop(context);
                              });
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.black38), // Change the color here
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Text(
                              'اضافة الطفل',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Future<void> _selectDob(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dob,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _dob) {
      setState(() {
        _dob = pickedDate;
        _dobControler.text = _dob.toString().substring(0, 10);
      });
    }
  }
}

showMSG(BuildContext context, String msg) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
