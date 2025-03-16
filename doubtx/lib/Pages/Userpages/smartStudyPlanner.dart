import 'dart:convert';

import 'package:doubtx/Bloc/user_data_bloc.dart';
import 'package:doubtx/Utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:doubtx/env.dart';

class SmartStudyPlannerPage extends StatefulWidget {
  const SmartStudyPlannerPage({Key? key}) : super(key: key);

  @override
  State<SmartStudyPlannerPage> createState() => _SmartStudyPlannerPageState();
}

class _SmartStudyPlannerPageState extends State<SmartStudyPlannerPage> {
  bool isUpdating = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    Map<String, dynamic>? user = context.watch<DataCubit>().state;
    Map<String, dynamic>? studyplan = user?['StudyPlan'];

    if (studyplan == null) {
      return const Center(child: CircularProgressIndicator());
    }

    int dailyTarget = studyplan['dailyTarget'] ?? 0;
    Map<String, dynamic> subjects = studyplan['subjects'] ?? {};
    int totalTopics = 0;

    // Count total topics across all subjects
    subjects.forEach((subject, data) {
      if (data['topics'] is List) {
        totalTopics += (data['topics'] as List).length;
      }
    });

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
              // Header Section
              Text(
                "📅Your Personalized",
                style: TextStyle(
                    fontSize: screenWidth * (24 / 375),
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Study Plan by BodhX",
                style: TextStyle(
                    fontSize: screenWidth * (24 / 375),
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Smart. Dynamic. Always Up-to-Date. 🚀",
                style: TextStyle(fontSize: screenWidth * (14 / 375)),
              ),
              Text(
                "Meet BodhX, your AI tutor inside DoubtX! This adaptive study plan evolves with you—whether you ask a doubt, identify weak areas, or just need an updated plan. Hit \"Update\" anytime to refresh your schedule and keep progressing!",
                style: TextStyle(fontSize: screenWidth * (14 / 375)),
              ),
              const SizedBox(height: 24),

              // Daily Target
              Text(
                'Daily Target',
                style: TextStyle(
                  fontSize: screenWidth * (18 / 375),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$totalTopics Topics • ${dailyTarget} Hours',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 24),
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
                                } else {
                                  Get.snackbar("Couldn't update",
                                      "Please try again later");
                                }
                              } catch (e) {
                                Get.snackbar("Error", e.toString());
                              }

                              setState(() {
                                isUpdating = false;
                              });
                            },
                      child: Text(
                        "UPDATE",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * (14 / 375),
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
              const SizedBox(height: 24),

              // Subjects heading
              Text(
                'Subjects',
                style: TextStyle(
                  fontSize: screenWidth * (24 / 375),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Subjects list
              ...subjects.entries.map((entry) {
                String subjectName = entry.key;
                Map<String, dynamic> subjectData = entry.value;
                List<dynamic> topics = subjectData['topics'] ?? [];
                double hours = double.parse(subjectData['hours'].toString());

                return SubjectCard(
                  subject: subjectName,
                  topics: topics.cast<String>(),
                  hours: hours,
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class SubjectCard extends StatelessWidget {
  final String subject;
  final List<String> topics;
  final double hours;

  const SubjectCard({
    Key? key,
    required this.subject,
    required this.topics,
    required this.hours,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.teal[600],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/subjpattern.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subject header with icon
                Row(
                  children: [
                    const Icon(
                      Icons.book_outlined,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      subject,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Topic list (show up to 4)
                ...List.generate(
                  topics.length,
                  (index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: screenWidth * (14 / 375),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            ': ',
                            style: TextStyle(
                              fontSize: screenWidth * (14 / 375),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _getShortTopicName(topics[index]),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * (14 / 375)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 8),

                // Topics count and hours
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${topics.length} Topics',
                        style: TextStyle(
                          fontSize: screenWidth * (14 / 375),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: screenWidth * (8 / 375),
                            color: Colors.black,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$hours hrs',
                            style: TextStyle(
                              fontSize: screenWidth * (14 / 375),
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper to get shorter topic names by trimming after the colon
  String _getShortTopicName(String fullTopic) {
    if (fullTopic.contains(':')) {
      return fullTopic.split(':')[1].trim();
    }
    return fullTopic;
  }
}
