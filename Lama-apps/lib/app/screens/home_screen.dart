import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lama_app/app/bloc/choose_taskset_bloc.dart';
import 'package:lama_app/app/bloc/game_list_screen_bloc.dart';
import 'package:lama_app/app/bloc/user_selection_bloc.dart';
import 'package:lama_app/app/repository/lamafacts_repository.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/screens/choose_taskset_screen.dart';
import 'package:lama_app/app/screens/user_selection_screen.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

import 'game_list_screen.dart';

/// [StatefulWidget] that contains the main menu screen
///
/// This is a Stateful Widget so it can be reloaded using setState((){})
/// after Navigation, primarily to reflect changes to the lama coin amount.
///
/// Author: K.Binder
class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

/// [State] that contains the UI side logic for the [HomeScreen]
///
/// Author: K.Binder
class _HomeScreenState extends State<HomeScreen> {
  UserRepository userRepository;

  DateTime backButtonPressedTime;

  final snackBar = SnackBar(
      backgroundColor: LamaColors.mainPink,
      content: Text(
        'Zweimal drücken zum verlassen!',
        textAlign: TextAlign.center,
        style: LamaTextTheme.getStyle(fontSize: 15, color: LamaColors.white),
      ),
      duration: Duration(seconds: 1));

  @override
  Widget build(BuildContext context) {
    userRepository = RepositoryProvider.of<UserRepository>(context);
    return Scaffold(
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Container(
          color: LamaColors.mainPink,
          child: SafeArea(
            child: Container(
              color: Colors.white,
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Column(
                  children: [
                    Container(
                      height: (constraints.maxHeight / 100) * 17.5,
                      child: Stack(
                        children: [
                          Container(
                            height: (constraints.maxHeight / 100) * 10,
                            decoration: BoxDecoration(
                              color: LamaColors.mainPink,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          ((constraints.maxWidth / 100) * 2.5)),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: IconButton(
                                      padding: EdgeInsets.all(0),
                                      icon: Icon(
                                        Icons.logout,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                      onPressed: () =>
                                          Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                            create: (BuildContext context) =>
                                                UserSelectionBloc(),
                                            child: UserSelectionScreen(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text("Lerne alles mit Anna",
                                    style: LamaTextTheme.getStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: (constraints.maxHeight / 100) * 10,
                              width: (constraints.maxWidth / 100) * 70,
                              decoration: BoxDecoration(
                                color: LamaColors.mainPink,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    child: SvgPicture.asset(
                                      'assets/images/svg/avatars/${userRepository.getAvatar()}.svg',
                                      semanticsLabel: 'LAMA',
                                    ),
                                    radius: 25,
                                    backgroundColor: LamaColors.mainPink,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    userRepository.getUserName(),
                                    style: LamaTextTheme.getStyle(
                                        fontSize: 22.5,
                                        fontWeight: FontWeight.w600,
                                        monospace: true),
                                  ),
                                  RawMaterialButton(
                                    elevation: 10,
                                    child: Icon(Icons.add_a_photo),
                                    padding: EdgeInsets.all(10.0),
                                    shape: CircleBorder(),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                title: Text(
                                                  'Bitte Auswählen',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          LamaColors.mainPink),
                                                ),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: [
                                                      InkWell(
                                                        splashColor:
                                                            Colors.purpleAccent,
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Icon(
                                                                  Icons.image,
                                                                  color: Colors
                                                                      .purpleAccent),
                                                            ),
                                                            Text('Galerie',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18))
                                                          ],
                                                        ),
                                                      ),
                                                      InkWell(
                                                        splashColor:
                                                            Colors.purpleAccent,
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Icon(
                                                                  Icons.remove,
                                                                  color: Colors.red),
                                                            ),
                                                            Text('Bild löschen',
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    color: Colors.red)
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ));
                                          });
                                    },
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: LayoutBuilder(builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return Stack(
                          children: [
                            Center(
                              child: Container(
                                  width: (constraints.maxWidth / 100) * 75,
                                  height: (constraints.maxHeight / 100) * 75,
                                  child: _buildMenuButtonColumn(constraints)),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 15, bottom: 15),
                                child: SvgPicture.asset(
                                  "assets/images/svg/lama_head.svg",
                                  semanticsLabel: "Lama Anna",
                                  width: (constraints.maxWidth / 100) * 15,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: 20,
                                    right: (constraints.maxWidth / 100) * 15),
                                child: Container(
                                  height: (constraints.maxHeight / 100) * 10,
                                  width: (constraints.maxWidth / 100) * 80,
                                  child: Bubble(
                                    nip: BubbleNip.rightCenter,
                                    color: LamaColors.mainPink,
                                    borderColor: LamaColors.mainPink,
                                    shadowColor: LamaColors.black,
                                    child: Center(
                                      child: Text(
                                        RepositoryProvider.of<
                                                LamaFactsRepository>(context)
                                            .getRandomLamaFact(),
                                        style: LamaTextTheme.getStyle(
                                            fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  ///Return a Widget that contains the complete center column with
  ///all subjects and the game button.
  ///
  ///Note that if no Tasksets are loaded for a specific combination
  ///(e.g. (Mathe, Grade 4)) the corresponding button will be emmited
  ///from the column.
  Widget _buildMenuButtonColumn(BoxConstraints constraints) {
    List<Widget> children = [];
    TasksetRepository tasksetRepository =
        RepositoryProvider.of<TasksetRepository>(context);

    if (tasksetRepository
            .getTasksetsForSubjectAndGrade("Mathe", userRepository.getGrade())
            .length >
        0) {
      children.add(ElevatedButton(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Text(
                "Mathe",
                style: LamaTextTheme.getStyle(),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                child: SvgPicture.asset(
                  'assets/images/svg/MainMenu_Icons/mathe_icon.svg',
                  semanticsLabel: 'MatheIcon',
                ),
                backgroundColor: LamaColors.bluePrimary,
              ),
            )
          ],
        ),
        style: ElevatedButton.styleFrom(
            primary: LamaColors.blueAccent,
            minimumSize: Size(
              (constraints.maxWidth / 100) * 80,
              ((constraints.maxHeight / 100) * 10),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)))),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (BuildContext context) =>
                  ChooseTasksetBloc(context.read<TasksetRepository>()),
              child: ChooseTasksetScreen(
                  "Mathe", userRepository.getGrade(), userRepository),
            ),
          ),
        ).then((value) => (setState(() {}))),
      ));
      children.add(SizedBox(height: (constraints.maxHeight / 100) * 2.5));
    }
    if (tasksetRepository
            .getTasksetsForSubjectAndGrade("Deutsch", userRepository.getGrade())
            .length >
        0) {
      children.add(ElevatedButton(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Text(
                "Deutsch",
                style: LamaTextTheme.getStyle(),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                child: SvgPicture.asset(
                  'assets/images/svg/MainMenu_Icons/deutsch_icon.svg',
                  semanticsLabel: 'DeutschIcon',
                ),
                backgroundColor: LamaColors.redPrimary,
              ),
            )
          ],
        ),
        style: ElevatedButton.styleFrom(
            primary: LamaColors.redAccent,
            minimumSize: Size(
              (constraints.maxWidth / 100) * 80,
              ((constraints.maxHeight / 100) * 10),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)))),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (BuildContext context) =>
                  ChooseTasksetBloc(context.read<TasksetRepository>()),
              child: ChooseTasksetScreen(
                  "Deutsch", userRepository.getGrade(), userRepository),
            ),
          ),
        ).then((value) => (setState(() {}))),
      ));
      children.add(SizedBox(height: (constraints.maxHeight / 100) * 2.5));
    }
    if (tasksetRepository
            .getTasksetsForSubjectAndGrade(
                "Englisch", userRepository.getGrade())
            .length >
        0) {
      children.add(ElevatedButton(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Text(
                "Englisch",
                style: LamaTextTheme.getStyle(),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                child: SvgPicture.asset(
                  'assets/images/svg/MainMenu_Icons/englisch_icon.svg',
                  semanticsLabel: 'EnglischIcon',
                ),
                backgroundColor: LamaColors.orangePrimary,
              ),
            )
          ],
        ),
        style: ElevatedButton.styleFrom(
            primary: LamaColors.orangeAccent,
            minimumSize: Size(
              (constraints.maxWidth / 100) * 80,
              ((constraints.maxHeight / 100) * 10),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)))),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (BuildContext context) =>
                  ChooseTasksetBloc(context.read<TasksetRepository>()),
              child: ChooseTasksetScreen(
                  "Englisch", userRepository.getGrade(), userRepository),
            ),
          ),
        ).then((value) => (setState(() {}))),
      ));
      children.add(SizedBox(height: (constraints.maxHeight / 100) * 2.5));
    }
    if (tasksetRepository
            .getTasksetsForSubjectAndGrade(
                "Sachkunde", userRepository.getGrade())
            .length >
        0) {
      children.add(ElevatedButton(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Text(
                "Sachkunde",
                style: LamaTextTheme.getStyle(),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                child: SvgPicture.asset(
                  'assets/images/svg/MainMenu_Icons/sachkunde_icon.svg',
                  semanticsLabel: 'SachkundeIcon',
                ),
                backgroundColor: LamaColors.purplePrimary,
              ),
            )
          ],
        ),
        style: ElevatedButton.styleFrom(
            primary: LamaColors.purpleAccent,
            minimumSize: Size(
              (constraints.maxWidth / 100) * 80,
              ((constraints.maxHeight / 100) * 10),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)))),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (BuildContext context) =>
                  ChooseTasksetBloc(context.read<TasksetRepository>()),
              child: ChooseTasksetScreen(
                  "Sachkunde", userRepository.getGrade(), userRepository),
            ),
          ),
        ).then((value) => (setState(() {}))),
      ));
      children.add(SizedBox(height: (constraints.maxHeight / 100) * 2.5));
    }
    children.add(Container(
      height: ((constraints.maxHeight / 100) * 16),
      width: (constraints.maxWidth / 100) * 80,
      child: Stack(
        children: [
          Container(
            height: ((constraints.maxHeight / 100) * 10),
            width: (constraints.maxWidth / 100) * 80,
            child: ElevatedButton(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Text(
                      "Spiele",
                      style: LamaTextTheme.getStyle(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      child: SvgPicture.asset(
                        'assets/images/svg/MainMenu_Icons/spiel_icon.svg',
                        semanticsLabel: 'SpielIcon',
                      ),
                      backgroundColor: LamaColors.greenPrimary,
                    ),
                  )
                ],
              ),
              style: ElevatedButton.styleFrom(
                  primary: LamaColors.greenAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)))),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (BuildContext context) =>
                        GameListScreenBloc(userRepository),
                    child: GameListScreen(),
                  ),
                ),
              ).then((value) => (setState(() {}))),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: ((constraints.maxHeight / 100) * 7.5),
              width: (constraints.maxWidth / 100) * 40,
              decoration: BoxDecoration(
                  color: LamaColors.greenPrimary,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 25,
                        child: SvgPicture.asset(
                            'assets/images/svg/lama_coin.svg',
                            semanticsLabel: 'LAMA'),
                      ),
                    ),
                    Text(userRepository.getLamaCoins().toString(),
                        style: LamaTextTheme.getStyle(fontSize: 22.5)),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
    return Column(children: children);
  }

  ///Prevents leaving the app with a single press on the back button.
  ///
  ///This method is registered as a callback in the [build()] method.
  ///Then it decides based on the time between to presses, whether the
  ///app will exit or display a message.
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (backButtonPressedTime == null ||
        now.difference(backButtonPressedTime) > Duration(seconds: 1)) {
      backButtonPressedTime = now;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
