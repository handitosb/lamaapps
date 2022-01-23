import 'package:flutter/material.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

/// This class is a [StatelessWidget] for displaying the play Mode of Flybird
/// It needs the [onButtonPressed] [Function] to ensure its workability.
class FluttersScoreWidget extends StatelessWidget {
  // text which gets displayed
  final String text;

  const FluttersScoreWidget({
    @required this.text
  });

  @override
  Widget build(BuildContext context) {
    Color color = LamaColors.bluePrimary.withOpacity(0.7);

    return Padding(
        padding: EdgeInsets.only(top: 20),
        child: Align(
            alignment: Alignment.topCenter,
            child: Container(
                height: 50,
                width: 100,
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 2),
                          blurRadius: 5,
                          color: LamaColors.black.withOpacity(0.5))
                    ]),
                child: Center(
                  child: InkWell(
                      child: Text(
                        text,
                        style: LamaTextTheme.getStyle(fontSize: 25),
                      )
                  ),
                )
            )
        )
    );
  }
}