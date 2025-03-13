import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as flutter_bloc;
import 'package:doubtx/Bloc/data_bloc.dart';
import 'package:doubtx/Pages/Authentication/login.dart';
import 'package:doubtx/Pages/Userpages/homepage.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> user = context.watch<DataCubit>().state;

    return user.containsKey('name') ? UserHomePage() : LoginPage();
  }
}