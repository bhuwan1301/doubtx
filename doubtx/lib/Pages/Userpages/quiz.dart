import 'dart:async';
import 'dart:convert';
import 'package:doubtx/Pages/Userpages/quizanalysis.dart';
import 'package:doubtx/Utils/common_utils.dart';
import 'package:doubtx/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as flutter_bloc;
import 'package:doubtx/Bloc/user_data_bloc.dart';
import 'package:get/get.dart';
import 'package:doubtx/Utils/user_utils.dart';
import 'package:http/http.dart' as http;

class QuizPage extends StatefulWidget {
  final Map<String, dynamic> questions;
  final String topic;
  const QuizPage({super.key, required this.questions, required this.topic});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int qno = 1;
  bool quizended = false;
  bool endingQuiz = false;
  int score = 0;
  Map<String, dynamic> chosenAnswers = {};

  // Timer variables
  Timer? _timer;
  int _timeLeft = 20 * 60; // 20 minutes in seconds

  @override
  void initState() {
    super.initState();
    // Start the timer when the page loads
    startTimer();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  // Function to start the timer
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          // When timer reaches zero, cancel it and call the submit function
          _timer?.cancel();
          if (!quizended && !endingQuiz) {
            submitQuiz();
          }
        }
      });
    });
  }

  // Format time as MM:SS
  String formatTime() {
    int minutes = _timeLeft ~/ 60;
    int seconds = _timeLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // The submit quiz function
  Future<void> submitQuiz() async {
    if (endingQuiz) return;

    Map<String, dynamic>? user = context.read<DataCubit>().state;

    setState(() {
      endingQuiz = true;
    });

    int total = 0;
    for (int i = 1; i <= widget.questions.length; i++) {
      print(widget.questions["mcq$i"]["Answer"]);
      print(chosenAnswers["mcq$i"]);
      if (chosenAnswers["mcq$i"] != null &&
          widget.questions["mcq$i"]["Answer"] == chosenAnswers["mcq$i"]) {
        total++;
      }
    }

    await Future.delayed(const Duration(seconds: 2));
    if ((total / widget.questions.length) >= 0.9) {
      print("Removing weak point");
      final removeweakpointresponse = await http.post(ENV.removeweakpointurl,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'username': user!['userName'],
            'weakpoint': widget.topic,
          }));
      if (removeweakpointresponse.statusCode == 200) {
        final removeweakpointresponsebody =
            jsonDecode(removeweakpointresponse.body);
        user['WeakPoints'] = removeweakpointresponsebody['newWeakPoints'];
        context.read<DataCubit>().updateData(user);
        print("Removed weak point");
      } else {
        CommonUtils.mySnackbar(
            "Something went wrong", "We couldn't modify your weak points.");
      }
    }
    print("Score: $total");

    setState(() {
      endingQuiz = false;
      score = total;
      quizended = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? user = context.watch<DataCubit>().state;

    double screenWidth = MediaQuery.of(context).size.width;

    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) return;
          if (quizended) {
            Get.back();
          } else {
            Get.defaultDialog(
                title: "End Quiz?",
                content: Text(
                  "Are you sure you want to end this quiz? All your progress will be lost.",
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
                  // Cancel the timer when quitting
                  _timer?.cancel();
                  Get.back();
                  Get.back();
                });
          }
        },
        child: Scaffold(
          backgroundColor: CommonUserUtils.bgColor,
          body: Padding(
            padding: EdgeInsets.all(screenWidth * (20 / 375)),
            child: SingleChildScrollView(
              child: !quizended
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        // Timer display at the top right
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            decoration: BoxDecoration(
                              color: _timeLeft < 60
                                  ? Colors.red
                                  : Color(0xff11A8AE),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.timer,
                                    color: Colors.white, size: 20),
                                SizedBox(width: 5),
                                Text(
                                  formatTime(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 50,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(widget.questions.length,
                                  (index) {
                                final number = index + 1;
                                final isSelected =
                                    number == qno; // Assuming 10 is selected

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: GestureDetector(
                                    onTap: () {
                                      print("Setting");
                                      setState(() {
                                        qno = number;
                                      });
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Color(0xff11A8AE)
                                            : Colors.grey.shade300,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          number.toString(),
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.grey.shade700,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 20),
                        Text(
                          widget.questions["mcq$qno"]["Question"],
                          style: TextStyle(
                            fontSize: screenWidth * (18 / 375),
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: endingQuiz == true
                              ? null
                              : () {
                                  setState(() {
                                    chosenAnswers["mcq$qno"] = 0;
                                  });
                                },
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: chosenAnswers["mcq$qno"] == 0
                                        ? Color(0xff11A8AE)
                                        : Colors.grey),
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  "A",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenWidth * (16 / 375),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  widget.questions["mcq$qno"]["Options"][0],
                                  style: TextStyle(
                                    fontSize: screenWidth * (16 / 375),
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: endingQuiz == true
                              ? null
                              : () {
                                  setState(() {
                                    chosenAnswers["mcq$qno"] = 1;
                                  });
                                },
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: chosenAnswers["mcq$qno"] == 1
                                        ? Color(0xff11A8AE)
                                        : Colors.grey),
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  "B",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenWidth * (16 / 375),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  widget.questions["mcq$qno"]["Options"][1],
                                  style: TextStyle(
                                    fontSize: screenWidth * (16 / 375),
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: endingQuiz == true
                              ? null
                              : () {
                                  setState(() {
                                    chosenAnswers["mcq$qno"] = 2;
                                  });
                                },
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: chosenAnswers["mcq$qno"] == 2
                                        ? Color(0xff11A8AE)
                                        : Colors.grey),
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  "C",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenWidth * (16 / 375),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  widget.questions["mcq$qno"]["Options"][2],
                                  style: TextStyle(
                                    fontSize: screenWidth * (16 / 375),
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: endingQuiz == true
                              ? null
                              : () {
                                  setState(() {
                                    chosenAnswers["mcq$qno"] = 3;
                                  });
                                },
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: chosenAnswers["mcq$qno"] == 3
                                        ? Color(0xff11A8AE)
                                        : Colors.grey),
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  "D",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenWidth * (16 / 375),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  widget.questions["mcq$qno"]["Options"][3],
                                  style: TextStyle(
                                    fontSize: screenWidth * (16 / 375),
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                            "Answered: ${chosenAnswers.length}/${widget.questions.length}"),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (qno != 1) {
                                  setState(() {
                                    qno--;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: qno == 1
                                        ? Colors.grey
                                        : Color(0xff11A8AE)),
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.arrow_left,
                                  size: screenWidth * (30 / 375),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: endingQuiz ? null : submitQuiz,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 0),
                                child: Text(
                                  "Submit",
                                  style: TextStyle(color: Color(0xff11A8AE)),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (qno != widget.questions.length) {
                                  setState(() {
                                    qno++;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: qno == widget.questions.length
                                        ? Colors.grey
                                        : Color(0xff11A8AE)),
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.arrow_right,
                                  size: screenWidth * (30 / 375),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        if (endingQuiz)
                          Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            ),
                          )
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 40),
                        Center(
                          child: Text(
                            "${score * 100 / widget.questions.length}%",
                            style: TextStyle(
                                color: Color(0xff11A8AE),
                                fontSize: screenWidth * (50 / 375),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            "Quiz result",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * (30 / 375),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            "You have answered ${score}/${widget.questions.length} questions correctly.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * (20 / 375),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(QuizAnalysisPage(
                              questions: widget.questions,
                              chosenAnswers: chosenAnswers,
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff11A8AE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            elevation: 4,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.bar_chart,
                                color: Colors.white,
                                size: 28,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Quiz Analytics',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                            onPressed: () {
                              Get.back();
                              Get.back();
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white, elevation: 0),
                            child: Text(
                              "Continue",
                              style: TextStyle(color: Color(0xff11A8AE)),
                            ))
                      ],
                    ),
            ),
          ),
        ));
  }
}
