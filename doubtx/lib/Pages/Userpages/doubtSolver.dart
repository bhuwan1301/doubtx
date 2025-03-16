import 'dart:convert';
import 'package:doubtx/Bloc/user_data_bloc.dart';
import 'package:doubtx/env.dart';
import 'package:doubtx/Bloc/messages_bloc.dart';
import 'package:doubtx/Utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DoubtSolverPage extends StatefulWidget {
  const DoubtSolverPage({Key? key}) : super(key: key);

  @override
  State<DoubtSolverPage> createState() => _DoubtSolverPageState();
}

class _DoubtSolverPageState extends State<DoubtSolverPage> {
  final TextEditingController _textController = TextEditingController();
  late List<dynamic>? prompts;
  late List<dynamic>? responses;
  bool fetchingResponse = false;

  // Add a ScrollController to manage scrolling
  final ScrollController _scrollController = ScrollController();

  // Function to scroll to bottom of the list
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }

  // Add initState to handle initial state setup
  @override
  void initState() {
    super.initState();
    // Add post-frame callback to scroll to bottom after build completes
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? user = context.watch<DataCubit>().state;

    double screenWidth = MediaQuery.of(context).size.width;
    Map<String, dynamic> promptsAndResponses =
        context.watch<MessagesCubit>().state;
    prompts = promptsAndResponses['userPrompts'];
    responses = promptsAndResponses['bodhxResponses'];

    // Add post-frame callback to scroll to bottom when new messages arrive
    if (prompts != null && prompts!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }

    return Scaffold(
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
        actions: [
          IconButton(
              onPressed: () {
                Get.defaultDialog(
                  titlePadding: EdgeInsets.only(top: 10),
                  contentPadding: EdgeInsets.all(20),
                  title: "Clear conversations?",
                  middleText:
                      "Are you sure you want to clear conversations with BodhX?",
                  onCancel: () {},
                  onConfirm: () {
                    context.read<MessagesCubit>().clearData();
                    setState(() {});
                    Get.back();
                  },
                );
              },
              icon: Icon(Icons.delete)),
          // IconButton(
          //     onPressed: () {},
          //     icon: Image.asset(
          //       'assets/threedots.png',
          //       width: screenWidth * (35 / 375),
          //     )),
        ],
      ),
      backgroundColor: CommonUserUtils.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            if (prompts!.isEmpty)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "BodhX",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * (45 / 375),
                          color: Colors.white),
                    ),
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.all(30),
                      width: screenWidth * 0.8,
                      decoration: BoxDecoration(
                          color: Color(0xff11A8AE),
                          borderRadius: BorderRadius.circular(15)),
                      child: Text(
                        "Remembers what user said earlier in the conversation",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * (14 / 375)),
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.all(30),
                      width: screenWidth * 0.8,
                      decoration: BoxDecoration(
                          color: Color(0xff232627),
                          borderRadius: BorderRadius.circular(15)),
                      child: Text(
                        "Allows user to provide follow-up correction with AI",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: screenWidth * (14 / 375)),
                      ),
                    ),
                  ],
                ),
              ),

            if (!prompts!.isEmpty)
              Expanded(
                child: ListView.builder(
                    controller:
                        _scrollController, // Add the scrollController here
                    itemCount: prompts!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(15),
                            color: Colors.transparent,
                            width: screenWidth,
                            child: Text(
                              prompts![index],
                              style:
                                  TextStyle(fontSize: screenWidth * (14 / 375)),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            color: Color(0xff232627),
                            width: screenWidth,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      'assets/logo/logo.png',
                                      width: screenWidth * (60 / 375),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(
                                              text: responses![index]));
                                          Get.snackbar("Copied",
                                              "Response has been copied to clipboard",
                                              margin: EdgeInsets.all(10),
                                              colorText: Colors.black,
                                              backgroundColor: Colors.grey[200],
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              duration:
                                                  const Duration(seconds: 1));
                                        },
                                        icon: Icon(
                                          Icons.copy,
                                          size: screenWidth * (20 / 375),
                                        ))
                                  ],
                                ),
                                // Replace the existing Markdown widget with this:
                                MarkdownBody(
                                  data: responses![index], 
                                  selectable: true, 
                                ),                                
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            if (fetchingResponse)
              Container(
                width: screenWidth * 0.5,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(0xff11A8AE),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Generating Reponse...",
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      width: 10,
                      height: 10,
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 1,
                      )),
                    )
                  ],
                ),
              ),

            // Bottom input field area
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                children: [
                  // Mic icon button
                  IconButton(
                    icon: const Icon(Icons.mic, color: Colors.white),
                    onPressed: () {}, // Left as null as requested
                  ),

                  // Text input field
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff232627),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          controller: _textController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Type a message',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Send button
                  SizedBox(width: screenWidth * (8 / 375)),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                    child: IconButton(
                      icon: Image(image: AssetImage('assets/send.png')),
                      onPressed: _textController.text.trim().isEmpty
                          ? null
                          : fetchingResponse
                              ? null
                              : () async {
                                  setState(() {
                                    fetchingResponse = true;
                                  });
                                  try {
                                    final getresponse =
                                        await http.post(ENV.getresponseurl,
                                            headers: {
                                              'Content-Type':
                                                  'application/json',
                                            },
                                            body: jsonEncode({
                                              'username': user!['userName'],
                                              'prompt': _textController.text,
                                            }));

                                    if (getresponse.statusCode == 200) {
                                      final getresponsedata =
                                          jsonDecode(getresponse.body);
                                      responses!.add(
                                          getresponsedata['response']['text']);
                                      prompts!.add(_textController.text.trim());
                                      promptsAndResponses['userPrompts'] =
                                          prompts!;
                                      promptsAndResponses['bodhxResponses'] =
                                          responses!;
                                      context
                                          .read<MessagesCubit>()
                                          .updateData(promptsAndResponses);
                                      setState(() {
                                        _textController.clear();
                                      });
                                    } else {
                                      Get.snackbar("Failed",
                                          "Couldn't get the response, please try again later");
                                    }
                                  } catch (e) {
                                    Get.snackbar("Error", e.toString());
                                  }
                                  setState(() {
                                    fetchingResponse = false;
                                  });
                                },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
