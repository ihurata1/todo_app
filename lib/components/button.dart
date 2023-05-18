import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:root/constants/colors.dart';
import 'package:root/helpers/device_info.dart';

class AppButton extends StatelessWidget {
  final String label;
  VoidCallback? onTap;
  Color? buttonColor;
  AppButton(
      {super.key,
      required this.label,
      this.onTap,
      this.buttonColor = AppColor.blue});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: DeviceInfo.width(30),
        height: DeviceInfo.width(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: buttonColor,
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(color: AppColor.white),
          ),
        ),
      ),
    );
  }
}
