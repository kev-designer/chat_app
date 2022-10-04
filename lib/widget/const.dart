import 'package:flutter/material.dart';

Size displaySize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double height(BuildContext context) {
  return displaySize(context).height;
}

double width(BuildContext context) {
  return displaySize(context).width;
}
