import 'package:doubtx/Bloc/data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:doubtx/Utils/auth_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:doubtx/env.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isProcessing = false;

  // Form field controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Error states
  String? firstNameError;
  String? lastNameError;
  String? usernameError;
  String? phoneError;
  String? emailError;
  String? dobError;
  String? genderError;
  String? passwordError;
  String? confirmPasswordError;

  // Dropdown values
  String _selectedCountryCode = '+91';
  String _selectedGender = 'Male';

  // List of country codes
  final List<String> _countryCodes = [
    '+1', // USA, Canada
    '+44', // UK
    '+91', // India
    '+61', // Australia
    '+86', // China
    '+81', // Japan
    '+49', // Germany
    '+33', // France
    '+39', // Italy
    '+7', // Russia
    '+55', // Brazil
    '+34', // Spain
    '+27', // South Africa
    '+82', // South Korea
    '+31', // Netherlands
    '+47', // Norway
    '+46', // Sweden
    '+41', // Switzerland
    '+32', // Belgium
    '+92', // Pakistan
    '+966', // Saudi Arabia
    '+971', // UAE
    '+20', // Egypt
    '+52', // Mexico
  ];

  final List<String> _genders = ['Male', 'Female', 'Trans'];

  @override
  void initState() {
    super.initState();
  }

  // Show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now()
          .subtract(const Duration(days: 365 * 18)), // Default to 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
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
              SizedBox(height: AuthCommon.largeSpacing),
              // App Title
              Image.asset(
                'assets/logo/logo.png',
                height: screenWidth * (100 / 375),
              ),
              SizedBox(height: 30),
              Text(
                'Create Account',
                style: AuthTextStyles.getTitleStyle(screenWidth),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: AuthCommon.largeSpacing),

              // First Name Field
              AuthWidgets.buildTextField(
                controller: _firstNameController,
                hintText: 'First Name',
                prefixIcon: Icons.person,
                keyboardType: TextInputType.name,
              ),
              AuthWidgets.buildErrorText(firstNameError, screenWidth),
              SizedBox(height: AuthCommon.standardSpacing),

              // Last Name Field
              AuthWidgets.buildTextField(
                controller: _lastNameController,
                hintText: 'Last Name',
                prefixIcon: Icons.person_outline,
                keyboardType: TextInputType.name,
              ),
              AuthWidgets.buildErrorText(lastNameError, screenWidth),
              SizedBox(height: AuthCommon.standardSpacing),

              // Username Field
              AuthWidgets.buildTextField(
                controller: _usernameController,
                hintText: 'Username',
                prefixIcon: Icons.alternate_email,
                keyboardType: TextInputType.name,
              ),
              AuthWidgets.buildErrorText(usernameError, screenWidth),
              SizedBox(height: AuthCommon.standardSpacing),

              // Contact Field (Country Code + Phone)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Country Code Dropdown
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AuthCommon.defaultBorderRadius,
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCountryCode,
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 16,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * (16 / 375)),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedCountryCode = value!;
                          });
                        },
                        items: _countryCodes
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Phone Number Field
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
              AuthWidgets.buildErrorText(phoneError, screenWidth),
              SizedBox(height: AuthCommon.standardSpacing),

              // Email Field
              AuthWidgets.buildTextField(
                controller: _emailController,
                hintText: 'Email Address',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              AuthWidgets.buildErrorText(emailError, screenWidth),
              SizedBox(height: AuthCommon.standardSpacing),

              // Date of Birth Field
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: _dobController,
                    decoration: InputDecoration(
                      hintText: 'Date of Birth',
                      prefixIcon: const Icon(Icons.calendar_today),
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
              ),
              AuthWidgets.buildErrorText(dobError, screenWidth),
              SizedBox(height: AuthCommon.standardSpacing),

              // Gender Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AuthCommon.defaultBorderRadius,
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedGender,
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 16,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * (16 / 375)),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                    items:
                        _genders.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            Icon(
                              value == 'Male'
                                  ? Icons.male
                                  : value == 'Female'
                                      ? Icons.female
                                      : Icons.transgender,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(value),
                          ],
                        ),
                      );
                    }).toList(),
                    hint: const Text('Select Gender'),
                  ),
                ),
              ),
              AuthWidgets.buildErrorText(genderError, screenWidth),
              SizedBox(height: AuthCommon.standardSpacing),

              // Password Field
              AuthWidgets.buildTextField(
                controller: _passwordController,
                hintText: 'Password',
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
                hintText: 'Confirm Password',
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
                      // Validate all fields
                      firstNameError = AuthValidation.validateRequiredField(
                          _firstNameController.text, "first name");
                      lastNameError = AuthValidation.validateRequiredField(
                          _lastNameController.text, "last name");
                      usernameError = AuthValidation.validateRequiredField(
                          _usernameController.text, "username");
                      phoneError = AuthValidation.validateRequiredField(
                          _phoneController.text, "phone number");
                      emailError =
                          AuthValidation.validateEmail(_emailController.text);
                      dobError = AuthValidation.validateRequiredField(
                          _dobController.text, "date of birth");
                      passwordError = AuthValidation.validatePassword(
                          _passwordController.text);
                      confirmPasswordError =
                          AuthValidation.validatePasswordMatch(
                              _passwordController.text,
                              _confirmPasswordController.text);
                    });

                    hasError = firstNameError != null ||
                        lastNameError != null ||
                        usernameError != null ||
                        phoneError != null ||
                        emailError != null ||
                        dobError != null ||
                        passwordError != null ||
                        confirmPasswordError != null;

                    if (hasError) {
                      setState(() {
                        isProcessing = false;
                      });
                      return;
                    }
                    // Implement signup logic or navigation to OTP page here

                    String apiUrl = "${ENV.baseURL}/register";

                    Map<String, dynamic> userbody = {
                      'details': {
                        'userName': _usernameController.text.trim(),
                        'firstName': _firstNameController.text.trim(),
                        'lastName': _lastNameController.text.trim(),
                        'countryCode': _selectedCountryCode.trim(),
                        'contactNumber': _phoneController.text.trim(),
                        'mailAddr': _emailController.text.trim(),
                        'dateOfBirth': _dobController.text.trim(),
                        'gender': _selectedGender.trim(),
                        'profilePicture': "",
                        'preferredLanguage': "English",
                        'password': _passwordController.text.trim(),
                        'email': true,
                        'sms': false,
                        'bio':
                            "${_firstNameController.text.trim()} is studying",
                      }
                    };

                    try {
                      // Send the POST request
                      final signupresponse = await http.post(
                        Uri.parse(apiUrl),
                        headers: {
                          'Content-Type': 'application/json',
                        },
                        body: jsonEncode(userbody),
                      );

                      // Check if registration was successful
                      if (signupresponse.statusCode == 201) {
                        final Map<String, dynamic> signupresponseData =
                            jsonDecode(signupresponse.body);
                        final Map<String, dynamic> userDataMap =
                            signupresponseData['user'];
                        if (userDataMap.containsKey('passwordHash')) {
                          userDataMap.remove('passwordHash');
                        }
                        context.read<DataCubit>().updateData(userDataMap);
                        Get.snackbar("Account Created",
                            "Your account has been created succesfully.");

                        Get.offAllNamed('/homepage');
                      } else {
                        Get.snackbar("Failed", "Failed to create account.");
                      }
                    } catch (e) {
                      Get.snackbar("Error", e.toString());
                    }
                    setState(() {
                      isProcessing = false;
                    });
                  }),

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
