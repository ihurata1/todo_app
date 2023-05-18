// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:root/constants/colors.dart';
import 'package:root/helpers/device_info.dart';
import 'package:root/helpers/navigator/navigator.dart';
import 'package:root/screens/home.dart';
import 'package:root/helpers/theme_services.dart';

import '../helpers/notification.dart';

class AppContainer extends StatefulWidget {
  final Widget child;
  int? selectedIndex;
  bool? hasBackButton;

  AppContainer({required this.child, this.selectedIndex, this.hasBackButton = false, super.key});

  @override
  State<AppContainer> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  late int _selectedIndex;

  late NotifyHelper _notifyHelper;

  @override
  void initState() {
    super.initState();
    _notifyHelper = NotifyHelper();
    _selectedIndex = widget.selectedIndex ?? -1;
  }

  onTap(index) {
    setState(() {
      _selectedIndex = index;
    });
    log(_selectedIndex.toString());
  }

  Widget get _darkModeIcon {
    return GestureDetector(
      onTap: () async {
        ThemeService().switchTheme();
        await Future.delayed(Duration(milliseconds: 100));

        //_notifyHelper.scheduledNotification();
        setState(() {});
      },
      child: Container(
        color: Colors.red.withOpacity(0),
        child: Icon(
          ThemeService().theme == ThemeMode.light ? Icons.nightlight_round_rounded : Icons.light_mode_rounded,
          color: ThemeService().theme != ThemeMode.light ? AppColor.white : AppColor.black2B,
          size: DeviceInfo.width(5),
        ),
      ),
    );
  }

  Widget get _backIcon {
    return GestureDetector(
      onTap: () {
        AppNavigator.pop();
      },
      child: Container(
        color: Colors.red.withOpacity(0),
        child: Icon(
          Icons.arrow_back_ios_new_outlined,
          color: ThemeService().theme != ThemeMode.light ? AppColor.white : AppColor.black2B,
          size: DeviceInfo.width(5),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.appBarTheme.backgroundColor,
      leading: widget.hasBackButton! ? _backIcon : _darkModeIcon,
      actions: [
        widget.hasBackButton!
            ? Container()
            : Icon(
                Icons.person,
                color: ThemeService().theme != ThemeMode.light ? AppColor.white : AppColor.black2B,
                size: DeviceInfo.width(5),
              ),
        SizedBox(width: DeviceInfo.width(4)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: widget.child,
      bottomNavigationBar: null,

      //widget.hideBottomNavBar! ? _bottomNavBar : null,
    );
  }
}
