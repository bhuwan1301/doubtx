import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonUtils {
  static const Color bgColor = Color(0xff141718);
  static SnackbarController mySnackbar(String title, String message) {
    return Get.snackbar(title, message,
        backgroundColor: const Color.fromARGB(143, 0, 121, 107));
  }

  static myDialogueBox(
      {required String title,
      required String middleText,
      required String textCancel,
      String? textConfirm,
      VoidCallback? onconfirm,
      VoidCallback? oncancel}) {
    return Get.defaultDialog(
        title: title,
        content: Text(middleText,
          style: TextStyle(color: Colors.white),
        ),
        titlePadding: EdgeInsets.all(15),
        contentPadding: EdgeInsets.all(10),
        textConfirm: textConfirm,
        textCancel: textCancel,
        backgroundColor: Color(0xff141718),
        buttonColor: Color(0xff141718),
        radius: 15,
        cancelTextColor: Colors.blue,
        confirmTextColor: Colors.red,
        titleStyle: TextStyle(color: Colors.white),
        onCancel: oncancel,
        onConfirm: onconfirm);
  }
}
