import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/resizable.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/sprite.dart';
import 'package:area51/game/game_over/config.dart';

class GameOverPanel extends PositionComponent
    with Resizable, ComposedComponent {
  bool visible = false;

  GameOverText gameOverText;
  GameOverRestart gameOverRestart;

  GameOverPanel(Image spriteImage) : super() {
    gameOverText = GameOverText(spriteImage);
    gameOverRestart = GameOverRestart(spriteImage);

    components..add(gameOverText)..add(gameOverRestart);
  }

  @override
  void render(Canvas canvas) {
    if (visible) {
      super.render(canvas);
    }
  }
}

class GameOverText extends SpriteComponent with Resizable {
  GameOverText(Image spriteImage)
      : super.fromSprite(
            GameOverConfig.textWidth,
            GameOverConfig.textHeight,
            Sprite.fromImage(
              spriteImage,
              x: 955.0,
              y: 26.0,
              width: GameOverConfig.textWidth,
              height: GameOverConfig.textHeight,
            ));

  @override
  resize(Size size) {
    if (width > size.width * 0.8) {
      width = size.width * 0.8;
    }
    y = size.height * .25;
    x = (size.width / 2) - width / 2;
  }
}

class GameOverRestart extends SpriteComponent with Resizable {
  GameOverRestart(Image spriteImage)
      : super.fromSprite(
            GameOverConfig.restartWidth,
            GameOverConfig.restartHeight,
            Sprite.fromImage(
              spriteImage,
              x: 2.0,
              y: 2.0,
              width: GameOverConfig.restartWidth,
              height: GameOverConfig.restartHeight,
            ));

  @override
  resize(Size size) {
    y = size.height * .75;
    x = (size.width / 2) - GameOverConfig.restartWidth / 2;
  }
}
