import 'package:flutter/material.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/flutters/FluttersGame.dart';


/// This class creates the Flutters game screen
class FluttersGameScreen extends StatelessWidget {
  final UserRepository userRepository;

  const FluttersGameScreen(this.userRepository);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Flybird"),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                      child: Container(
                        color: Colors.green,
                        child: FluttersGame(context, userRepository).widget,
                      )
                  )
                ]
            )
        )
    );
  }
}
