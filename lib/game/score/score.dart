import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/resizable.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/sprite.dart';
import 'package:area51/game/score/config.dart';

class ScorePanel extends PositionComponent with Resizable, ComposedComponent {
  ScoreLabel scoreLabel;
  ScoreText scoreText;

  ScorePanel(Image spriteImage) : super() {
    scoreLabel = ScoreLabel(spriteImage);
    scoreText = ScoreText(spriteImage);
    components..add(scoreLabel)..add(scoreText);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}

class ScoreLabel extends SpriteComponent with Resizable {
  ScoreLabel(Image spriteImage)
      : super.fromSprite(
            ScoreConfig.labelWidth,
            ScoreConfig.labelHeight,
            Sprite.fromImage(
              spriteImage,
              x: 0.0,
              y: 143.0,
              width: ScoreConfig.labelWidth,
              height: ScoreConfig.labelHeight,
            ));

  @override
  resize(Size size) {
    y = 20.0;
    x = 10.0;
  }
}

class ScoreText extends SpriteComponent with Resizable {
  ScoreText(Image spriteImage)
      : super.fromSprite(
            18.0,
            21.0,
            Sprite.fromImage(
              spriteImage,
              x: 954.0,
              y: 2.0,
              width: 18.0,
              height: 21.0,
            ));

  @override
  resize(Size size) {
    y = 20.0;
    x = 10.0;
  }
}
