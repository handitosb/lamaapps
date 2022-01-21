import 'package:flutter/material.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/HappyBird/HappyBirdGame.dart';


/// This class creates the HappyBird game screen
class HappyBirdGameScreen extends StatelessWidget {
  final UserRepository userRepository;

  const HappyBirdGameScreen(this.userRepository);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("HappyBird"),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                      child: Container(
                        color: Colors.green,
                        child: HappyBirdGame(context, userRepository).widget,
                      )
                  )
                ]
            )
        )
    );
  }
}
