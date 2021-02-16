import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flame_flutter/game.dart';

class Fly {
  final MyGame game;
  List<Sprite> flyingSprite;
  Sprite deadSprite;
  double flyingSpriteIndex = 0;
  Rect flyRect = Rect.zero;
  Paint flyPaint = Paint();
  bool isDead = false;
  bool isOffScreen = false;
  Offset hitbox;

  double get speed => game.tileSize * 3;

  Fly(this.game) {
    // flyRect = Rect.fromLTWH(x, y, game.tileSize, game.tileSize);
    // flyPaint = Paint();
    // flyPaint.color = Color(0xff6ab04c);
    setHitBox();
  }

  void setHitBox() {
    double x = game.rnd.nextDouble() *
        (game.screenSize.width - (game.tileSize * 2.025));
    double y = game.rnd.nextDouble() *
        (game.screenSize.height - (game.tileSize * 2.025));
    hitbox = Offset(x, y);
  }

  void render(Canvas c) {
    // c.drawRect(flyRect, flyPaint);
    if (isDead) {
      deadSprite.renderRect(c, flyRect.inflate(2));
    } else {
      if (flyingSpriteIndex.toInt() <= flyingSprite.length - 1)
        flyingSprite[flyingSpriteIndex.toInt()]
            .renderRect(c, flyRect.inflate(2));
    }
  }

  void update(double t) {
    if (isDead) {
      // make the fly fall
      flyRect = flyRect.translate(0, game.tileSize * 12 * t);
      if (flyRect.top > game.screenSize.height) {
        isOffScreen = true;
      }
    } else {
      // flap the wings
      flyingSpriteIndex += 30 * t;
      if (flyingSpriteIndex >= 2) {
        flyingSpriteIndex -= 2;
      }

      // move the fly
      double stepDistance = speed * t;
      Offset toTarget = hitbox - Offset(flyRect.left, flyRect.top);
      if (stepDistance < toTarget.distance) {
        Offset stepToTarget =
            Offset.fromDirection(toTarget.direction, stepDistance);
        flyRect = flyRect.shift(stepToTarget);
      } else {
        flyRect = flyRect.shift(toTarget);
        setHitBox();
      }
    }
  }

  //// My game logic
  void onTapDown() {
    if (!isDead) {
      // game.spawnFly();
      isDead = true;
      // flyPaint.color = Color(0xffff4757);
    }
  }
}
