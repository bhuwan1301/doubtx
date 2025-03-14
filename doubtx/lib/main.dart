import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as flutter_bloc;
import 'package:doubtx/Bloc/data_bloc.dart';
import 'package:doubtx/Pages/wrapper.dart';
import 'package:doubtx/Pages/Authentication/login.dart';
import 'package:doubtx/Pages/Authentication/Signup/signup.dart';

import 'package:doubtx/Pages/Userpages/homepage.dart';
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
      home: const Wrapper(), // Set splash screen as initial route
      debugShowCheckedModeBanner: false,
      getPages: [
        // main page
        GetPage(name: '/wrapper', page: () => const Wrapper()),

        GetPage(name: '/loginpage', page: () => const LoginPage()),
        GetPage(name: '/signuppage', page: () => const SignUpPage()),

        GetPage(name: '/homepage', page: () => const UserHomePage()),
      ],
    );
  }
}