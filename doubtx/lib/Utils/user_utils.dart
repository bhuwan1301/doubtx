import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonUserUtils {
  static const Color bgColor = Color(0xff141718);
}

class DoubtXBottomNavBar extends StatelessWidget {
  final double screenWidth;
  final String currentPage;
  const DoubtXBottomNavBar(
      {super.key, required this.screenWidth, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenWidth * (50 / 375),
      color: Color(0xff141718),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              onPressed: currentPage == 'home'
                  ? null
                  : () {
                      Get.offAllNamed('/homepage');
                    },
              icon: currentPage == 'home'
                  ? Icon(Icons.home,
                      size: screenWidth * (35 / 375), color: Colors.white)
                  : Icon(Icons.home_outlined, size: screenWidth * (35 / 375))),
          // IconButton(
          //     onPressed: () {},
          //     icon:
          //         Icon(Icons.widgets_outlined, size: screenWidth * (35 / 375))),
          // IconButton(
          //     onPressed: () {},
          //     icon: Icon(Icons.access_time_outlined,
          //         size: screenWidth * (35 / 375))),
          IconButton(
              onPressed: currentPage == 'profile'
                  ? null
                  : () {
                      Get.toNamed('/profilepage');
                    },
              icon: currentPage == 'profile'
                  ? Icon(Icons.person,
                      size: screenWidth * (35 / 375), color: Colors.white)
                  : Icon(Icons.person_outline, size: screenWidth * (35 / 375))),
        ],
      ),
    );
  }
}
