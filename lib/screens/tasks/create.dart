// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:root/components/app_container.dart';
import 'package:root/components/app_text_input.dart';
import 'package:root/components/button.dart';
import 'package:root/constants/colors.dart';
import 'package:root/constants/styles.dart';
import 'package:root/controllers/task_controller.dart';
import 'package:root/helpers/device_info.dart';
import 'package:root/helpers/navigator/navigator.dart';
import 'package:root/models/task.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TaskController _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("HH:mm").format(DateTime.now()).toString();
  String _endTime = DateFormat("HH:mm").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  int _selectedColorIndex = 0;
  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];

  final List<Color> _colorList = [
    AppColor.pastelBlue,
    AppColor.pastelGreen,
    AppColor.pastelOrange,
    AppColor.pastelRed,
  ];

  String _selectedRepeat = "None";
  List<String> repeatList = [
    "None",
    "Daily",
    "Weekly",
    "Montly",
  ];

  _addTaskToDb() async {
    TaskM _task = TaskM(
      title: _titleController.text,
      note: _noteController.text,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      remind: _selectedRemind,
      color: _selectedColorIndex,
      repeat: _selectedRepeat,
      isCompleted: 0,
    );

    int value = await _taskController.addTask(_task);
    log("My id is $value");
  }

  _validate() async {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb();
      _taskController.getTask();
      //add to database
      AppNavigator.pop();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("Required", "All fields are required!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.red,
          icon: Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    }
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2500),
    );
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {
      print("tarih seçilemedi");
    }
  }

  _getTimeFromUser(_isStartTime) async {
    var pickedTime = await _showTimePicker();
    String _formattedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print("zaman seçilemedi");
    } else if (_isStartTime == true) {
      setState(() {
        _startTime = _formattedTime;
      });
    } else if (_isStartTime == false) {
      setState(() {
        _endTime = _formattedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }

  Widget get _body {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: DeviceInfo.width(4)),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Add Task", style: AppTextStyle.headerStyle),
            SizedBox(height: DeviceInfo.height(2)),
            AppTextInput(title: "Title", hint: "Enter your title", controller: _titleController),
            AppTextInput(
              title: "Note",
              hint: "Enter your note",
              controller: _noteController,
            ),
            AppTextInput(
              title: "Date",
              hint: DateFormat.yMd().format(_selectedDate),
              widget: IconButton(
                color: Colors.grey,
                onPressed: () {
                  _getDateFromUser();
                },
                icon: const Icon(Icons.calendar_today_outlined),
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: AppTextInput(
                  title: "Start Time",
                  hint: _startTime,
                  widget: IconButton(
                    onPressed: () {
                      _getTimeFromUser(true);
                    },
                    icon: const Icon(Icons.access_time_rounded),
                    color: Colors.grey,
                  ),
                )),
                SizedBox(width: DeviceInfo.width(5)),
                Expanded(
                    child: AppTextInput(
                  title: "End Time",
                  hint: _endTime,
                  widget: IconButton(
                    onPressed: () {
                      _getTimeFromUser(false);
                    },
                    icon: const Icon(Icons.access_time_rounded),
                    color: Colors.grey,
                  ),
                )),
              ],
            ),
            AppTextInput(
              title: "Remind",
              hint: "$_selectedRemind minutes early",
              widget: Container(
                padding: EdgeInsets.only(right: DeviceInfo.width(4)),
                child: DropdownButton(
                  underline: SizedBox(),
                  elevation: 0,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  iconSize: 32,
                  style: AppTextStyle.subOptionStyle,
                  onChanged: ((String? value) {
                    setState(() {
                      _selectedRemind = int.parse(value!);
                    });
                  }),
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ),
            ),
            AppTextInput(
              title: "Repeat",
              hint: "$_selectedRepeat",
              widget: Container(
                padding: EdgeInsets.only(right: DeviceInfo.width(4)),
                child: DropdownButton(
                  underline: SizedBox(),
                  elevation: 0,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  iconSize: 32,
                  style: AppTextStyle.subOptionStyle,
                  onChanged: ((String? value) {
                    setState(() {
                      _selectedRepeat = value!;
                    });
                  }),
                  items: repeatList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: AppTextStyle.subOptionStyle,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: DeviceInfo.height(2)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _colorPallete,
                AppButton(
                  label: "Create Task",
                  onTap: () => _validate(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget get _colorPallete {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color", style: AppTextStyle.titleStyle),
        SizedBox(height: DeviceInfo.height(1)),
        Wrap(
          children: List<Widget>.generate(
            4,
            (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColorIndex = index;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(right: DeviceInfo.width(2)),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: _colorList[index],
                    child: _selectedColorIndex == index
                        ? Icon(
                            Icons.done,
                            size: 16,
                            color: AppColor.black30,
                          )
                        : Container(),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      hasBackButton: true,
      child: _body,
    );
  }
}
