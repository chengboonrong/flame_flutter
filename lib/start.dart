import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flame_flutter/view.dart';
import 'game.dart';

class StartButton {
  final MyGame game;
  Rect rect;
  Sprite sprite;

  StartButton(this.game) {
    rect = this.game.activeView == View.home
        ? Rect.fromLTWH(
            game.tileSize * 1.5,
            (game.screenSize.height / 2),
            game.tileSize * 6,
            game.tileSize * 3,
          )
        : Rect.fromLTWH(
            game.tileSize * 1.5,
            (game.screenSize.height * .75) - (game.tileSize * 1.5),
            game.tileSize * 6,
            game.tileSize * 3,
          );
    sprite = Sprite('ui/start-button.png');
  }

  void render(Canvas c) {
    sprite.renderRect(c, rect);
  }

  void update(double t) {}

  void onTapDown() {
    game.activeView = View.playing;
    game.spawner.start();
  }
}
