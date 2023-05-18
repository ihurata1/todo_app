// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:root/constants/styles.dart';
import 'package:root/helpers/device_info.dart';

class AppTextInput extends StatelessWidget {
  final String title;
  final String hint;
  Widget? widget;
  TextEditingController? controller;
  AppTextInput({
    super.key,
    required this.title,
    required this.hint,
    this.widget,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: DeviceInfo.height(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.titleStyle,
          ),
          Container(
            margin: EdgeInsets.only(top: DeviceInfo.height(1)),
            height: DeviceInfo.height(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    readOnly: widget == null ? false : true,
                    style: AppTextStyle.subTitleStyle,
                    autofocus: false,
                    cursorColor: Colors.grey,
                    cursorWidth: DeviceInfo.width(0.2),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: DeviceInfo.width(4)),
                      hintText: hint,
                      hintStyle: AppTextStyle.hintStyle,
                    ),
                  ),
                ),
                widget == null ? Container() : Container(child: widget),
              ],
            ),
          )
        ],
      ),
    );
  }
}
