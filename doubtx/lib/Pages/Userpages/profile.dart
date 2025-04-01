import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as flutter_bloc;
import 'package:doubtx/Bloc/user_data_bloc.dart';
import 'package:get/get.dart';
import 'package:doubtx/Utils/user_utils.dart';
import 'package:doubtx/Bloc/messages_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? user = context.watch<DataCubit>().state;

    double screenWidth = MediaQuery.of(context).size.width;

    return user == null
        ? Scaffold(
            backgroundColor: CommonUserUtils.bgColor,
            body: Center(
              child: SizedBox(
                height: screenWidth * (20 / 375),
                width: screenWidth * (20 / 375),
                child: CircularProgressIndicator(
                  strokeWidth: screenWidth * (2 / 375),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ),
            ),
          )
        : Scaffold(
            backgroundColor: CommonUserUtils.bgColor,
            appBar: AppBar(
              backgroundColor: CommonUserUtils.bgColor,
              centerTitle: true,
              title: Text(
                "Profile",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                  onPressed: () {
                    Get.offAllNamed('/homepage');
                  },
                  icon: Image.asset(
                    'assets/Back.png',
                    width: screenWidth * (35 / 375),
                  )),
            ),
            body: Padding(
              padding: EdgeInsets.all(screenWidth * (20 / 375)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 30),
                    Stack(children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[900], shape: BoxShape.circle),
                        height: screenWidth * (150 / 375),
                      ),
                      Center(
                        child: Icon(
                          Icons.person,
                          size: screenWidth * (140 / 375),
                        ),
                      ),
                    ]),
                    SizedBox(height: 15),
                    Text(
                      "${user['firstName']} ${user['lastName']}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: screenWidth * (22 / 375),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "${user['mailAddr']}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: screenWidth * (14 / 375),
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 30),
                    _buildElevatedButton(
                        "Preferences", () {}, screenWidth, Icons.settings),
                    SizedBox(height: 30),
                    _buildElevatedButton("Customer Support", () {}, screenWidth,
                        Icons.question_mark),
                    SizedBox(height: 30),
                    _buildElevatedButton("Logout", () {
                      Get.defaultDialog(
                          title: "Log Out?",
                          content: Text(
                            "Are you sure you want to log out?",
                            style: TextStyle(color: Colors.white),
                          ),
                          titlePadding: EdgeInsets.all(10),
                          contentPadding: EdgeInsets.all(10),
                          textConfirm: "Yes",
                          textCancel: "No",
                          backgroundColor: Color(0xff141718),
                          buttonColor: Color(0xff141718),
                          radius: 15,
                          cancelTextColor: Colors.blue,
                          confirmTextColor: Colors.red,
                          titleStyle: TextStyle(color: Colors.white),
                          onCancel: () {},
                          onConfirm: () {
                            context.read<DataCubit>().signOut();
                            context.read<MessagesCubit>().clearData();
                            Get.offAllNamed('/loginpage');
                          });
                    }, screenWidth, Icons.logout),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: DoubtXBottomNavBar(
              screenWidth: screenWidth,
              currentPage: 'profile',
            ),
          );
  }

  Widget _buildElevatedButton(
    String text,
    VoidCallback onPressed,
    double screenWidth,
    IconData icon,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: CommonUserUtils.bgColor,
        padding: EdgeInsets.all(10),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(
            icon,
            size: screenWidth * (30 / 375),
            color: Colors.white,
          ),
          SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
                color: Colors.white, fontSize: screenWidth * (20 / 375)),
          ),
        ],
      ),
    );
  }
}
