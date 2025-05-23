import 'dart:async';
import 'dart:convert';
import 'package:doubtx/Bloc/user_data_bloc.dart';
import 'package:doubtx/Utils/common_utils.dart';
import 'package:doubtx/env.dart';
import 'package:doubtx/Bloc/messages_bloc.dart';
import 'package:doubtx/Utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

// Debouncer class to handle delayed actions
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

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
  String _currentText = ''; // Track the current text input
  final _debouncer = Debouncer(milliseconds: 50); // Create a debouncer

  // Speech to text variables
  late stt.SpeechToText _speech;
  bool _isListening = false;

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
    _debouncer.dispose(); // Dispose the debouncer
    super.dispose();
  }

  // Add initState to handle initial state setup
  @override
  void initState() {
    super.initState();
    // Initialize speech to text
    _speech = stt.SpeechToText();
    // Add post-frame callback to scroll to bottom after build completes
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  // Initialize speech recognition
  Future<void> _initSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'notListening') {
          setState(() {
            _isListening = false;
          });
        }
      },
      onError: (errorNotification) {
        setState(() {
          _isListening = false;
        });
        CommonUtils.myDialogueBox(
            title: "Speech Error",
            middleText:
                "Speech recognition failed: ${errorNotification.errorMsg}", textCancel: "Ok");
      },
    );

    if (!available) {
      CommonUtils.myDialogueBox(
          title: "Speech Unavailable",
          middleText: "Speech recognition is not available on this device", textCancel: "Ok");
    }
  }

  // Toggle speech recognition
  void _toggleListening() async {
    if (!_isListening) {
      // Make sure speech is initialized
      if (!_speech.isAvailable) {
        await _initSpeech();
      }

      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
        });

        await _speech.listen(
          onResult: (result) {
            setState(() {
              _currentText = result.recognizedWords;
              _textController.text = _currentText;
              // Move cursor to end of text
              _textController.selection = TextSelection.fromPosition(
                TextPosition(offset: _textController.text.length),
              );
            });
          },
          listenFor: Duration(seconds: 30),
          pauseFor: Duration(seconds: 3),
          partialResults: true,
          localeId: 'en_US', // You can change this to support other languages
        );
      }
    } else {
      setState(() {
        _isListening = false;
      });
      _speech.stop();
    }
  }

  // Send message function
  Future<void> _sendMessage() async {
    if (_currentText.trim().isEmpty || fetchingResponse) return;

    Map<String, dynamic>? user = context.read<DataCubit>().state;
    Map<String, dynamic> promptsAndResponses =
        context.read<MessagesCubit>().state;

    setState(() {
      fetchingResponse = true;
    });

    try {
      final getresponse = await http.post(
        ENV.getresponseurl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': user!['userName'],
          'prompt': _currentText,
        }),
      );

      if (getresponse.statusCode == 200) {
        final getresponsedata = jsonDecode(getresponse.body);
        responses!.add(getresponsedata['response']['text']);
        prompts!.add(_currentText.trim());
        promptsAndResponses['userPrompts'] = prompts!;
        promptsAndResponses['bodhxResponses'] = responses!;
        context.read<MessagesCubit>().updateData(promptsAndResponses);
        setState(() {
          _textController.clear();
          _currentText = '';
        });
      } else {
        CommonUtils.myDialogueBox(
            title: "Failed",
            middleText: "Couldn't get the response, please try again later", textCancel: "Ok");
      }
    } catch (e) {
      CommonUtils.myDialogueBox(title: "Error", middleText: e.toString(), textCancel: "Ok");
    }

    setState(() {
      fetchingResponse = false;
    });
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
                CommonUtils.myDialogueBox(
                  textConfirm: "Yes",
                  textCancel: "No",
                  title: "Clear conversations?",
                  middleText:
                      "Are you sure you want to clear conversations with BodhX?",
                  onconfirm:  () {
                    context.read<MessagesCubit>().clearData();
                    setState(() {});
                    Get.back();
                  },
                );
              },
              icon: Icon(Icons.delete)),
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
                      "Generating Response...",
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
                  // Mic icon button - Updated to toggle speech recognition
                  // IconButton(
                  //   icon: Icon(
                  //     _isListening ? Icons.mic : Icons.mic_none,
                  //     color: _isListening ? Color(0xff11A8AE) : Colors.white,
                  //   ),
                  //   onPressed: _toggleListening,
                  // ),

                  SizedBox(width: 10),

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
                          decoration: InputDecoration(
                            hintText: _isListening
                                ? 'Listening...'
                                : 'Type a message',
                            hintStyle: TextStyle(
                              color: _isListening
                                  ? Color(0xff11A8AE)
                                  : Colors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (text) {
                            // Use debouncer to update the current text
                            _debouncer.run(() {
                              setState(() {
                                _currentText = text;
                              });
                            });
                          },
                          onSubmitted: (text) {
                            // Handle submit when user presses enter/done
                            _sendMessage();
                          },
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
                      onPressed: _currentText.trim().isEmpty || fetchingResponse
                          ? null
                          : _sendMessage,
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
