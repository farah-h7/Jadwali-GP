import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jadwali_test_1/modules/Task.dart';
import 'dart:io';


class AddTaskScreen extends StatelessWidget {
  final Function(Task) onAddTask;

  const AddTaskScreen({Key? key, required this.onAddTask}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('إضافة مهمة'),
          backgroundColor: const Color.fromRGBO(255, 249, 227, 100),
        ),
        body: AddTaskForm(onAddTask: onAddTask),
      ),
    );
  }
}

class AddTaskForm extends StatefulWidget {
  final Function(Task) onAddTask;

  const AddTaskForm({Key? key, required this.onAddTask}) : super(key: key);

  @override
  _AddTaskFormState createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  late TextEditingController _nameController;
  late TimeOfDay _selectedStartTime;
  late TimeOfDay _selectedEndTime;
  List<String> _weekDays = ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];
  late TextEditingController _repetitionController;
  Color _selectedColor = Colors.white;
  List<bool> _selectedRepetitionDays = List.filled(7, false);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _selectedStartTime = TimeOfDay.now();
    _selectedEndTime = TimeOfDay.now();
    _repetitionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _repetitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children:[ Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'اضافة مهمة',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'اسم المهمة',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _selectStartTime,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'وقت بداية المهمة',
                          border: OutlineInputBorder(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              _formatTimeOfDay(_selectedStartTime),
                            ),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: InkWell(
                      onTap: _selectEndTime,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'وقت نهاية المهمة',
                          border: OutlineInputBorder(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              _formatTimeOfDay(_selectedEndTime),
                            ),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              InkWell(
                onTap: _selectRepetition,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'تكرار المهمة',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        _getRepetition(),
                      ),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              InkWell(
                  onTap: _showColorPickerDialog,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'اللون',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'اللون',
                        ),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              // ColorPicker(
              //   pickerColor: _selectedColor,
              //   onColorChanged: (color) => setState(() => _selectedColor = color),
              //   showLabel: true,
              //   pickerAreaHeightPercent: 0.8,
              // ),
              SizedBox(height: 15),

              InkWell(
                onTap: _pickImage,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'صورة المهمة',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'اضغط لاختيار صورة',
                      ),
                      Icon(Icons.image_outlined),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15),
              ElevatedButton(
                onPressed: _addTask,
                child: Text('أضف'),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  void _selectStartTime() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime,
    );
    if (selectedTime != null) {
      setState(() {
        _selectedStartTime = selectedTime;
      });
    }
  }

  void _selectEndTime() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: _selectedEndTime,
    );
    if (selectedTime != null) {
      setState(() {
        _selectedEndTime = selectedTime;
      });
    }
  }

  void _selectRepetition() async {
    List<bool> selectedDays = List.from(_selectedRepetitionDays);
    final Color activeColor = Theme.of(context).colorScheme.secondary;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('اختر أيام التكرار'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                _weekDays.length,
                (index) => StatefulBuilder(
                builder: (context, setState) {
                  return CheckboxListTile(
                    title: Text(_weekDays[index]),
                    value: selectedDays[index],
                    onChanged: (bool? value) {
                      setState(() {
                        selectedDays[index] = value!;
                      });
                  },
                  activeColor: activeColor,
                );
                },
              ),
            ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('الغاء'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedRepetitionDays = List.from(selectedDays);
                  });
                  Navigator.of(context).pop();
                },
                child: Text('تم'),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getRepetition() {
    List<String> selectedDays = [];
    for (int i = 0; i < _weekDays.length; i++) {
      if (_selectedRepetitionDays[i]) {
        selectedDays.add(_weekDays[i]);
      }
    }
    if (selectedDays.isEmpty) {
      return 'اختر ايام التكرار';
    } else if (selectedDays.length == 7) {
      return 'كل يوم';
    } else {
      return selectedDays.join(', ');
    }
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hour.toString().padLeft(2, '0');
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }


  void _showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('اختر اللون'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: _selectedColor,
                onColorChanged: (color) => setState(() => _selectedColor = color),
                showLabel: true,
                pickerAreaHeightPercent: 0.8,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('تم'),
              ),
            ],
          ),
        );
      },
    );
  }



  void _addTask() {
    final String name = _nameController.text.trim();
    final DateTime startTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      _selectedStartTime.hour,
      _selectedStartTime.minute,
    );
    final DateTime endTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      _selectedEndTime.hour,
      _selectedEndTime.minute,
    );
    final List<String> selectedRepetitionDays = [];
    for (int i = 0; i < _weekDays.length; i++) {
      if (_selectedRepetitionDays[i]) {
        selectedRepetitionDays.add(_weekDays[i]);
      }
    }
    final Color color = _selectedColor;

    final newTask = Task(
      name: name,
      startTime: startTime,
      endTime: endTime,
      repetition: selectedRepetitionDays.join(', '), // Adjust as needed
      color: color,
    );

    widget.onAddTask(newTask);
    Navigator.of(context).pop(); // Close the Add Task screen after adding the task
  }
}




Future<void> _pickImage() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery); // Allows the user to pick an image from the gallery

  if (pickedFile != null) {
    // Handle the picked image here
    File imageFile = File(pickedFile.path);
    // Perform further operations with the image file (e.g., display it or save it)
  }
}




class ColorCircle extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;

  const ColorCircle({Key? key, required this.color, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}


