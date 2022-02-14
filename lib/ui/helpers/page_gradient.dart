import 'package:flutter/material.dart';

pageGradient(Color color1, Color color2) => BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color1, color2],
      ),
    );
