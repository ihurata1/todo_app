// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:root/components/app_container.dart';
import 'package:root/components/button.dart';
import 'package:root/constants/colors.dart';
import 'package:root/constants/navigator/page_route_effect.dart';
import 'package:root/constants/styles.dart';
import 'package:root/controllers/task_controller.dart';
import 'package:root/helpers/device_info.dart';
import 'package:root/helpers/navigator/navigator.dart';
import 'package:root/models/task.dart';
import 'package:root/screens/tasks/create.dart';

import '../components/task_tile.dart';
import '../helpers/notification.dart';
import '../helpers/theme_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  late NotifyHelper _notifyHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _notifyHelper = NotifyHelper();

    _taskController.getTask();
  }

  Widget get _addTaskBar {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: DeviceInfo.width(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: AppTextStyle.subHeadingStyle,
              ),
              Text('Today', style: AppTextStyle.headerStyle),
            ],
          ),
          AppButton(label: '+ Add Task', onTap: () => AppNavigator.push(screen: CreateTaskScreen(), effect: AppRouteEffect.fade))
        ],
      ),
    );
  }

  Widget get _dateTimeLine {
    return Container(
      padding: EdgeInsets.only(left: DeviceInfo.width(4)),
      child: DatePicker(
        DateTime.now(),
        height: DeviceInfo.height(13),
        width: DeviceInfo.width(20),
        initialSelectedDate: DateTime.now(),
        selectionColor: AppColor.blue,
        selectedTextColor: Colors.white,
        dateTextStyle: AppTextStyle.dateTextStyle,
        dayTextStyle: AppTextStyle.dayTextStyle,
        monthTextStyle: AppTextStyle.monthTextStyle,
        onDateChange: (date) => setState(() => _selectedDate = date),
      ),
    );
  }

  Widget get _tasksListView {
    return Expanded(child: Obx(() {
      return ListView.builder(
        itemCount: _taskController.taskList.length,
        itemBuilder: ((context, index) {
          TaskM task = _taskController.taskList[index];
          if (task.repeat == "Daily") {
            DateTime date = DateFormat("HH:mm").parse(task.startTime.toString());
            var myTime = DateFormat("HH:mm").format(date);
            _notifyHelper.scheduledNotification(
              hour: int.parse(myTime.toString().split(":")[0]),
              minute: int.parse(myTime.toString().split(":")[1]),
              task: task,
            );
            return AnimationConfiguration.staggeredList(
              position: index,
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _showModalBottomSheet(context, task),
                        child: TaskTile(task: task),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (task.date == DateFormat.yMd().format(_selectedDate)) {
            DateTime date = DateFormat("HH:mm").parse(task.startTime.toString());
            var myTime = DateFormat("HH:mm").format(date);
            _notifyHelper.scheduledNotification(
              hour: int.parse(myTime.toString().split(":")[0]),
              minute: int.parse(myTime.toString().split(":")[1]),
              task: task,
            );
            return AnimationConfiguration.staggeredList(
              position: index,
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _showModalBottomSheet(context, task),
                        child: TaskTile(task: task),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        }),
      );
    }));
  }

  _bottomSheetButton({required VoidCallback onTap, required String value, required Color color, bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        height: DeviceInfo.height(6),
        width: DeviceInfo.width(90),
        margin: EdgeInsets.only(top: DeviceInfo.height(isClose ? 4 : 1), bottom: DeviceInfo.height(1)),
        child: Center(
          child: Text(
            value,
            style: GoogleFonts.lato(
              textStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  _showModalBottomSheet(BuildContext context, TaskM task) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(top: DeviceInfo.height(2)),
        height: task.isCompleted == 1 ? DeviceInfo.height(28) : DeviceInfo.height(36),
        decoration: BoxDecoration(
            color: ThemeService().theme == ThemeMode.light ? Colors.white : AppColor.black30,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        child: Column(
          children: [
            Center(
              child: Container(
                height: DeviceInfo.height(0.6),
                width: DeviceInfo.width(30),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey),
              ),
            ),
            SizedBox(height: DeviceInfo.height(5)),
            task.isCompleted == 1
                ? Container()
                : _bottomSheetButton(
                    onTap: () {
                      _taskController.markTaskCompleted(task.id!);
                      AppNavigator.pop();
                    },
                    value: "Task Completed",
                    color: AppColor.blue,
                  ),
            _bottomSheetButton(
              onTap: () {
                _taskController.delete(task);
                AppNavigator.pop();
              },
              value: "Delete Task",
              color: AppColor.red,
            ),
            _bottomSheetButton(
              onTap: () {
                AppNavigator.pop();
              },
              value: "Close",
              color: Colors.grey,
              isClose: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget get _body {
    return Column(
      children: [
        _addTaskBar,
        SizedBox(height: DeviceInfo.height(1)),
        _dateTimeLine,
        SizedBox(height: DeviceInfo.height(3)),
        _tasksListView,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }
}
