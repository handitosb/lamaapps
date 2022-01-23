import 'dart:math';
import 'dart:ui';

import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

/// Author: H.Bismo

bool firstStart = true;
bool firstShuffel = true;

class MatchRandomTaskScreen extends StatefulWidget {
  final TaskMatchRandom task;
  final BoxConstraints constraints;
  MatchRandomTaskScreen(this.task, this.constraints);

  @override
  State<StatefulWidget> createState() {
    return MatchRandomState(task, constraints);
  }
}

class MatchRandomState extends State<MatchRandomTaskScreen> {
  final BoxConstraints constraints;
  final TaskMatchRandom task;
  
  final List<String> categorySum = [];
  
  final List<bool> results = [];
  
  String latestDeletion = "";
  
  //List<Item> deletinons = [];

  //List<Item> items = [];

  MatchRandomState(this.task, this.constraints);

  // @override
  // void initState() {
  //   super.initState();
  //   categorySum.clear();
  //   categorySum.addAll(task.ansLeft);
  //   categorySum.addAll(task.ansMiddle);
  //   categorySum.addAll(task.ansRight);
  //   // If its the first screen Build we need to Shuffle the list
  //   categorySum.shuffle();
  //   //items.clear();
  //   firstStart = true;
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Lama Speechbubble
        Container(
          height: (constraints.maxHeight / 100) * 15,
          padding: EdgeInsets.only(left: 15, right: 15, top: 15),
          // create space between each childs
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 75),
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Bubble(
                    nip: BubbleNip.leftCenter,
                    child: Center(
                      child: Text(
                        task.lamaText,
                        style: LamaTextTheme.getStyle(
                            color: LamaColors.black, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SvgPicture.asset(
                  "assets/images/svg/lama_head.svg",
                  semanticsLabel: "Lama Anna",
                  width: 75,
                ),
              )
            ],
          ),
        ),
        //Items
        Padding(
            padding: EdgeInsets.all(5),
            child: Container(
                height: (constraints.maxHeight / 100) * 60,
                //color: LamaColors.greenAccent,
                child: Container(
                width: 300,
                height: 300,
                child: CustomPaint(
                  painter: ClockPainter()
      ),)),
        //Box Categories
        // Container(
        //   height: (constraints.maxHeight / 100) * 12,
        //   alignment: Alignment.center,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     children: [
        //       buildTargets(context, task.ansLeft, task.boxLeft,
        //           LamaColors.orangeAccent),
        //       buildTargets(context, task.ansMiddle, task.boxMiddle,
        //           LamaColors.redAccent),
        //       buildTargets(context, task.ansRight, task.boxRight,
        //           LamaColors.blueAccent)
        //     ],
        //   ),
        // ),
        // Button
      //   Container(
      //       height: (constraints.maxHeight / 100) * 10,
      //       alignment: Alignment.bottomCenter,
      //       child: Material(
      //         color: Colors.transparent,
      //         child: Ink(
      //           decoration: ShapeDecoration(
      //               color: LamaColors.blueAccent,
      //               shape: CircleBorder(),
      //               shadows: [
      //                 BoxShadow(
      //                     color: Colors.grey.withOpacity(0.5),
      //                     spreadRadius: 2,
      //                     blurRadius: 7,
      //                     offset: Offset(0, 3)),
      //               ]),
      //           padding: EdgeInsets.all(5.0),
      //           child: IconButton(
      //             padding: EdgeInsets.all(1.0),
      //             icon: Icon(
      //               Icons.refresh,
      //               size: 40,
      //             ),
      //             color: LamaColors.black,
      //             onPressed: () {
      //               setState(() {
      //                 if (deletinons.isNotEmpty) {
      //                   results.removeLast();
      //                   items.add(deletinons.last);
      //                   deletinons.removeLast();
      //                 } else if (deletinons.isEmpty) {
      //                   ScaffoldMessenger.of(context).showSnackBar(
      //                     SnackBar(
      //                       content: Container(
      //                           height: (constraints.maxHeight / 100) * 4,
      //                           alignment: Alignment.bottomCenter,
      //                           child: Center(
      //                               child: FittedBox(
      //                             fit: BoxFit.fitWidth,
      //                             child: Text(
      //                               "Kein Item zum zurücksetzen gefunden",
      //                               style: LamaTextTheme.getStyle(),
      //                               textAlign: TextAlign.center,
      //                             ),
      //                           ))),
      //                       backgroundColor: LamaColors.mainPink,
      //                     ),
      //                   );
      //                 }
      //               });
      //             },
      //           ),
      //         ),
      //       ))
        )],
    );
  }

  
  /// {@return} a List of [Widget]
  // List<Widget> generateItems() {
  //   if (firstStart) {
  //     firstStart = false;
  //     double x = 200;
  //     double y = 140;
  //     int length;

  //     if (categorySum.length <= 6) {
  //       length = categorySum.length;
  //     } else {
  //       length = 6;
  //     }

  //     for (int i = 0; i < length; i++) {
  //       items.add(Item(x, y, categorySum[i]));
  //     }
  //   }
  //   // List to save the created Widgets
  //   List<Widget> output = [];
  //   // Create for every Item a widget
  //   for (int i = 0; i < items.length; i++) {
  //     output.add(
  //       Positioned(
  //           bottom: items[i].bottom,
  //           left: items[i].left,
  //           child: Draggable<Item>(
  //             data: items[i],
  //             child: Container(
  //                 height: (constraints.maxHeight / 100) * 10,
  //                 width: (constraints.maxWidth / 100) * 30,
  //                 decoration: BoxDecoration(
  //                     color: Colors.green[600],
  //                     borderRadius: BorderRadius.all(Radius.circular(10)),
  //                     boxShadow: [
  //                       BoxShadow(
  //                           color: Colors.grey.withOpacity(0.5),
  //                           spreadRadius: 1,
  //                           blurRadius: 7,
  //                           offset: Offset(0, 3)),
  //                     ]),
  //                 child: Center(
  //                   child: Text(items[i].item,  style: LamaTextTheme.getStyle(color: LamaColors.black)),
  //                 )),
  //             feedback: Material(
  //                 child: Container(
  //                     height: (constraints.maxHeight / 100) * 10,
  //                     width: (constraints.maxWidth / 100) * 30,
  //                     decoration: BoxDecoration(
  //                         color: LamaColors.mainPink,
  //                         borderRadius: BorderRadius.all(Radius.circular(10)),
  //                         boxShadow: [
  //                           BoxShadow(
  //                               color: Colors.grey.withOpacity(0.5),
  //                               spreadRadius: 1,
  //                               blurRadius: 7,
  //                               offset: Offset(0, 3)),
  //                         ]),
  //                     child: Center(
  //                       child: Text(items[i].item,
  //                           style: LamaTextTheme.getStyle()),
  //                     ))),
  //             childWhenDragging: Container(
  //                 height: (constraints.maxHeight / 100) * 10,
  //                 width: (constraints.maxWidth / 100) * 30,
  //                 decoration: BoxDecoration(
  //                     color: Colors.grey,
  //                     borderRadius: BorderRadius.all(Radius.circular(10)),
  //                     boxShadow: [
  //                       BoxShadow(
  //                           color: Colors.grey.withOpacity(0.5),
  //                           spreadRadius: 1,
  //                           blurRadius: 7,
  //                           offset: Offset(0, 3)),
  //                     ]),
  //                 child: Center(
  //                   child: Text(items[i].item, style: LamaTextTheme.getStyle()),
  //                 )),
  //           )),
  //     );
  //   }
  //   return output;
  // }

  /// buildTargets is Used to create the dragtargets for the Items
  /// The method gets called for both Dragtargets.
  /// {@param} BuildContext [context] needed for constraints
  /// {@param} List<String> [categoryList] List of all Items accepted by this Target
  /// {@param} String [taskCategory] name of the Target
  /// {@param} Color [color] color of the Target
  ///
  /// {@return} [Widget] Targetwidget to be displayed on the screen
//   Widget buildTargets(BuildContext context, List<String> categoryList,
//       String taskCategory, Color color) {
//     return DragTarget<Item>(
//       builder: (context, candidate, rejectedData) => Container(
//           height: (constraints.maxHeight / 100) * 30,
//           width: (constraints.maxWidth / 100) * 30,
//           decoration: BoxDecoration(
//             color: color,
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   spreadRadius: 1,
//                   blurRadius: 7,
//                   offset: Offset(0, 3)),
//             ],
//             borderRadius: BorderRadius.all(Radius.circular(5)),
//           ),
//           child: Padding(
//               padding: EdgeInsets.all(10),
//               child: FittedBox(
//                 fit: BoxFit.fitWidth,
//                 child: Center(
//                   child: Text(
//                     taskCategory,
//                     style: LamaTextTheme.getStyle(
//                       color: LamaColors.white,
//                       fontSize: 30,
//                     ),
//                   ),
//                 ),
//               ))),
//       onWillAccept: (data) => true,
//       onAccept: (data) {
//         // Check if draged Item is contained in the Items for this Category
//         categoryList.contains(data.item)
//             ? results.add(true)
//             : results.add(false);
//         // reload screen
//         setState(() {
//           // After Draging the Item needs to be removed from the Screen
//           deletinons.add(data);
//           items.removeWhere((element) {
//             return element.item == data.item;
//           });
//           // If the draged Item was the Last one on the Screen
//           // reset all Variables and send the resluts to check
//           if (items.isEmpty) {
//             firstStart = true;
//             BlocProvider.of<TaskBloc>(context)
//                 .add(AnswerTaskEvent.initMatchCategory(results));
//           }
//         });
//       },
//     );
//   }
}

/// class Item used to store information of every given word
/// double [bottom] Used for positioning
/// double [left] Used for positioning
/// String [item] Stores item text given by TaskMatchCategory [task]
// class Item {
//   double bottom;
//   double left;
//   String item;
//   Item(double bottom, left, String item) {
//     this.bottom = bottom;
//     this.left = left;
//     this.item = item;
//   }
// }

class ClockPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    var X = size.width /2;
    var Y = size.width /2;
    var center = Offset(X,Y);
    var rad = min(X, Y);

    var clockDraw = Paint()
    ..color = LamaColors.white;

    var clockOutline = Paint()
    ..color = Colors.black26
    ..strokeWidth = 16
    ..style = PaintingStyle.stroke;

    var clockCenter = Paint()..color = Color(0xFFEAECFF);

    var minClock = Paint()
    ..shader = RadialGradient(colors: [Colors.lightBlue, Colors.blueAccent[700]]).createShader(Rect.fromCircle(center: center, radius: rad))
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 10;

    var hourClock = Paint()
    ..shader = RadialGradient(colors: [Color(0xFFEA74AB), Color(0xFFC279FB)]).createShader(Rect.fromCircle(center: center, radius: rad))
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 16;

    canvas.drawCircle(center, rad - 40, clockDraw);
    canvas.drawCircle(center, rad - 40, clockOutline);
    var hourClockX = X + 60 * cos(270 * pi / 180);
    var hourClockY = Y + 60 * sin(270 * pi / 180);

    var minClockX = X + 80 * cos(270* pi / 180);
    var minClockY = Y + 80 * sin(270* pi / 180);
    canvas.drawLine(center, Offset(minClockX,minClockY), minClock);
    canvas.drawLine(center, Offset(hourClockX,hourClockY), hourClock);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }}