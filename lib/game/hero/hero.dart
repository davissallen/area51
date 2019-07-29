import 'dart:ui';

import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/resizable.dart';
import 'package:flame/sprite.dart';
import 'package:area51/game/hero/config.dart';

enum HeroStatus { crashed, ducking, jumping, running, waiting, intro }

class Hero extends PositionComponent with ComposedComponent, Resizable {
  bool isIdle = true;

  HeroStatus status = HeroStatus.waiting;

  WaitingHero idleHero;
  RunningHero runningHero;
  JumpingHero jumpingHero;
  SurprisedHero surprisedHero;

  double jumpVelocity = 0.0;
  bool reachedMinHeight = false;
  int jumpCount = 0;
  bool hasPlayedIntro = false;

  Hero(Image spriteImage)
      : runningHero = RunningHero(spriteImage),
        idleHero = WaitingHero(spriteImage),
        jumpingHero = JumpingHero(spriteImage),
        surprisedHero = SurprisedHero(spriteImage),
        super();

  PositionComponent get actualHero {
    switch (status) {
      case HeroStatus.waiting:
        return idleHero;
      case HeroStatus.jumping:
        return jumpingHero;

      case HeroStatus.crashed:
        return surprisedHero;
      case HeroStatus.intro:
      case HeroStatus.running:
      default:
        return runningHero;
    }
  }

  void startJump(double speed) {
    if (status == HeroStatus.jumping || status == HeroStatus.ducking) return;

    status = HeroStatus.jumping;
    this.jumpVelocity = HeroConfig.initialJumpVelocity - (speed / 10);
    this.reachedMinHeight = false;
  }

  @override
  void render(Canvas canvas) {
    this.actualHero.render(canvas);
  }

  void reset() {
    y = groundYPos;
    jumpVelocity = 0.0;
    jumpCount = 0;
    status = HeroStatus.running;
  }

  void update(double t) {
    if (status == HeroStatus.jumping) {
      y += (jumpVelocity);
      this.jumpVelocity += HeroConfig.gravity;
      if (this.y > this.groundYPos) {
        this.reset();
        this.jumpCount++;
      }
    } else {
      y = this.groundYPos;
    }

    // intro related
    if (jumpCount == 1 && !playingIntro && !hasPlayedIntro) {
      status = HeroStatus.intro;
    }
    if (playingIntro && x < HeroConfig.startXPos) {
      x += ((HeroConfig.startXPos / HeroConfig.introDuration) * t * 5000);
    }

    updateCoordinates(t);
  }

  void updateCoordinates(double t) {
    this.actualHero.x = x;
    this.actualHero.y = y;
    this.actualHero.update(t);
  }

  double get groundYPos {
    if (size == null) return 0.0;
    return (size.height / 2) - HeroConfig.height / 2;
  }

  bool get playingIntro => status == HeroStatus.intro;

  bool get ducking => status == HeroStatus.ducking;
}

class RunningHero extends AnimationComponent {
  RunningHero(Image spriteImage)
      : super(
            88.0,
            90.0,
            Animation.spriteList([
              Sprite.fromImage(
                spriteImage,
                width: HeroConfig.width,
                height: HeroConfig.height,
                y: 4.0,
                x: 1514.0,
              ),
              Sprite.fromImage(
                spriteImage,
                width: HeroConfig.width,
                height: HeroConfig.height,
                y: 4.0,
                x: 1602.0,
              ),
            ], stepTime: 0.2, loop: true));
}

class WaitingHero extends SpriteComponent {
  WaitingHero(Image spriteImage)
      : super.fromSprite(
            HeroConfig.width,
            HeroConfig.height,
            Sprite.fromImage(spriteImage,
                width: HeroConfig.width,
                height: HeroConfig.height,
                x: 76.0,
                y: 6.0));
}

class JumpingHero extends SpriteComponent {
  JumpingHero(Image spriteImage)
      : super.fromSprite(
            HeroConfig.width,
            HeroConfig.height,
            Sprite.fromImage(spriteImage,
                width: HeroConfig.width,
                height: HeroConfig.height,
                x: 1339.0,
                y: 6.0));
}

class SurprisedHero extends SpriteComponent {
  SurprisedHero(Image spriteImage)
      : super.fromSprite(
            HeroConfig.width,
            HeroConfig.height,
            Sprite.fromImage(spriteImage,
                width: HeroConfig.width,
                height: HeroConfig.height,
                x: 1782.0,
                y: 6.0));
}
