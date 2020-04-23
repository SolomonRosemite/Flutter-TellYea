import 'package:TellYea/backend/Backend.dart';
import 'package:flutter/material.dart';

//TODO: Add one main Font
///colors
class ColorSchemes {
  static const Color primaryColor = Color(0xFF3F47F4);
  static const Color red = Colors.red;

  static Color colorSchemesToColor(String color) {
    switch (color) {
      case "primaryColor":
        return ColorSchemes.primaryColor;
      case "red":
        return ColorSchemes.red;
    }
    Backend.save('Reports', {
      'context': 'ColorScheme was: $color and is not valid Class: ColorSchemes'
    });
    return ColorSchemes.primaryColor;
  }
}
