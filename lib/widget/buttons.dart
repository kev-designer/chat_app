import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';
import 'const.dart';

//BIG FILLED BUTTON
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

//SMALL FILLED BUTTON
class SmallColouredButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String textName;
  final Color textColor;
  final Color buttonColor;
  final Color borderColor;

  const SmallColouredButton(
      {Key? key,
      required this.textName,
      required this.onPressed,
      required this.textColor,
      required this.borderColor,
      required this.buttonColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 10,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: buttonColor.withOpacity(.04),
          border: Border.all(color: borderColor),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Text(
          textName,
          style: GoogleFonts.nunito(
            color: textColor,
            fontSize: height(context) * .02,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
