import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';
import 'const.dart';

//SEARCH BAR
class SearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final GestureDetector suffixIcon;

  const SearchBar({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: TextFormField(
        controller: controller,
        cursorColor: ColorData.primary,
        cursorHeight: height(context) * .021,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          counterText: '',
          border: const OutlineInputBorder(),
          suffixIcon: GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: suffixIcon,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: ColorData.primary, width: 1.8),
          ),
          hintText: hintText,
          labelStyle: GoogleFonts.nunito(
            color: ColorData.black,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          hintStyle: GoogleFonts.nunito(
            color: ColorData.black,
            fontSize: 16,
          ),
        ),
        style: GoogleFonts.nunito(
          color: ColorData.black,
          fontSize: 16,
        ),
      ),
    );
  }
}
