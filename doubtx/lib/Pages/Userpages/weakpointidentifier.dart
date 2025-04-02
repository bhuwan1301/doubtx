import 'dart:convert';
import 'dart:math';
import 'package:doubtx/Utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doubtx/Bloc/user_data_bloc.dart';
import 'package:doubtx/Utils/user_utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:doubtx/Pages/Userpages/chooselevel.dart';
import 'package:doubtx/env.dart';

class WeakPointIdentifierPage extends StatefulWidget {
  const WeakPointIdentifierPage({Key? key}) : super(key: key);

  @override
  State<WeakPointIdentifierPage> createState() =>
      _WeakPointIdentifierPageState();
}

class _WeakPointIdentifierPageState extends State<WeakPointIdentifierPage> {
  bool isUpdating = false;
  bool isRemovingWeakTopics = false;
  List<String> selectedTopics = [];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Get the user data using BLoC
    Map<String, dynamic>? user = context.watch<DataCubit>().state;
    Map<String, dynamic>? weakPoints = user?['WeakPoints'];

    return Scaffold(
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "📊Weak Point",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * (26 / 375),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Identifier by BodhX",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * (26 / 375),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Know Your Gaps. Improve Smarter. 🚀",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: screenWidth * (14 / 375),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "BodhX has analyzed your doubts and study plan to pinpoint areas that need extra focus. Your weak points are automatically updated whenever you ask a doubt or refresh your study plan. Keep refining your skills—tap 'Update' anytime for the latest insights!",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: screenWidth * (14 / 375),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "⚠️Warning: updating will also modify your study plan to help you focus on weak areas.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: screenWidth * (14 / 375),
                ),
              ),

              SizedBox(height: 10),
              Center(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        color: isUpdating
                            ? Color.fromARGB(133, 17, 169, 174)
                            : Color(0xff11A8AE),
                        borderRadius: BorderRadius.circular(15)),
                    child: GestureDetector(
                      onTap: isUpdating
                          ? null
                          : () async {
                              setState(() {
                                isUpdating = true;
                              });
                              try {
                                final updateresponse =
                                    await http.post(ENV.updateurl,
                                        headers: {
                                          'Content-Type': 'application/json',
                                        },
                                        body: jsonEncode({
                                          'username': user!['userName'],
                                        }));

                                if (updateresponse.statusCode == 200) {
                                  final updateresponseData =
                                      jsonDecode(updateresponse.body);
                                  user['WeakPoints'] =
                                      updateresponseData['weakPoints'];
                                  user['StudyPlan'] =
                                      updateresponseData['studyPlan'];
                                  context.read<DataCubit>().updateData(user);
                                  CommonUtils.myDialogueBox(
                                      title: "Updated",
                                      middleText:
                                          "Your data has been updated succesfully", textCancel: "Ok");
                                } else {
                                  CommonUtils.myDialogueBox(
                                      title: "Couldn't update",
                                      middleText: "Please try again later", textCancel: "Ok");
                                }
                              } catch (e) {
                                CommonUtils.myDialogueBox(
                                    title: "Error", middleText: e.toString(), textCancel: "Ok");
                              }

                              setState(() {
                                isUpdating = false;
                              });
                            },
                      child: Text(
                        isUpdating ? "UPDATING..." : "UPDATE",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * (14 / 375),
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
              SizedBox(height: 15),
              Text(
                'Subjects',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * (24 / 375),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),

              // Dynamically build subject containers based on weakPoints data
              if (weakPoints != null)
                ...weakPoints.entries.map((entry) {
                  final subject = entry.key;
                  final topicsList = entry.value as List<dynamic>;

                  return Column(
                    children: [
                      _buildSubjectContainer(
                          subject, topicsList, screenWidth, user!),
                      SizedBox(height: 8),
                    ],
                  );
                }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectContainer(String subject, List<dynamic> topics,
      double screenWidth, Map<String, dynamic> user) {
    return topics.isNotEmpty
        ? Container(
            decoration: BoxDecoration(
              color: Colors.teal[700],
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                image: AssetImage('assets/subjpattern.png'),
                fit: BoxFit.cover,
                opacity: 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.menu_book_outlined,
                          color: Colors.white, size: 30),
                      SizedBox(width: 8),
                      Text(
                        subject,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // If there are topics, list them
                if (topics.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: topics.length,
                    itemBuilder: (context, index) {
                      final topic = topics[index];
                      return Container(
                        margin: EdgeInsets.only(
                            bottom: index == topics.length - 1 ? 0 : 8,
                            right: 10,
                            left: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${index + 1}.',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                topic,
                                style: TextStyle(
                                  fontSize: screenWidth * (15 / 375),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Get.to(ChooseLevel(weakTopic: topic));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 0),
                                  minimumSize:
                                      Size(0, 24), // Add this to reduce height
                                  tapTargetSize: MaterialTapTargetSize
                                      .shrinkWrap, // Add this to remove default padding
                                ),
                                child: Text(
                                  "Take Quiz",
                                  style: TextStyle(
                                      fontSize: screenWidth *
                                          (10 / 375), // Reduced font size
                                      color: Colors.black),
                                ))
                          ],
                        ),
                      );
                    },
                  ),
                // // If there are no topics, show a "doing great" message
                // else
                //   Container(
                //     margin: EdgeInsets.only(bottom: 16),
                //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                //     decoration: BoxDecoration(
                //       color: Colors.black.withOpacity(0.3),
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     child: SizedBox(
                //       width: screenWidth,
                //       child: Text(
                //         randomStrings[getRandomInt()],
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),

                SizedBox(height: 16),
              ],
            ),
          )
        : Container();
  }
}

List<String> randomStrings = [
  "🔥 You're doing great here!",
  "🎯 No weak points detected!",
  "🚀 Solid understanding so far!",
  "🎉 Keep up the good work!",
  "💡 Looking strong in this subject!",
  "🏆 No major gaps—great job!",
  "📚 Well-covered so far!",
  "✅ You're on the right track!",
  "🌟 Outstanding progress!",
  "💪 Your efforts are paying off!",
  "🎖️ Impressive work!",
  "🎵 Learning in perfect harmony!",
  "⚡ Quick and accurate—well done!",
  "🌱 Growing stronger every day!",
  "🏅 A top-notch performance!",
  "🧠 Sharp thinking—keep it up!",
  "🔝 You're reaching new heights!",
  "🚦 Smooth progress ahead!",
  "🔑 You've unlocked key concepts!",
  "💯 Excellence in action!"
];

int getRandomInt() {
  Random random = Random();
  return random.nextInt(20); // Generates a number from 0 to 19
}
