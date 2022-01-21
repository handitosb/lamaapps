import 'dart:ui';
import 'dart:math';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/flutters/FluttersGame.dart';
import 'package:lama_app/flutters/components/fluttersObstacle.dart';



/// This class is [Component] to display a [List] of [fluttersObstacle]s.
class Obstacle extends Component {
  // SETTINGS
  // --------

  /// flag to show the cloud on the display
  final bool _showCollisionCloud = false;
  // --------
  // SETTINGS

  /// reference to the BaseGame
  final FluttersGame _game;
  /// Random for generate random bools
  final Random _rnd = Random();
  /// Cloud SpriteComponents
  List<FluttersObstacle> _clouds;
  /// Number of clouds on the display
  double _cloudCount;
  /// Offset of all clouds to the middle of the screen on the x coordinate
  final double _offsetX;
  /// Distance of all clouds to another on the y coordinate
  final double _cloudDistance;
  /// last cloud on the screen
  SpriteComponent _lastCloud;
  /// flag if the components are moving
  bool _moving = false;
  /// pixel each component will move on the y coordinate
  double _moveWidth = 96;
  /// pixel left which the components has to move
  double _moveTimeLeft = 0;
  /// Time how long the movements takes
  final double _moveTime;
  /// This method gets called when the clouds finished moving
  Function onCloudsMoved;
  /// Cloud for collision detection
  FluttersObstacle collisionCloud;


  /// This getter returns if the next cloud which the bird will hit is on the left side
  get isLeft {
    return collisionCloud != null && collisionCloud.x < _game.screenSize.width / 2;
  }

  Obstacle(this._game, this._cloudDistance, this._offsetX, this._moveTime) {
    _createClouds();
  }

  /// This method highlightes the cloud which the bird will hit.
  void highlightCollisionCloud() {
    collisionCloud.hit = true;
    collisionCloud.sprite = Sprite('png/explosion.png');
    collisionCloud.height = 150;
    collisionCloud.width = 150;

  }

  /// This method creates all cloud SpriteComponents
  void _createClouds() {
    _cloudCount = (_game.screenSize.height / (_cloudDistance)) + 1;
    // clear clouds
    _clouds = [];

    for(var i = 0; i < _cloudCount; i++){
      var cloud = FluttersObstacle()
        ..height = _game.cloudSize * 2
        ..width = _game.cloudSize * 2
        ..y = _game.screenSize.height / 1.5 - (_cloudDistance + i*_cloudDistance)
        ..anchor = Anchor.topLeft;
      _clouds.add(cloud);

      if (_rnd.nextBool()) {
        cloud.sprite = Sprite('png/angrycloud1.png');
        cloud.x = _game.screenSize.width / 2 - this._offsetX - 3 * _game.cloudSize;
      }
      else {
        cloud.sprite = Sprite('png/angrycloud.png');
        cloud.x = _game.screenSize.width / 2 + this._offsetX;
      }

      _lastCloud = cloud;
    }
  }

  /// This method checks all clouds if they are out of the screen and reset them to the start,
  void _updateClouds() {
    for (FluttersObstacle cloudElement in _clouds) {
      if (cloudElement.y > _game.screenSize.height) {
        cloudElement.y = _lastCloud.y - _cloudDistance;
        cloudElement.opacity = 1;

        if (_rnd.nextBool()) {
          cloudElement.sprite = Sprite('png/angrycloud1.png');
          cloudElement.x = _game.screenSize.width / 2 - this._offsetX - 3 * _game.cloudSize;
        }
        else {
          cloudElement.sprite = Sprite('png/angrycloud.png');
          cloudElement.x = _game.screenSize.width / 2 + this._offsetX;
        }
        _lastCloud = cloudElement;
      }
    }
  }

  /// This method selectes the next cloud after the current [collisionCloud] as [collisionCloud].
  void _selectNextCollisionDetectionCloud() {
    var index = collisionCloud == null ? 0 : _clouds.indexOf(collisionCloud);

    if (collisionCloud == null || index >= _clouds.length - 1) {
      collisionCloud = _clouds[0];
    }
    else {
      collisionCloud = _clouds[index + 1];

    }

  }


  /// This will handle in [update]
  void move(double y) {
    if (_moving) {
      return;
    }

    _moveTimeLeft = _moveTime;
    _moving = true;
    _moveWidth = y;
    _selectNextCollisionDetectionCloud();
  }

  @override
  void update(double t) {
      // movement active?
      if (_moving && _game.screenSize != null) {
        // movement ongoing?
        if (_moveTimeLeft > 0) {
          var dtMoveWidth = (_moveWidth) * ((t < _moveTimeLeft ? t : _moveTimeLeft) / _moveTime);
          var percentOver = ((t < _moveTimeLeft ? t : _moveTimeLeft) / _moveTime);
          _clouds?.forEach((element) {
            element.y += dtMoveWidth;

            if (element == collisionCloud) {
              element.opacity = percentOver;
            }
          });

          _updateClouds();

          _moveTimeLeft -= t;
        }
        // movement finished = disable movement
        else {
          collisionCloud.opacity = 0;
          onCloudsMoved?.call();
          _moving = false;
        }
      }
    }

    @override
    void render(Canvas c) {
      _clouds?.forEach((element) async {
        c.save();
        element.render(c);

        // show the collision clouds
        if (collisionCloud != null) {
          c.restore();
          c.save();

        }
        c.restore();
      });
    }
  }