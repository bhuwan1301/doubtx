import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doubtx/Utils/user_utils.dart';

class QuizAnalysisPage extends StatefulWidget {
  final Map<String, dynamic> questions;
  final Map<String, dynamic> chosenAnswers;

  const QuizAnalysisPage(
      {super.key, required this.questions, required this.chosenAnswers});

  @override
  State<QuizAnalysisPage> createState() => _QuizAnalysisPageState();
}

class _QuizAnalysisPageState extends State<QuizAnalysisPage> {
  int qno = 1;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
          body: Padding(
            padding: EdgeInsets.all(screenWidth * (20 / 375)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            List.generate(widget.questions.length, (index) {
                          final number = index + 1;
                          final isSelected =
                              number == qno; // Assuming 10 is selected

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
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
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: 0 == widget.questions["mcq$qno"]["Answer"]
                                  ? Colors.green
                                  : Colors.red),
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
                          // Add this wrapper
                          child: Text(
                            widget.questions["mcq$qno"]["Options"][0],
                            style: TextStyle(
                              fontSize:
                                  screenWidth * (16 / 375), // Fixed font size
                            ),
                            softWrap: true, // Enables text wrapping
                            overflow: TextOverflow
                                .visible, // or TextOverflow.ellipsis if you want ...
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: 1 == widget.questions["mcq$qno"]["Answer"]
                                  ? Colors.green
                                  : Colors.red),
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
                          // Add this wrapper
                          child: Text(
                            widget.questions["mcq$qno"]["Options"][1],
                            style: TextStyle(
                              fontSize:
                                  screenWidth * (16 / 375), // Fixed font size
                            ),
                            softWrap: true, // Enables text wrapping
                            overflow: TextOverflow
                                .visible, // or TextOverflow.ellipsis if you want ...
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: 2 == widget.questions["mcq$qno"]["Answer"]
                                  ? Colors.green
                                  : Colors.red),
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
                          // Add this wrapper
                          child: Text(
                            widget.questions["mcq$qno"]["Options"][2],
                            style: TextStyle(
                              fontSize:
                                  screenWidth * (16 / 375), // Fixed font size
                            ),
                            softWrap: true, // Enables text wrapping
                            overflow: TextOverflow
                                .visible, // or TextOverflow.ellipsis if you want ...
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: 3 == widget.questions["mcq$qno"]["Answer"]
                                  ? Colors.green
                                  : Colors.red),
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
                          // Add this wrapper
                          child: Text(
                            widget.questions["mcq$qno"]["Options"][3],
                            style: TextStyle(
                              fontSize:
                                  screenWidth * (16 / 375), // Fixed font size
                            ),
                            softWrap: true, // Enables text wrapping
                            overflow: TextOverflow
                                .visible, // or TextOverflow.ellipsis if you want ...
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  if (widget.chosenAnswers['mcq$qno'] != null)
                    Text("✅ Attempted"),
                  if (widget.chosenAnswers['mcq$qno'] == null)
                    Text("❌ Not Attempted"),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              color:
                                  qno == 1 ? Colors.grey : Color(0xff11A8AE)),
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.arrow_left,
                            size: screenWidth * (30 / 375),
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
                  )
                ],
              ),
            ),
          ),
        );
  }
}
