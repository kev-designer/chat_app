import 'package:chat_app/view/sign_in.dart';
import 'package:chat_app/widget/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Chat App',
      theme: ThemeData(
        scaffoldBackgroundColor: ColorData.white,
        primarySwatch: Colors.blue,
      ),
      home: const SignIn(),
    );
  }
}
