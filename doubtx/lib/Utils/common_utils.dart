import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonUtils{
  static const Color bgColor = Color(0xff141718);
  static SnackbarController mySnackbar(String title, String message){
    return Get.snackbar(title, message, backgroundColor: const Color.fromARGB(143, 0, 121, 107));
  }
}