import 'dart:ui';
import 'dart:developer' as developer;

import 'package:flame/components/parallax_component.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:lama_app/HappyBird/components/ScoreDisplay.dart';
import 'package:lama_app/HappyBird/components/bird2.dart';
import 'package:lama_app/HappyBird/components/Obstacle.dart';
import 'package:lama_app/HappyBird/widgets/play_mode.dart';
import 'package:lama_app/HappyBird/widgets/game_over.dart';
import 'demo_page.dart';

import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/model/highscore_model.dart';
import '../app/screens/game_list_screen.dart';


/// This class represents the HappyBird game and its components.
class HappyBirdGame extends BaseGame with TapDetector, HasWidgetsOverlay {
  // SETTINGS
  // --------

  /// the id of HappyBird game which is used in the database
  final int _gameId = 5;

  /// amount of tiles on the x coordinate
  final int tilesX = 9;

  /// size of the bird
  final double _birdSize = 50;
  // name of the pauseMode widget
  final String _pauseMode = "PauseMode";
  // name of the playMode widget
  final String _playMode = "PlayMode";
  // name of the gameOver widget
  final String _gameOverMode = "GameOverMode";
  // name of the startScreen widget
  final String _lockScreen = "LockScreen";

  /// score where the difficulty will increase
  final int _difficultyScore = 5;

  /// how many times the user can play this game
  int _lifes = 3;
  // --------
  // SETTINGS

  /// obstacle list
  List<Obstacle> obstacles = [];

  /// screensize of the game
  Size _screenSize;

  /// pixel of the quadratic tiles
  double _tileSize;

  /// amount of tiles on the y coordinate
  int _tilesY;

  /// the achieved score in this round
  int score = 0;

  /// necessary context for determine the actual screensize
  BuildContext _context;

  /// a bool flag which indicates if the game has started
  bool _started = false;

  /// a bool flag which indicates if the score of the game has been saved
  bool _savedHighscore = false;

  /// the personal highscore
  int _userHighScore = 0;

  /// the all time highscore in this game
  int _alltimeHighScore = 0;

  /// the bird [AnimationComponent]
  Bird _bird;

  /// the [UserRepository] to interact with the database and get the user infos
  UserRepository _userRepo;

  /// Getter of [_started]
  bool get started {
    return _started;
  }

  /// Getter of [_screenSize]
  Size get screenSize {
    return _screenSize;
  }

  /// Getter of [_tilesY]
  int get tilesY {
    return _tilesY;
  }

  /// Getter of [_tileSize]
  double get tileSize {
    return _tileSize;
  }

  HappyBirdGame(this._context, this._userRepo) {
    // background with moving clouds
    var back = ParallaxComponent([
      ParallaxImage('png/sky000.png', repeat: ImageRepeat.repeat),

    ], baseSpeed: Offset(7, 0), layerDelta: Offset(10, 0));

    // load all obstacle pngs
    Flame.images.loadAll([
      'png/200.png',

    ]);

    // add background
    add(back);

    initializeAsync();
  }

  /// This method load the [Size] of the screen and loads the StartScreen
  void initializeAsync() async {
    // resize
    resize(await Flame.util.initialDimensions());

    loadStartScreenAsync();
  }


  /// This method saves the actual Score to the database for the user which is logged in.
  ///
  /// sideffects:
  ///   [_savedHighscore] = true
  void saveHighscore() {
    if (!_savedHighscore) {
      _savedHighscore = true;
      _userRepo.addHighscore(Highscore(
          gameID: _gameId,
          score: score,
          userID: _userRepo.authenticatedUser.id));
    }
  }

  /// This method resets the game so another round can start.
  ///
  /// sideeffects:
  ///   [score] = 0
  ///   [_savedHighscore] = false
  ///   [components]
  ///   displayed widget
  void resetGame() {
    _savedHighscore = false;
    score = 0;

    // remove gameOver widget
    removeWidgetOverlay(_gameOverMode);

    // removes score
    components.removeWhere((element) => element is ScoreDisplay);

    // removes obstacles
    components.removeWhere((element) => element is Obstacle);

    // removes lama
    components.removeWhere((element) => element is Bird);

    loadStartScreenAsync();
  }

  /// This method load the necessary components to start begin a new game.
  ///
  /// It loads/adds...
  ///   ... the [_userHighscore]
  ///   ... the [_alltimeHighscore]
  ///   ... the [_bird]
  ///   ... the start Screen widget
  void loadStartScreenAsync() async {
    // load highscore
    this._userHighScore = await _userRepo.getMyHighscore(_gameId);
    // load alltimeHighscore
    this._alltimeHighScore = await _userRepo.getHighscore(_gameId);

    // add bird
    _bird = Bird(this, _birdSize)..onHitGround = gameOver;
    add(_bird);

    // add start widget

    addWidgetOverlay(
        _lockScreen,
        DemoPage(
            userHighScore: _userHighScore,
            alltimeHighScore: _alltimeHighScore,
            onStartPressed: startGame));
  }

  void resize(Size size) {
    // get the screensize fom [MediaQuery] because [size] is incorrect on some devices
    _screenSize = Size(
        MediaQuery.of(_context).size.width -
            MediaQuery.of(_context).padding.left -
            MediaQuery.of(_context).padding.right,
        MediaQuery.of(_context).size.height -
            MediaQuery.of(_context).padding.top -
            MediaQuery.of(_context).padding.bottom);
    // calculates by the width of the screen
    _tileSize = screenSize.width / tilesX;
    _tilesY = screenSize.height ~/ tileSize;

    super.resize(size);
  }

  void startGame() {
    if (_userRepo.getLamaCoins() < GameListScreen.games[_gameId - 1].cost) {
      Navigator.pop(_context, "NotEnoughCoins");
      return;
    }
    _userRepo.removeLamaCoins(GameListScreen.games[_gameId - 1].cost);
    // resum game
    resumeEngine();

    // remove start widget
    removeWidgetOverlay(_lockScreen);

    // add playmodebutton widget
    addWidgetOverlay(
        _playMode, Play_mode(playMode: true, onButtonPressed: pauseGame));

    _started = true;

    // add obstacles
    obstacles.clear();
    obstacles.add(Obstacle(this, false, _birdSize, addScore, null, 7, 8));
    obstacles.add(Obstacle(this, true, _birdSize, addScore, null, 7, 8));

    add(obstacles[0]);
    add(obstacles[1]);

    // add reset function = set the ref hole to constraint the hole size and position
    obstacles[0].onResetting = obstacles[1].setConstraints;
    obstacles[1].onResetting = obstacles[0].setConstraints;

    // initial change the second obstacle to avoid a to large gap
    obstacles[1].setConstraints(obstacles[0].holeIndex, obstacles[0].holeSize);
    obstacles[1].resetObstacle();
    obstacles[0].resetObstacle();


    // add score
    add(ScoreDisplay(this));
  }

  /// This methods adds up the score and changes the holesize depending on the score
  void addScore(Obstacle obstacle) {
    score++;

    if (score > _difficultyScore) {
      obstacle.maxHoleSize = 3;
      obstacle.minHoleSize = 2;
    }
  }

  /// This method pauses the game.
  void pauseGame() {
    pauseEngine();

    // removed the playMode widget
    removeWidgetOverlay(_playMode);
    addWidgetOverlay(_pauseMode,
        Play_mode(playMode: false, onButtonPressed: resumeGame));
  }

  /// This method resumes the game.
  void resumeGame() {
    resumeEngine();

    // remove the pauseMode widget
    removeWidgetOverlay(_pauseMode);

    // add the playMode widget
    addWidgetOverlay(
        _playMode, Play_mode(playMode: true, onButtonPressed: pauseGame));
  }

  /// This method finishes the game.
  ///
  /// sideeffects:
  ///   [_lifes] -= 1
  ///   [_started] = false
  ///   removes the play/pause widget
  ///   adds [GameOverMode] widget
  void gameOver() {
    developer.log("Game Over");

    // removes playMode and pausemode widget
    removeWidgetOverlay(_playMode);
    removeWidgetOverlay(_pauseMode);
    components.removeWhere((element) => element is ScoreDisplay);

    // reduces life
    _lifes--;

    pauseEngine();
    _started = false;

    // save highscore
    saveHighscore();

    // add game over widget
    addWidgetOverlay(
        _gameOverMode,
        Game_over(
          score: score,
          lifes: _lifes,
          onQuitPressed: quit,
          onRetryPressed: resetGame,
        ));
  }

  /// This method closes the game widget.
  void quit() {
    removeWidgetOverlay(_gameOverMode);
    Navigator.pop(_context);
  }

  void onTapDown(TapDownDetails d) {
    if (_started) {
      _bird.onTapDown();
    }
  }

  void update(double t) {
    super.update(t);

    if (_started) {
      // check if the bird hits an obstacle
      components.whereType<Obstacle>().forEach((element) {
        if (element.collides(_bird?.toRect() ?? null) == true) {
          gameOver();
        }
      });
    }
  }
}
