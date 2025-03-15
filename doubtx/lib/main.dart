import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as flutter_bloc;
import 'package:doubtx/Bloc/data_bloc.dart';
import 'package:doubtx/Pages/wrapper.dart';
import 'package:doubtx/Pages/Authentication/login.dart';
import 'package:doubtx/Pages/Authentication/Signup/signup.dart';
import 'package:doubtx/Pages/Authentication/onboarding.dart';

import 'package:doubtx/Pages/Userpages/homepage.dart';
import 'package:doubtx/splash.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    flutter_bloc.MultiBlocProvider(
      providers: [
        flutter_bloc.BlocProvider(create: (_) => DataCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FitLer',
      theme: ThemeData.light(),
      home: const SplashScreen(), // Set splash screen as initial route
      debugShowCheckedModeBanner: false,
      getPages: [
        
        GetPage(name: '/splashscreen', page: () => const SplashScreen(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300)),
        GetPage(name: '/wrapper', page: () => const Wrapper(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300)),

        GetPage(name: '/onboarding', page: () => const OnboardingScreen(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300)),
        GetPage(name: '/loginpage', page: () => const LoginPage(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300)),
        GetPage(name: '/signuppage', page: () => const SignUpPage(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300)),

        GetPage(name: '/homepage', page: () => const UserHomePage(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300)),
      ],
    );
  }
}