import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flutter/material.dart';

class FluttersObstacle extends SpriteComponent {
  /// opacity of the hitbox
  double opacity = 1;
  /// flag to show the hitbox of the branch
  bool hit = false;

  void render(Canvas c) {
    if (opacity < 1 || hit) {
      // render hitbox
      sprite.renderRect(
          c,
          Rect.fromLTWH(x, y, width, height),
          overridePaint: Paint()..color = hit ? Colors.white.withOpacity(1.0) : Colors.white.withOpacity(opacity)
      );
    } else {
      super.render(c);
    }
  }
}