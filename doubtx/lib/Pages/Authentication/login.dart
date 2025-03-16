import 'dart:convert';
import 'package:doubtx/Bloc/user_data_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:doubtx/Utils/auth_utils.dart';
import 'package:get/get.dart';
// import 'package:flutter_bloc/flutter_bloc.dart' as flutter_bloc;
// import 'package:doubtx/Bloc/data_bloc.dart';
import 'package:doubtx/env.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true;
  bool isLoggingIn = false;

  String? emailError;
  String? passwordError;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AuthCommon.bgColor,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AuthCommon.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App Logo or Title
              Image.asset(
                'assets/logo/logo.png',
                height: screenWidth * (100 / 375),
              ),
              SizedBox(height: 30),
              Text(
                'Login Your',
                style: AuthTextStyles.getTitleStyle(screenWidth),
                textAlign: TextAlign.start,
              ),
              Text(
                'Account',
                style: AuthTextStyles.getTitleStyle(screenWidth),
                textAlign: TextAlign.start,
              ),

              SizedBox(height: AuthCommon.largeSpacing),

              // Email Field
              AuthWidgets.buildTextField(
                controller: _usernameController,
                hintText: 'Enter your username',
                prefixIcon: Icons.alternate_email,
                keyboardType: TextInputType.name,
              ),

              AuthWidgets.buildErrorText(emailError, screenWidth),

              SizedBox(height: AuthCommon.standardSpacing),

              // Password Field
              AuthWidgets.buildTextField(
                controller: _passwordController,
                hintText: 'Enter your password',
                prefixIcon: Icons.lock,
                isPassword: true,
                hideText: hidePassword,
                onToggleVisibility: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
              ),

              AuthWidgets.buildErrorText(passwordError, screenWidth),

              SizedBox(height: AuthCommon.standardSpacing),

              // Login Button
              AuthWidgets.buildActionButton(
                text: 'Login',
                isLoading: isLoggingIn,
                screenWidth: screenWidth,
                onPressed: () async {
                  setState(() {
                    isLoggingIn = true;
                  });
                  await Future.delayed(AuthCommon.loadingDelay);

                  bool hasError = false;

                  setState(() {
                    emailError = AuthValidation.validateUsername(
                        _usernameController.text);
                    passwordError = AuthValidation.validatePassword(
                        _passwordController.text);
                  });

                  hasError = emailError != null || passwordError != null;

                  if (hasError) {
                    setState(() {
                      isLoggingIn = false;
                    });
                    return;
                  }

                  // Implement login logic here

                  try {
                    final loginresponse = await http.post(ENV.loginurl,
                        headers: {
                          'Content-Type': 'application/json',
                        },
                        body: jsonEncode({
                          'userName': _usernameController.text.trim(),
                          'password': _passwordController.text,
                        }));

                    switch (loginresponse.statusCode) {
                      case 200:
                        // final responseData = jsonDecode(loginresponse.body);
                        // return {
                        //   'success': true,
                        //   'message': responseData['message'],
                        //   'userID': responseData['userID'],
                        // };

                        try {
                          final fetchprofileresponse =
                              await http.post(ENV.fetchurl,
                                  headers: {
                                    'Content-Type': 'application/json',
                                  },
                                  body: jsonEncode({
                                    'username': _usernameController.text.trim(),
                                  }));

                          switch (fetchprofileresponse.statusCode) {
                            case 200:
                              final Map<String, dynamic> userData =
                                  jsonDecode(fetchprofileresponse.body);
                              context.read<DataCubit>().updateData(userData);
                              Get.offAllNamed('/homepage');

                            case 404:
                              Get.snackbar(
                                "Error",
                                "Couldn't fetch user data",
                              );

                            case 500:
                              Get.snackbar(
                                "Error",
                                jsonDecode(loginresponse.body),
                              );
                            default:
                              Get.snackbar(
                                "Error",
                                "Some error occured",
                              );
                          }
                        } catch (e) {
                          Get.snackbar(
                            "Error",
                            e.toString(),
                          );
                        }

                      case 401:
                        Get.snackbar(
                          "Failed",
                          "Invalid username or password",
                        );
                      case 403:
                        Get.snackbar(
                          "Account locked",
                          "Your account has been locked, please contact support",
                        );
                      case 404:
                        Get.snackbar(
                          "Account not found",
                          "Couldn't find an account with provided credentials",
                        );
                      case 500:
                        Get.snackbar(
                          "Error",
                          "Server error occured",
                        );
                      default:
                        Get.snackbar(
                          "Error",
                          "An error occured",
                        );
                    }
                  } catch (e) {
                    Get.snackbar(
                      "Error",
                      e.toString(),
                    );
                  }

                  setState(() {
                    isLoggingIn = false;
                  });
                },
              ),

              SizedBox(height: AuthCommon.standardSpacing),

              // Sign up link
              AuthWidgets.buildLinkRow(
                text: "Don't have an account?",
                linkText: "Sign Up",
                screenWidth: screenWidth,
                onPressed: () {
                  Get.offAllNamed('/signuppage');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
