import 'package:flutter/material.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/HappyBird/HappyBirdGame.dart';

/// This class is a [StatelessWidget] for displaying the play Mode of HappyBird
/// It needs the [onButtonPressed] [Function] to ensure its workability.
class Play_mode extends StatelessWidget {
  // true = pause icon / false = play icon
  final bool playMode;
  // This function will be called when button is pressed.
  final Function onButtonPressed;

  const Play_mode({
    @required this.onButtonPressed,
    @required this.playMode
  });

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topCenter,
        child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: LamaColors.orangeAccent.withOpacity(0.7),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5
                      ),
                    ),
                    child: Icon(
                      playMode ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    onPressed: () {
                      onButtonPressed?.call();
                    },
                  ),
                ])
        )
    );
  }
}