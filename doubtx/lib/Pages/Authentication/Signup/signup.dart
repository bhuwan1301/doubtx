import 'package:flutter/material.dart';
import 'package:doubtx/Utils/auth_utils.dart';
import 'package:get/get.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isProcessing = false;

  String? nameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
              // App Title
              Text(
                'Create Account',
                style: AuthTextStyles.getTitleStyle(screenWidth),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: AuthCommon.largeSpacing),

              // Name Field
              AuthWidgets.buildTextField(
                controller: _nameController,
                hintText: 'Enter your name',
                prefixIcon: Icons.person,
                keyboardType: TextInputType.name,
              ),

              AuthWidgets.buildErrorText(nameError, screenWidth),

              SizedBox(height: AuthCommon.standardSpacing),

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

              // Confirm Password Field
              AuthWidgets.buildTextField(
                controller: _confirmPasswordController,
                hintText: 'Confirm your password',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                hideText: hideConfirmPassword,
                onToggleVisibility: () {
                  setState(() {
                    hideConfirmPassword = !hideConfirmPassword;
                  });
                },
              ),

              AuthWidgets.buildErrorText(confirmPasswordError, screenWidth),

              SizedBox(height: AuthCommon.standardSpacing),

              // Next Button
              AuthWidgets.buildActionButton(
                text: 'Next',
                isLoading: isProcessing,
                screenWidth: screenWidth,
                onPressed: () async {
                  setState(() {
                    isProcessing = true;
                  });
                  await Future.delayed(AuthCommon.loadingDelay);

                  bool hasError = false;

                  setState(() {
                    nameError = AuthValidation.validateRequiredField(
                        _nameController.text, "name");
                    emailError =
                        AuthValidation.validateEmail(_emailController.text);
                    passwordError = AuthValidation.validatePassword(
                        _passwordController.text);
                    confirmPasswordError = AuthValidation.validatePasswordMatch(
                        _passwordController.text,
                        _confirmPasswordController.text);
                  });

                  hasError = nameError != null ||
                      emailError != null ||
                      passwordError != null ||
                      confirmPasswordError != null;

                  if (hasError) {
                    setState(() {
                      isProcessing = false;
                    });
                    return;
                  }

                  // Implement signup logic or navigation to OTP page here

                  setState(() {
                    isProcessing = false;
                  });
                },
              ),

              SizedBox(height: AuthCommon.standardSpacing),

              // Login link
              AuthWidgets.buildLinkRow(
                text: "Already have an account?",
                linkText: "Login",
                screenWidth: screenWidth,
                onPressed: () {
                  Get.offAllNamed('/loginpage');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
