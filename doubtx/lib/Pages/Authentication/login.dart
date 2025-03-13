import 'package:flutter/material.dart';
import 'package:doubtx/Utils/auth_utils.dart';
import 'package:get/get.dart';

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

  final TextEditingController _emailController = TextEditingController();
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
              Text(
                'Login',
                style: AuthTextStyles.getTitleStyle(screenWidth),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: AuthCommon.largeSpacing),

              // Email Field
              AuthWidgets.buildTextField(
                controller: _emailController,
                hintText: 'Enter your email',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
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
                    emailError =
                        AuthValidation.validateEmail(_emailController.text);
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

                  setState(() {
                    isLoggingIn = false;
                  });
                },
              ),

              SizedBox(height: AuthCommon.standardSpacing),

              // Sign up link
              AuthWidgets.buildLinkRow(
                text: "Don't have an account?",
                linkText: "Create one",
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
