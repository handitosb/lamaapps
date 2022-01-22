import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lama_app/HappyBird/constant.dart';
import 'package:lama_app/util/LamaColors.dart';

import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';


class DemoPage extends StatefulWidget {
  final Function onStartPressed;
  final int userHighScore;
  final int alltimeHighScore;
  DemoPage({@required this.onStartPressed, this.userHighScore, this.alltimeHighScore});


  @override
  State<StatefulWidget> createState() => _DemoPageState();
}
class _DemoPageState extends State<DemoPage> {
  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();
  bool isAuthenticated = false;
  bool isEnabled = true ;

  enableButton(){

    setState(() {
      isEnabled = true;
    });
  }

  disableButton(){

    setState(() {
      isEnabled = false;
    });
  }

  sampleFunction(){

    print('Clicked');
  }


  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

      return Center(
        child: Container (
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
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
                        "HappyBird",
                        style: TextStyle(
                          color: LamaColors.bluePrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        ),
                      ),
                      Text(
                        "\nFür die Freischaltung muss du bei Flybird mindestens 200 Punkte erreichen, dann erhält du ein PIN. Viel Spaß!\n\nDrücke auf den Bildschirm, um den Vogel ein wenig Auftrieb zu verleihen und achte dabei auf die Hindernisse, sowie den unteren Bildschirmrand.\n",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: LamaColors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Flexible(
                        child: Text("Mein Rekord: ${widget.userHighScore.toString()}\n",
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: LamaColors.bluePrimary,
                            )
                        ),
                      ),
                      Flexible(
                        child: Text("Rekord: ${widget.alltimeHighScore.toString()}\n",
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: LamaColors.bluePrimary,
                            )
                        ),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: isAuthenticated? LamaColors.orangeAccent : Colors.grey,
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
                            if (isAuthenticated) {
                            widget.onStartPressed.call();
                            }
                            else {
                           isAuthenticated? () => widget.onStartPressed.call() : null;
                            }

                            } ),
                _lockScreenButton(context),
                    ],
                  ),
                ),
              ),
            )
        ),
      );









  }

  _lockScreenButton(BuildContext context) => MaterialButton(
    padding: EdgeInsets.only(left: 40,right: 40),
    color: Theme.of(context).primaryColor,
    child: Text('Freischalten',style: TextStyle(color: Colors.white,
        fontWeight: FontWeight.bold,fontSize: 17),),
    onPressed: () {
      _showLockScreen(
        context,
        opaque: false,
        cancelButton: Text(
          'Abbrechen',
          style: const TextStyle(fontSize: 16, color: Colors.white,),
          semanticsLabel: 'Abbrechen',
        ),
      );
    },
  );



  _showLockScreen(BuildContext context,
      {bool opaque,
        CircleUIConfig circleUIConfig,
        KeyboardUIConfig keyboardUIConfig,
        Widget cancelButton,
        List<String> digits}) {
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, Animation) => PasscodeScreen(
            title: Text(
              'Pin Eingabe',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            circleUIConfig: circleUIConfig,
            keyboardUIConfig: keyboardUIConfig,
            passwordEnteredCallback: _passcodeEntered,
            cancelButton: cancelButton,
            deleteButton: Text(
              'Löschen',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: 'Löschen',
            ),
            shouldTriggerVerification: _verificationNotifier.stream,
            cancelCallback: _passcodeCancelled,


            digits: digits,
            passwordDigits: 4,


          ),
        ));
  }

  _passcodeEntered(String enteredPasscode) {
    bool isValid = storedPasscode == enteredPasscode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      setState(() {
        this.isAuthenticated = isValid;


      }

      );
    }
  }

  _passcodeCancelled() {
    Navigator.maybePop(context);
  }

}




