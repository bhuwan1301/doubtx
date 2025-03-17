import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as flutter_bloc;
import 'package:doubtx/Bloc/user_data_bloc.dart';
import 'package:get/get.dart';
import 'package:doubtx/Utils/user_utils.dart';
import 'package:doubtx/Bloc/messages_bloc.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> promptsAndResponses =
        context.watch<MessagesCubit>().state;
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
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: screenWidth * (24 / 375),
                ),
                onPressed: () {},
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: screenWidth * (24 / 375),
                  ),
                  onPressed: () {},
                ),
                Padding(
                  padding: EdgeInsets.only(right: screenWidth * (16 / 375)),
                  child: CircleAvatar(
                    radius: screenWidth * (18 / 375),
                    backgroundColor: Colors.grey[300],
                    child: IconButton(
                        onPressed: () {
                          Get.toNamed('/profilepage');
                        },
                        icon: Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: screenWidth * (20 / 375),
                        )),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(screenWidth * (20 / 375)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting and Welcome Message
                    Text(
                      "Hi ${user['firstName']}!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * (30 / 375),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenWidth * (4 / 375)),
                    Text(
                      "Welcome to DoubtX!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * (24 / 375),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenWidth * (12 / 375)),
                    Text(
                      "Your AI-powered study companion – Smart. Fast. Personalized",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * (14 / 375),
                      ),
                    ),
                    SizedBox(height: screenWidth * (24 / 375)),

                    // Features List
                    _buildFeatureItem(
                      "📚 Struggling with doubts? Need a study plan?",
                      screenWidth,
                    ),
                    SizedBox(height: screenWidth * (12 / 375)),
                    _buildFeatureItem(
                      "Want to know where you're lagging? DoubtX has you covered!",
                      screenWidth,
                    ),
                    SizedBox(height: screenWidth * (12 / 375)),
                    _buildFeatureItem(
                      "✨ Pick your path & start learning smarter.",
                      screenWidth,
                    ),
                    SizedBox(height: screenWidth * (36 / 375)),

                    // Action Buttons
                    _buildElevatedButton(
                      'Smart Study\nPlanner',
                      () {
                        Get.toNamed('/smartstudyplanner');
                      },
                      screenWidth,
                    ),
                    SizedBox(height: screenWidth * (16 / 375)),
                    _buildElevatedButton(
                      'Doubt Solver',
                      () {
                        Get.toNamed('/doubtSolver');
                      },
                      screenWidth,
                    ),
                    SizedBox(height: screenWidth * (16 / 375)),
                    _buildElevatedButton(
                      'Weak Point\nIdentifier',
                      () {
                        Get.toNamed('/weakPointIdentifier');
                      },
                      screenWidth,
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: DoubtXBottomNavBar(
              screenWidth: screenWidth,
              currentPage: 'home',
            ),
          );
  }

  Widget _buildFeatureItem(String text, double screenWidth) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white70,
        fontSize: screenWidth * (14 / 375),
      ),
    );
  }

  Widget _buildElevatedButton(
    String text,
    VoidCallback onPressed,
    double screenWidth,
  ) {
    return Container(
      width: screenWidth,
      height: screenWidth * (100 / 375),
      decoration: BoxDecoration(
        color: Colors.teal[700],
        borderRadius: BorderRadius.circular(screenWidth * (16 / 375)),
        boxShadow: [
          BoxShadow(
            color: Colors.teal[700]!,
            blurRadius: screenWidth * (8 / 375),
            offset: Offset(0, screenWidth * (4 / 375)),
          ),
        ],
        image: const DecorationImage(
          image: AssetImage('assets/pattern.png'),
          fit: BoxFit.cover,
          opacity: 0.3,
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * (16 / 375)),
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(right: screenWidth * (20 / 375)),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * (20 / 375),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
