import 'dart:convert';
import 'package:doubtx/Utils/common_utils.dart';
import 'package:doubtx/Bloc/user_data_bloc.dart';
import 'package:doubtx/env.dart';
import 'package:flutter/material.dart';
import 'package:doubtx/Utils/user_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:doubtx/Pages/Userpages/quiz.dart';
import 'package:http/http.dart' as http;

class StartQuizPage extends StatefulWidget {
  final String level;
  final String topic;
  const StartQuizPage({super.key, required this.level, required this.topic});

  @override
  State<StartQuizPage> createState() => _StartQuizPageState();
}

class _StartQuizPageState extends State<StartQuizPage> {
  bool startingquiz = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Map<String, dynamic>? user = context.watch<DataCubit>().state;

    return Scaffold(
      backgroundColor: CommonUserUtils.bgColor,
      body: Padding(
        padding: EdgeInsets.all(screenWidth * (20 / 375)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                "Brief explanation about this quiz.",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * (20 / 375)),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(255, 42, 42, 42)),
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.article,
                      size: screenWidth * (30 / 375),
                    ),
                  ),
                  SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.level == "easy"
                          ? Text(
                              "20 Questions",
                              style:
                                  TextStyle(fontSize: screenWidth * (16 / 375)),
                            )
                          : Text(
                              "10 Questions",
                              style:
                                  TextStyle(fontSize: screenWidth * (16 / 375)),
                            ),
                      widget.level == "easy"
                          ? Text(
                              "20 questions of easy difficulty",
                              style: TextStyle(
                                  fontSize: screenWidth * (12 / 375),
                                  color: Colors.grey),
                            )
                          : Text(
                              "10 questions of hard difficulty",
                              style: TextStyle(
                                  fontSize: screenWidth * (12 / 375),
                                  color: Colors.grey),
                            ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(255, 42, 42, 42)),
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.access_time,
                      size: screenWidth * (30 / 375),
                    ),
                  ),
                  SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "20 minutes",
                        style: TextStyle(fontSize: screenWidth * (16 / 375)),
                      ),
                      Text(
                        "Total duration of the quiz",
                        style: TextStyle(
                            fontSize: screenWidth * (12 / 375),
                            color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Please read the text below carefully so you can understand it",
                style: TextStyle(fontSize: screenWidth * (14 / 375)),
              ),
              SizedBox(height: 10),
              Text("🔵 Think Fast! Questions are tricky and time-bound. ⏳"),
              SizedBox(height: 10),
              Text("🔵 No Guesswork! Accuracy matters—aim for 90%+! 🎯"),
              SizedBox(height: 10),
              Text(
                  "🔵 Concept Over Speed! Focus on logic, not just quick answers. 🧠"),
              SizedBox(height: 10),
              Text(
                  "🔵 Score 90% or more to remove this weak topic from your profile. 🔥"),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                    onPressed: startingquiz
                        ? null
                        : () async {
                            setState(() {
                              startingquiz = true;
                            });
                            try {
                              print("Fetching quiz response");
                              final quizresponse = await http.post(ENV.quizurl,
                                  headers: {
                                    'Content-Type': 'application/json',
                                  },
                                  body: jsonEncode({
                                    'topic': widget.topic,
                                    'username': user!['userName'],
                                    'num': widget.level == "easy" ? 20 : 10,
                                  }));
                              print("Quiz response fetched");
                              if (quizresponse.statusCode == 200) {
                                print("Success");
                                final quizresponsebody =
                                    jsonDecode(quizresponse.body);
                                print(quizresponsebody['resp']['mcqs']);
                                Get.to(QuizPage(questions: quizresponsebody['resp']['mcqs'], topic: widget.topic,));
                              } else {
                                CommonUtils.mySnackbar("Couldn't load quiz",
                                    "Please try again later");
                              }
                            } catch (e) {
                              CommonUtils.mySnackbar("Error", e.toString());
                              print(e.toString());
                            }

                            setState(() {
                              startingquiz = false;
                            });
                          },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff11A8AE),
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 15)),
                    child: Text(
                      "START QUIZ",
                      style: TextStyle(color: Colors.black),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
