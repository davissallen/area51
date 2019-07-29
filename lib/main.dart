import 'dart:ui' as ui;

import 'package:flame/flame.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:area51/game/game.dart';

void main() async {
  Flame.audio.disableLog();
  List<ui.Image> image = await Flame.images.loadAll(['sprite.png']);
  Area51Game area51Game = Area51Game(spriteImage: image[0]);
  runApp(MaterialApp(
    title: 'Area 51 Game',
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: GameWrapper(area51Game),
    ),
  ));

  Flame.util.addGestureRecognizer(new TapGestureRecognizer()
    ..onTapDown = (TapDownDetails evt) => area51Game.onTap());

  SystemChrome.setEnabledSystemUIOverlays([]);
}

class GameWrapper extends StatelessWidget {
  final Area51Game area51Game;
  GameWrapper(this.area51Game);

  @override
  Widget build(BuildContext context) {
    return area51Game.widget;
  }
}
