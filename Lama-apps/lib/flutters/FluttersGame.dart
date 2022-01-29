import 'dart:collection';

import 'package:flame/gestures.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/components/parallax_component.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:lama_app/flutters/components/bird.dart';
import 'package:lama_app/flutters/widgets/PlayPauseModeWidget.dart';
import 'package:lama_app/flutters/widgets/fluttersScoreWidget.dart';
import 'package:lama_app/flutters/widgets/fluttersStartWidget.dart';

import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/model/highscore_model.dart';
import 'package:lama_app/flutters/components/Obstacle.dart';
import '../app/screens/game_list_screen.dart';
import 'package:lama_app/flutters/widgets/fluttersEndscreenWidget.dart';

import 'package:lama_app/HappyBird/constant.dart';


/// This class represents the flybird game and its components.
class FluttersGame extends BaseGame with TapDetector, HasWidgetsOverlay {
  // SETTINGS
  // --------

  /// amount of tiles on the x coordinate
  final int tilesX = 9;

  /// size of the bird
  final double _birdSize = 55;

  /// name of the start screen widget
  final startWidgetName = "start";

  /// name of the end screen widget
  final endScreenWidgetName = "gameOver";

  /// name of the end screen widget
  final scoreWidgetName = "score";

  /// name of the end screen widget
  final playPauseWidgetName = "playmode";

  /// id of the game
  final _gameId = 4;

  /// Time for each click animation
  final _animationTime = 0.125;

  Bird _bird;
  Queue<FlySide> _inputQueue = Queue();


  /// flag which indicates if the game is running
  bool _running = false;

  /// a bool flag which indicates if the score of the game has been saved
  bool _savedHighScore = false;

  /// the personal highScore
  int _userHighScore;

  /// the all time highScore in this game
  int _allTimeHighScore;

  /// the achieved score in this round
  int score = 0;

  /// necessary context for determine the actual screenSize
  BuildContext _context;

  /// Size of the screen
  Size screenSize;


  Obstacle _obstacle;
  double cloudSize;


  /// the [UserRepository] to interact with the database and get the user infos
  UserRepository _userRepo;




  FluttersGame(this._context, this._userRepo) {
    // background with moving clouds
    var back = ParallaxComponent([
      ParallaxImage('png/sky.png', repeat: ImageRepeat.repeat),

      ParallaxImage('png/cl.png', repeat: ImageRepeat.repeat),

    ], baseSpeed: Offset(0, -10), layerDelta: Offset(0, -1));


    // add background
    add(back);

    initialize();
  }



  /// This method load the [Size] of the screen, highscore and loads the StartScreen
  void initialize() async {
    resize(await Flame.util.initialDimensions());
    // load _serHighScore
    _userHighScore = await _userRepo.getMyHighscore(_gameId);
    // load allTimeHighScore
    _allTimeHighScore = await _userRepo.getHighscore(_gameId);





    addWidgetOverlay(
        startWidgetName,
        Screen_start(
            userHighScore: _userHighScore,
            alltimeHighScore: _allTimeHighScore,
            onStartPressed: _startGame));
  }

  /// This method increase the score as well as the score widget.
  void increaseScore() {
    score += 1;
    _updateScoreWidget();
  }

  /// This method decrease the score as well as the score widget.
  void decreaseScore() {
    score -= 1;
    _updateScoreWidget();
  }

  /// This methods updates the score widget.
  void _updateScoreWidget() {
    if (!_running) {
      return;
    }

    removeWidgetOverlay(scoreWidgetName);
    addWidgetOverlay(
        scoreWidgetName, FluttersScoreWidget(text: score.toString()));
  }

  /// This method checks if the bird collides with the collision cloud.
  void _checkCollision() {


    if (_bird.isLeft == _obstacle.isLeft) {
      _obstacle.highlightCollisionCloud();

      if (score <= 199){
        _gameOver("Game Over", (''));

      }else{
        _gameOver("Game Over.\nAufgepasst! Du kannst jetzt HappyBird freischalten.\nPIN:", element);


      }
    }


  }


  /// This method initialize the components and removes the start widget.
  void _startGame() {
    if (_userRepo.getLamaCoins() < GameListScreen.games[_gameId - 1].cost) {
      Navigator.pop(_context, "NotEnoughCoins");
      return;
    }
    _userRepo.removeLamaCoins(GameListScreen.games[_gameId - 1].cost);
    _addGameComponents();
    removeWidgetOverlay(startWidgetName);
    addWidgetOverlay(
        scoreWidgetName, FluttersScoreWidget(text: score.toString()));

    addWidgetOverlay(playPauseWidgetName,
        PlayPauseModeWidget(playMode: true, onButtonPressed: _pauseGame));

    _running = true;
  }

  /// This method pauses the game.
  void _pauseGame() {
    pauseEngine();

    // removed the playMode widget
    removeWidgetOverlay(playPauseWidgetName);
    addWidgetOverlay(playPauseWidgetName,
        PlayPauseModeWidget(playMode: false, onButtonPressed: _resumeGame));

    _running = false;
  }

  /// This method resumes the game.
  void _resumeGame() {
    resumeEngine();

    // remove the pauseMode widget
    removeWidgetOverlay(playPauseWidgetName);

    // add the playMode widget
    addWidgetOverlay(playPauseWidgetName,
        PlayPauseModeWidget(playMode: true, onButtonPressed: _pauseGame));

    _running = true;
  }

  /// This method adds all components which are necessary to the game.
  void _addGameComponents() {


    // initialize bird
    _bird = Bird(_birdSize, _animationTime)
      ..onMovementFinished = _checkCollision;
    add(_bird);

    // add clouds
    _obstacle =
    Obstacle(this, _birdSize, _birdSize / 4, _animationTime)
      ..onCloudsMoved = increaseScore;
    add(_obstacle);


  }

  /// This method saves the actual Score to the database for the user which is logged in.
  ///
  /// sideffects:
  ///   [_savedHighScore] = true
  void _saveHighScore() {
    if (!_savedHighScore) {
      _savedHighScore = true;
      _userRepo.addHighscore(Highscore(
          gameID: _gameId,
          score: score,
          userID: _userRepo.authenticatedUser.id));
    }
  }

  /// This method finishes the game.
  ///
  /// sideffects:
  ///   adds [FluttersEndscreenWidget] widget
  void _gameOver(String endText, String pin) {

    _running = false;
    pauseEngine();
    _saveHighScore();

    removeWidgetOverlay(scoreWidgetName);
    addWidgetOverlay(
        endScreenWidgetName,
        FluttersEndscreenWidget(
          text: endText,
          //TODO: I have commented this because attribute "pin" wasn't present in the parent class "FlutterEndScreenWidget"
          // pin: pin,
          score: score,
          onQuitPressed: _quit,


        ));


    // removed the playMode widget
    removeWidgetOverlay(playPauseWidgetName);
  }

  /// This method closes the game widget.
  void _quit() {
    removeWidgetOverlay(endScreenWidgetName);
    Navigator.pop(_context);
  }


  @override
  void update(double t) {
    // check input queue to select the next movement
    if (_bird != null && !_bird.isMoving && _inputQueue.isNotEmpty) {
      components
          .whereType<Bird>()
          .forEach((element) => element.move(_inputQueue.removeLast()));



      // move the clouds
      _obstacle.move(_birdSize);
    }



    super.update(t);
  }

  void resize(Size size) {
    screenSize = Size(
        MediaQuery.of(_context).size.width-
            MediaQuery.of(_context).padding.left -
            MediaQuery.of(_context).padding.right,
        MediaQuery.of(_context).size.height -
            MediaQuery.of(_context).padding.top / 0.5 -
            MediaQuery.of(_context).padding.bottom);


    cloudSize = (MediaQuery.of(_context).size.width) / tilesX;

    super.resize(size);
  }

  void render(Canvas c) {
    super.render(c);
  }

  void onTapDown(TapDownDetails d) {
    if (_running) {
      // add input to queue
      _inputQueue.addFirst(d.localPosition.dx < screenSize.width / 2
          ? FlySide.Left
          : FlySide.Right);
    }
  }
}
