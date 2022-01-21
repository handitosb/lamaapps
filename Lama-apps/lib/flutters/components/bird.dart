import 'dart:ui';

import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';

/// This class is [AnimationComponent] to display a bird with all its properties.
class Bird extends AnimationComponent {
  // SETTINGS
  // --------
  /// time which is needed to move
  final stepTime;
  /// offset (x, y) of the bird to the center of the screen relative to its size (value * _size)
  final relOffsetCenter = [0.8, 0.8];
  // --------
  // SETTINGS

  /// width and height of the bird in pixel
  final double _size;
  /// animation of idling left
  Animation _idleLeft;
  /// animation of idling right
  Animation _idleRight;
  /// animation of flying left
  Animation _flyLeft;
  /// animation of flying right
  Animation _flyRight;
  /// animation of change left
  Animation _switchLeft;
  /// animation of change right
  Animation _switchRight;
  /// is the bird on the left side of the screen
  bool _isLeft = true;
  /// is the bird switching the sides
  bool _switching = false;
  /// time left for the switching
  double _moveTimeLeft = 0;
  /// is the bird moving (switching or flying)
  bool _moving = false;
  /// Function which gets called when the movement finished
  Function onMovementFinished;

  get isLeft {
    return _isLeft;
  }

  get isMoving {
    return _moving;
  }

  /// Initialize the class with the given [_size] and [_game].
  Bird(this._size, this.stepTime) : super.empty() {
    // size
    height = _size;
    width = _size;

    // loads the spriteSheet from assets
    final spriteSheet = SpriteSheet(
      imageName: 'png/birdanimation.png',
      textureWidth: 57,
      textureHeight: 57,
      columns: 11,
      rows: 1,
    );

    // loads the spriteSheet from assets
    final spriteSheetMirror = SpriteSheet(
      imageName: 'png/birdanimation1.png',
      textureWidth: 57,
      textureHeight: 57,
      columns: 11,
      rows: 1,
    );

    // idle
    _idleLeft = spriteSheet.createAnimation(0, loop: true, from: 0, to: 2, stepTime: stepTime);
    _idleRight = spriteSheetMirror.createAnimation(0, loop: true, from: 0, to: 2, stepTime: stepTime);

    // fly
    _flyLeft = spriteSheet.createAnimation(0, loop: false, from: 3, to: 5, stepTime: stepTime / 4);
    _flyRight = spriteSheetMirror.createAnimation(0, loop: false, from: 3, to: 5, stepTime: stepTime / 4);

    // change
    _switchLeft = spriteSheet.createAnimation(0, loop: false, from: 6, to: 8, stepTime: stepTime / 4);
    _switchRight = spriteSheetMirror.createAnimation(0, loop: false, from: 6, to: 8, stepTime: stepTime / 4);

    animation = _idleLeft;
  }


  /// This method will activate the matching move animation to its [side] and its constraints.
  void move(FlySide side) {
    switch (side) {
      case FlySide.Left:
        _isLeft ? flyUp() : switchSides();
        break;
      case FlySide.Right:
        _isLeft ? switchSides() : flyUp();
        break;
    }
  }

  /// This method will activate the fly up animation one time to its corresponding side and set its constraints.
  ///
  /// sideeffects:
  ///   [_moving] = true
  ///   [_animation] = fly animation
  void flyUp() {
    if (_moving) {
      return;
    }

    _moving = true;
    _moveTimeLeft = stepTime;

    animation = _isLeft ? _flyLeft : _flyRight
      ..reset();
  }


  /// This method will activate the switch animation one time to its corresponding side and set its constraints.
  ///
  /// sideeffects:
  ///   [_moving] = true
  ///   [_switching] = true
  ///   [_moveTimeLeft] = [stepTime]
  ///   [_animation] = switch animation
  void switchSides() {
    if (_moving) {
      return;
    }

    _moving = true;
    _switching = true;
    _moveTimeLeft = stepTime;

    animation = _isLeft ? _switchLeft : _switchRight
      ..reset();
  }

  @override
  void update(double t) {
    // bird is switching the sides
    if (_moving) {
      if (_moveTimeLeft > 0) {
        if (_switching) {
          // calculate the width the bird moves on the x coordinate in t
          var stepWidth = (_size + 2 * relOffsetCenter[0] * _size) * ((t < _moveTimeLeft ? t : _moveTimeLeft) / stepTime);
          // decrease or increase the x coordinate depending on the direction
          x += (_isLeft) ? stepWidth : -stepWidth;
        }
        // decrease the switchTimeLeft
        _moveTimeLeft -= t;
      }
      else {
        if (_switching) {
          _switching = false;
          _isLeft = !_isLeft;
        }

        // reset moving flags
        _moving = false;
        animation = _isLeft ? _idleLeft : _idleRight;

        onMovementFinished?.call();

      }
    }

    super.update(t);
  }

  void resize(Size size) {
    // start location in the center with the offset
    x = size.width / 2 - _size - relOffsetCenter[0] * _size;
    y = size.height / 1.4 - _size / 2 - relOffsetCenter[1] * _size;
  }
}

enum FlySide {
  Left,
  Right
}