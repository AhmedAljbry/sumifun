
import 'package:flutter/material.dart';

defaultSmailText({
  required String txt,
  Color? color=Colors.white,
  TextAlign textalign=TextAlign.right,
  double size=14,
})=>Text(
  txt,
  style: TextStyle(
    color: color,
    fontSize: size,
    fontWeight: FontWeight.bold,
  ),
  textAlign:textalign, // النص بمحاذاة اليمين
);
defaultLargText({
  required String txt,
  Color? color=Colors.white,
  double size=42,
  TextAlign textalign=TextAlign.right
})=>Text(
  txt,
  style: TextStyle(
    color: color,
    fontSize: size,
    fontWeight: FontWeight.bold,

  ),
  textAlign: textalign,

);
defaultMadumeText({
  required String txt,
  Color? color=Colors.white,
  TextAlign textalign=TextAlign.right
})=> Text(
  txt,
  textAlign: textalign,
  style: TextStyle(
    color: color,
    fontSize: 16,
  ),
);
