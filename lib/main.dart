import 'package:chat_app/view/sign_in.dart';
import 'package:chat_app/widget/colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat App',
      theme: ThemeData(
        scaffoldBackgroundColor: ColorData.white,
        primarySwatch: Colors.blue,
      ),
      home: const SignIn(),
    );
  }
}
