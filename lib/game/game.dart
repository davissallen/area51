import 'dart:ui';

import 'package:flame/game.dart';
import 'package:area51/game/Horizon/horizon.dart';
import 'package:area51/game/collision/collision_utils.dart';
import 'package:area51/game/game_config.dart';
import 'package:area51/game/game_over/game_over.dart';
import 'package:area51/game/score/score.dart';
import 'package:area51/game/hero/config.dart';
import 'package:area51/game/hero/hero.dart';

enum Area51GameStatus { playing, waiting, gameOver }

class Area51Game extends BaseGame {
  Hero hero;
  Horizon horizon;
  ScorePanel scorePanel;
  GameOverPanel gameOverPanel;
  Area51GameStatus status = Area51GameStatus.waiting;

  double currentSpeed = GameConfig.speed;
  double timePlaying = 0.0;

  Area51Game({Image spriteImage}) {
    hero = new Hero(spriteImage);
    horizon = new Horizon(spriteImage);
    scorePanel = new ScorePanel(spriteImage);
    gameOverPanel = new GameOverPanel(spriteImage);

    this..add(horizon)..add(hero)..add(scorePanel)..add(gameOverPanel);
  }

  void onTap() {
    if (gameOver) {
      restart();
      return;
    }
    hero.startJump(this.currentSpeed);
  }

  @override
  void update(double t) {
    hero.update(t);
    horizon.updateWithSpeed(0.0, this.currentSpeed);

    if (gameOver) return;

    if (hero.playingIntro && hero.x >= HeroConfig.startXPos) {
      startGame();
    } else if (hero.playingIntro) {
      horizon.updateWithSpeed(0.0, this.currentSpeed);
    }

    if (this.playing) {
      timePlaying += t;
      horizon.updateWithSpeed(t, this.currentSpeed);

      var obstacles = horizon.horizonLine.obstacleManager.components;
      bool collision =
          obstacles.length > 0 && checkForCollision(obstacles.first, hero);
      if (!collision) {
        if (this.currentSpeed < GameConfig.maxSpeed) {
          this.currentSpeed += GameConfig.acceleration;
        }
      } else {
        doGameOver();
      }
    }
  }

  void startGame() {
    hero.status = HeroStatus.running;
    status = Area51GameStatus.playing;
    hero.hasPlayedIntro = true;
  }

  bool get playing => status == Area51GameStatus.playing;
  bool get gameOver => status == Area51GameStatus.gameOver;

  void doGameOver() {
    this.gameOverPanel.visible = true;
    stop();
    hero.status = HeroStatus.crashed;
  }

  void stop() {
    this.status = Area51GameStatus.gameOver;
  }

  void restart() {
    status = Area51GameStatus.playing;
    hero.reset();
    horizon.reset();
    currentSpeed = GameConfig.speed;
    gameOverPanel.visible = false;
    timePlaying = 0.0;
  }
}
