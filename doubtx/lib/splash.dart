import 'package:doubtx/Utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doubtx/Bloc/data_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
    _navigateToWrapper();
  }

  void _navigateToWrapper()async{
    await Future.delayed(const Duration(seconds: 3));
    Get.offAllNamed('wrapper');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    Map<String, dynamic> user = context.watch<DataCubit>().state;

    return Scaffold(
        backgroundColor: CommonUtils.bgColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(),
            Image.asset(
              'assets/logo/logo.png',
              width: screenWidth * 0.8,
            ),
            Column(
              children: [
                Text(
                  "DOUBTX",
                  style: TextStyle(
                      color: Colors.white, fontSize: screenWidth * (26 / 375)),
                ),
                Text(
                  "Version 1.0",
                  style: TextStyle(
                      color: Colors.grey, fontSize: screenWidth * (14 / 375)),
                ),
                SizedBox(height: 5)
              ],
            )
          ],
        ));
  }
}
