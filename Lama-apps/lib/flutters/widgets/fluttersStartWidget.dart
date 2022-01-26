import 'package:flutter/material.dart';
import 'package:lama_app/util/LamaColors.dart';

/// This class is a [StatelessWidget] for displaying the start screen of Flybird
class Screen_start extends StatelessWidget {
  final int userHighScore;
  final int alltimeHighScore;
  // This function will be called when start button is pressed.
  final Function onStartPressed;

  const Screen_start({
    this.userHighScore,
    this.alltimeHighScore,
    @required this.onStartPressed}
      );

  @override
  Widget build(BuildContext context){
    return Center(
      child: Container (
          height: MediaQuery.of(context).size.height * 0.99,
          width: MediaQuery.of(context).size.width * 0.99,
          child: Card(
            margin: EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 10.0
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35.0)
            ),
            color: Color(0xFFd3d3d3).withOpacity(0.4),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 15.0
              ),
              child: SafeArea(
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child:Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/png/bird-0.png'//platzhalter
                              ),
                            )
                        ),
                      ),
                    ),
                    Text(
                      "Flybird",
                      style: TextStyle(
                        color: LamaColors.bluePrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                    ),
                    Text(
                      "\nTippe rechts oder links auf den Bildschirm, damit der Vogel nach oben fliegen kann und achte dabei auf die Hindernisse.\n\nAb 200 Punkte erhältst du ein PIN für die Freischaltung von HappyBird.\n\n",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: LamaColors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Flexible(
                      child: Text("Mein Rekord: ${userHighScore.toString()}\n",
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: LamaColors.bluePrimary,
                          )
                      ),
                    ),
                    Flexible(
                      child: Text("Rekord: ${alltimeHighScore.toString()}\n",
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: LamaColors.bluePrimary,
                          )
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: LamaColors.orangeAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 35,
                            vertical: 8
                        ),
                      ),
                      child: Text(
                        "Start",
                        style: TextStyle(fontSize: 30.0),
                      ),
                      onPressed: () {
                        onStartPressed.call();
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}