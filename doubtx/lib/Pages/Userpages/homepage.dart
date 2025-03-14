import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as flutter_bloc;
import 'package:doubtx/Bloc/data_bloc.dart';
import 'package:get/get.dart';
import 'package:doubtx/Utils/user_utils.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> user = context.watch<DataCubit>().state;

    return Scaffold(backgroundColor: CommonUserUtils.bgColor,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(user['Name']),
          Text(user['Email']),
          Text(user['Age'].toString()),
          ElevatedButton(onPressed: (){
            context.read<DataCubit>().signOut();
            Get.offAllNamed('/wrapper');
          }, child: Text("Log out")),
        ],
      ),
    ));
  }
}