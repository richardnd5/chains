import 'package:flutter/material.dart';

bool isInteger(String? s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

pageGradient(Color color1, Color color2) => BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color1, color2],
      ),
    );
