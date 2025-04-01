// import 'package:doubtx/Utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as flutter_bloc;
import 'package:doubtx/Bloc/user_data_bloc.dart';
import 'package:get/get.dart';
import 'package:doubtx/Utils/user_utils.dart';
import 'package:doubtx/Pages/Userpages/startquiz.dart';

class ChooseLevel extends StatefulWidget {
  final String weakTopic;
  const ChooseLevel({super.key, required this.weakTopic});

  @override
  State<ChooseLevel> createState() => _ChooseLevelState();
}

class _ChooseLevelState extends State<ChooseLevel> {
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
              leading: IconButton(
                  onPressed: () {
                    Get.back();
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting and Welcome Message

                    Text(
                      "📊 Weak Point Identifier - Strengthen Your Foundations with BodhX!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * (20 / 375),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenWidth * (12 / 375)),
                    Text(
                      "BodhX tracks your weak areas based on your doubts and study progress. To help you improve, each weak area comes with a Take MCQ Quiz button, offering:",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * (14 / 375),
                      ),
                    ),
                    SizedBox(height: screenWidth * (24 / 375)),

                    // Features List
                    _buildFeatureItem(
                      "✅ Easy Mode: 20 questions in 20 minutes",
                      screenWidth,
                    ),
                    SizedBox(height: screenWidth * (12 / 375)),
                    _buildFeatureItem(
                      "✅ Hard Mode: 10 challenging questions in 20 minutes",
                      screenWidth,
                    ),
                    SizedBox(height: screenWidth * (12 / 375)),
                    _buildFeatureItem(
                      "Achieve 90% accuracy or more in both modes, and the weak area will be automatically removed from your list! 🚀",
                      screenWidth,
                    ),
                    SizedBox(height: screenWidth * (12 / 375)),
                    Center(
                        child: Text(
                      widget.weakTopic,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: screenWidth * (34 / 375),
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    )),
                    SizedBox(height: 20),

                    // Action Buttons

                    _buildElevatedButton(
                      'Easy Mode',
                      () {
                        Get.to(StartQuizPage(
                          level: 'easy',
                          topic: widget.weakTopic,
                        ));
                      },
                      screenWidth,
                    ),
                    SizedBox(height: screenWidth * (16 / 375)),
                    _buildElevatedButton(
                      'Hard Mode',
                      () {
                        Get.to(StartQuizPage(
                          level: 'hard',
                          topic: widget.weakTopic,
                        ));
                      },
                      screenWidth,
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
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
