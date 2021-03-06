import 'dart:ui';

import 'package:flame/sprite.dart';
import 'fly.dart';
import 'game.dart';

class DroolerFly extends Fly {
  DroolerFly(MyGame game, double x, double y) : super(game) {
    flyRect = Rect.fromLTWH(x, y, game.tileSize, game.tileSize);
    flyingSprite = List();
    flyingSprite.add(Sprite('flies/drooler-fly-1.png'));
    flyingSprite.add(Sprite('flies/drooler-fly-2.png'));
    deadSprite = Sprite('flies/drooler-fly-dead.png');
  }
}
