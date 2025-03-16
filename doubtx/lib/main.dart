import 'package:doubtx/Bloc/messages_bloc.dart';
import 'package:doubtx/Pages/Userpages/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as flutter_bloc;
import 'package:doubtx/Bloc/user_data_bloc.dart';
import 'package:doubtx/Pages/wrapper.dart';
import 'package:doubtx/Pages/Authentication/login.dart';
import 'package:doubtx/Pages/Authentication/Signup/signup.dart';
import 'package:doubtx/Pages/Authentication/onboarding.dart';
import 'package:doubtx/Pages/Userpages/weakpointidentifier.dart';
import 'package:doubtx/Pages/Userpages/homepage.dart';
import 'package:doubtx/Pages/Userpages/doubtSolver.dart';
import 'package:doubtx/splash.dart';
import 'package:doubtx/Pages/Userpages/smartStudyPlanner.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    flutter_bloc.MultiBlocProvider(
      providers: [
        flutter_bloc.BlocProvider(create: (_) => DataCubit()),
        flutter_bloc.BlocProvider(create: (_) => MessagesCubit()),
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
      title: 'DOUBTX',
      theme: ThemeData.dark(),
      home: const SplashScreen(), // Set splash screen as initial route
      debugShowCheckedModeBanner: false,
      getPages: [
        
        GetPage(name: '/splashscreen', page: () => const SplashScreen(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300)),
        GetPage(name: '/wrapper', page: () => const Wrapper(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300)),

        GetPage(name: '/onboarding', page: () => const OnboardingScreen(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300)),
        GetPage(name: '/loginpage', page: () => const LoginPage(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300)),
        GetPage(name: '/signuppage', page: () => const SignUpPage(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300)),

        GetPage(name: '/homepage', page: () => const UserHomePage(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300)),
        GetPage(name: '/profilepage', page: () => const ProfilePage(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300)),
        GetPage(name: '/doubtSolver', page: () => const DoubtSolverPage(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300)),
        GetPage(name: '/weakPointIdentifier', page: () => const WeakPointIdentifierPage(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300)),
        GetPage(name: '/smartstudyplanner', page: () => const SmartStudyPlannerPage(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300)),
      ],
    );
  }
}