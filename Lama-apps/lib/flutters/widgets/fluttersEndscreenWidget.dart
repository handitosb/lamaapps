import 'package:flutter/material.dart';
import 'package:lama_app/util/LamaColors.dart';

/// This class is a [StatelessWidget] for displaying the game over Mode of Flybird
class FluttersEndscreenWidget extends StatelessWidget {
  /// Score to display on game over menu.
  final String text;

  /// score to display
  final int score;
  /// highscore of the current user in the current game
  final int userHighScore;
  /// highscore of the current game
  final int alltimeHighScore;

  // This function will be called when quit button is pressed.
  final Function onQuitPressed;

  const FluttersEndscreenWidget({
    Key key,
    this.text,
    this.userHighScore, this.alltimeHighScore,

    @required this.score,
    @required this.onQuitPressed,
  })  : assert(score != null),
        assert(onQuitPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Color(0xFFd3d3d3).withOpacity(0.8),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 10,
                  ),
                child: Text(
                  text,
                    textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                            color: LamaColors.black.withOpacity(0.3),
                            offset: Offset(2,2)
                        ),
                      ],
                      fontSize: 25.0,
                      color: LamaColors.white,
                      fontStyle: FontStyle.normal,
                      decoration: TextDecoration.none),
                ),
              ),
              Text(
                'Punkte',
                style: TextStyle(fontSize: 40.0, color: LamaColors.bluePrimary),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  '$score',
                  style: TextStyle(fontSize: 70.0, color: LamaColors.bluePrimary),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: LamaColors.bluePrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15
                      ),
                    ),
                    child: Text(
                      'Beenden',
                      style: TextStyle(
                        color: LamaColors.white,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      onQuitPressed.call();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
