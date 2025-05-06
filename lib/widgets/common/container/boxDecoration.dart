import 'package:flutter/material.dart';

class CustomDecorations {
  BoxDecoration baseDecoration(Color boxShadowColor, double boxShadowblurRadius,
      double boxShadowspreadRadius, Color color, double borderRadius) {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: boxShadowColor,
          blurRadius:
              boxShadowblurRadius, // has the effect of softening the shadow
          spreadRadius:
              boxShadowspreadRadius, // has the effect of extending the shadow
        ),
      ],
      color: color,
      borderRadius: BorderRadius.circular(
        borderRadius,
      ),
    );
  }
}
