import 'package:TellYea/backend/Backend.dart';
import 'package:TellYea/model/YeetModel.dart';
import 'package:flutter/material.dart';

//TODO: Add one main Font

class ColorSchemes {
  static const Color primaryColor = Color(0xFF3F47F4);
  static const Color red = Colors.red;

  static Color getColorSchemeFromUser(YeetModel yeetModel) {
    for (var user in Backend.tellYeaUsers) {
      if (user['ownerId'] == yeetModel.ownerId) {
        // print(user['colorScheme']);
        switch (user['colorScheme']) {
          case "primaryColor":
            return ColorSchemes.primaryColor;

          case "red":
            return ColorSchemes.red;

          default:
            Backend.save('Reports', {
              'context': 'ColorScheme was: ${user['colorScheme']} and is not valid. Class: ColorSchemes'
            });
            return ColorSchemes.primaryColor;
        }
      }
    }

    Backend.save('Reports', {
      'context': 'ColorScheme not valid. Class: ColorSchemes'
    });
    return ColorSchemes.primaryColor;
  }

  static Color colorSchemesToColor(String color) {
    switch (color) {
      case "primaryColor":
        return ColorSchemes.primaryColor;
      case "red":
        return ColorSchemes.red;
    }
    Backend.save('Reports', {
      'context': 'ColorScheme was: $color and is not valid. Class: ColorSchemes'
    });
    return ColorSchemes.primaryColor;
  }
}
