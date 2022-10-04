//BIG FILLED BUTTON
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';
import 'const.dart';

class FilledButton extends StatefulWidget {
  final bool loading;
  final VoidCallback onPressed;
  final String textName;
  final Color textColor;
  final Color buttonColor;

  const FilledButton(
      {Key? key,
      required this.textName,
      required this.onPressed,
      required this.textColor,
      this.loading = false,
      required this.buttonColor})
      : super(key: key);

  @override
  State<FilledButton> createState() => _FilledButtonState();
}

class _FilledButtonState extends State<FilledButton>
    with TickerProviderStateMixin {
  late final AnimationController animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..repeat();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.buttonColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: () {
        HapticFeedback.heavyImpact();
        widget.onPressed();
      },
      child: Container(
        alignment: Alignment.center,
        height: 62,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: widget.loading
            ? SpinKitCircle(
                color: ColorData.white,
                size: height(context) * .034,
                // controller: animationController,
              )
            : Text(
                widget.textName,
                style: GoogleFonts.nunito(
                  color: widget.textColor,
                  fontSize: height(context) * .024,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}
