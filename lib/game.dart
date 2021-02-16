import 'dart:math';
import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_flutter/bg.dart';
import 'package:flame_flutter/credit.dart';
import 'package:flame_flutter/fly.dart';
import 'package:flame_flutter/home-view.dart';
import 'package:flame_flutter/spawner.dart';
import 'package:flame_flutter/start.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'agile-fly.dart';
import 'credits-view.dart';
import 'help-view.dart';
import 'help.dart';
import 'house-fly.dart';
import 'hungry-fly.dart';
import 'lost-view.dart';
import 'macho-fly.dart';
import 'drooler-fly.dart';
import 'view.dart';

class MyGame extends Game {
  Size screenSize;
  double tileSize;
  Background background;
  List<Fly> flies;
  Random rnd;

  // Splash screens
  View activeView = View.home;
  HomeView homeView;
  StartButton startButton;

  HelpButton helpButton;
  CreditsButton creditsButton;
  HelpView helpView;
  CreditsView creditsView;

  LostView lostView;

  FlySpawner spawner;

  MyGame() {
    initialize();
  }

  //// My game logic

  void initialize() async {
    flies = List<Fly>();
    rnd = Random();
    resize(await Flame.util.initialDimensions());

    background = Background(this);
    homeView = HomeView(this);
    startButton = StartButton(this);

    helpButton = HelpButton(this);
    creditsButton = CreditsButton(this);
    helpView = HelpView(this);
    creditsView = CreditsView(this);

    lostView = LostView(this);

    spawner = FlySpawner(this);
    // spawnFly();
  }

  void spawnFly() {
    double x = rnd.nextDouble() * (screenSize.width - tileSize);
    double y = rnd.nextDouble() * (screenSize.height - tileSize);
    // flies.add(HouseFly(this, x, y));

    switch (rnd.nextInt(5)) {
      case 0:
        flies.add(HouseFly(this, x, y));
        break;
      case 1:
        flies.add(DroolerFly(this, x, y));
        break;
      case 2:
        flies.add(AgileFly(this, x, y));
        break;
      case 3:
        flies.add(MachoFly(this, x, y));
        break;
      case 4:
        flies.add(HungryFly(this, x, y));
        break;
    }
  }

  void onTapDown(TapDownDetails d) {
    bool isHandled = false;

    // start button
    if (!isHandled && startButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        startButton.onTapDown();
        isHandled = true;
      }
    }

    // help button
    if (!isHandled && helpButton.rect.contains(d.globalPosition)) {
      flies.clear();
      if (activeView == View.home || activeView == View.lost) {
        helpButton.onTapDown();
        isHandled = true;
      }
    }

    // credits button
    if (!isHandled && creditsButton.rect.contains(d.globalPosition)) {
      flies.clear();
      if (activeView == View.home || activeView == View.lost) {
        creditsButton.onTapDown();
        isHandled = true;
      }
    }

    // tap to back home from Help view or Credits view
    if (!isHandled) {
      if (activeView == View.help || activeView == View.credits) {
        activeView = View.home;
        isHandled = true;
      }
    }

    // files
    if (!isHandled) {
      bool didHitFly = false;
      flies.forEach((Fly fly) {
        if (fly.flyRect.contains(d.globalPosition)) {
          fly.onTapDown();
          isHandled = true;
          didHitFly = true;
        }
      });
      if (activeView == View.playing && !didHitFly) {
        activeView = View.lost;
        startButton = StartButton(this);
      }
    }
  }

  //// Default Game logic

  void render(Canvas canvas) {
    // Rect bgRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    // Paint bgPaint = Paint();
    // bgPaint.color = Color(0xff576574);
    // canvas.drawRect(bgRect, bgPaint);

    background.render(canvas);

    switch (activeView) {
      case View.home:
        homeView.render(canvas);
        startButton.render(canvas);
        helpButton.render(canvas);
        creditsButton.render(canvas);
        break;
      case View.help:
        helpView.render(canvas);
        break;
      case View.credits:
        creditsView.render(canvas);
        break;
      case View.playing:
        break;
      case View.lost:
        lostView.render(canvas);
        startButton.render(canvas);
        helpButton.render(canvas);
        creditsButton.render(canvas);
        break;
    }

    // if (activeView == View.home) {
    //   homeView.render(canvas);
    // }

    // if (activeView == View.home || activeView == View.lost) {
    // startButton.render(canvas);
    // helpButton.render(canvas);
    // creditsButton.render(canvas);
    // }

    // if (activeView == View.help) helpView.render(canvas);
    // if (activeView == View.credits) creditsView.render(canvas);

    // if (activeView == View.lost) lostView.render(canvas);

    flies.forEach((Fly fly) => fly.render(canvas));
  }

  void update(double t) {
    spawner.update(t);
    flies.forEach((Fly fly) => fly.update(t));
    flies.removeWhere((Fly fly) => fly.isOffScreen);
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
  }
}
