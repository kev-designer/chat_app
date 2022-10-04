import 'package:chat_app/services.dart/auth.dart';
import 'package:chat_app/widget/appbar.dart';
import 'package:chat_app/widget/buttons.dart';
import 'package:chat_app/widget/colors.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildMainAppBar(context, "Flutter Chat App"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FilledButton(
                textName: "Sign In with Google",
                onPressed: () {
                  AuthMethods().signInWithGoogle(context);
                },
                textColor: ColorData.white,
                buttonColor: ColorData.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
