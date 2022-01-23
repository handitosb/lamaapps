import 'dart:math';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import '../../../util/LamaColors.dart';
import '../../../util/LamaTextTheme.dart';
import '../../task-system/task.dart';

class NumberLineTaskScreen extends StatefulWidget {
  final TaskNumberLine task;
  final BoxConstraints constraints;
  int testrng;
  NumberLineTaskScreen(this.task, this.constraints);

  @override
  State<StatefulWidget> createState() {
    return NumberLineState(task, constraints);
  }
}

class NumberLineState extends State<NumberLineTaskScreen> {
  final TextEditingController controller = TextEditingController();
  final TaskNumberLine task;
  final BoxConstraints constraints;
  var random = Random();
  int endPixel;
  int rngStart;
  int rngEnd;
  int gesuchteZahl;
  double dgesuchteZahl;
  int gesuchterPixel;
  double dgesuchterPixel;
  bool firstTry = true;
  bool tappedCorrectly = false;
  bool tappedIncorrectly = false;
  TapDownDetails details;
  NumberLineState(this.task, this.constraints) {
    this.endPixel = 370;
    this.rngStart = task.range[0];
    this.rngEnd = task.range[1];
    if (task.randomrange) {
      this.rngStart = random.nextInt(task.range[1] ~/ 2);
      this.rngEnd = random.nextInt(task.range[1] ~/ 2) + task.range[1] ~/ 2;
    }
    if (task.steps > 0) {
      rngStart = ((rngStart.toDouble() / task.steps).round() * task.steps);
      rngEnd = ((rngEnd.toDouble() / task.steps).round() * task.steps);
    }

    this.gesuchteZahl = random.nextInt(rngEnd - rngStart) + rngStart;
    if (task.steps > 0) {
      gesuchteZahl =
          ((gesuchteZahl.toDouble() / task.steps).round() * task.steps);
    }
    while (this.gesuchteZahl == rngStart || this.gesuchteZahl == rngEnd) {
      this.gesuchteZahl = random.nextInt(rngEnd - rngStart) + rngStart;
      if (task.steps > 0) {
        gesuchteZahl =
            ((gesuchteZahl.toDouble() / task.steps).round() * task.steps);
      }
    }
    this.dgesuchteZahl = gesuchteZahl.toDouble();
    this.dgesuchterPixel =
        (endPixel / (rngEnd - rngStart)) * (dgesuchteZahl - rngStart);
    this.firstTry = true;
  }

  @override
  Widget build(BuildContext context) {
    bool paintRed = !task.ontap;
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    if (!task.ontap) {
      return Column(children: [
        SizedBox(height: 20),
        lamaHead(context, task, constraints, task.ontap),
        SizedBox(height: 50),
        numberLine(context, rngStart, rngEnd, endPixel),
        Align(
          alignment: Alignment.topCenter,
        ),
        Padding(
          padding: EdgeInsets.all(2),
          child: Container(
            width: screenwidth - screenwidth / 10,
            height: 30,
            child: CustomPaint(
              foregroundPainter: LinePainter(
                  dgesuchterPixel, endPixel, paintRed, rngStart, rngEnd),
            ),
          ),
        ),
        SizedBox(height: 50),
        keyboard(context, controller, rngEnd),
        SizedBox(height: 50),
        fertigButton(context, constraints, controller, dgesuchteZahl),
      ]);
    } else {
      return Column(children: [
        SizedBox(height: 20),
        lamaHead(context, task, constraints, task.ontap),
        SizedBox(height: 50),
        Text(
          "Gesuchte Zahl: " + gesuchteZahl.toString(),
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Container(
          height: 20,
          width: MediaQuery.of(context).size.width,
          child: numberLine(context, rngStart, rngEnd, endPixel),
        ),
        Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: Container(
                width: screenwidth - screenwidth / 10,
                height: 30,
                child: CustomPaint(
                  foregroundPainter: LinePainter(
                      dgesuchterPixel, endPixel, paintRed, rngStart, rngEnd),
                ),
              ),
            ),
            //icon correct
            Positioned(
              left: dgesuchterPixel + screenwidth / 60,
              child: Container(
                width: 30,
                height: 30,
                child: Icon(Icons.check_circle,
                    size: 30,
                    color: tappedCorrectly
                        ? Colors.green
                        : Colors.white.withOpacity(0)),
              ),
            ),
            //icon incorrect
            Positioned(
              left: dgesuchterPixel + screenwidth / 60,
              child: Container(
                width: 30,
                height: 30,
                child: Icon(Icons.cancel,
                    size: 30,
                    color: tappedIncorrectly
                        ? Colors.red
                        : Colors.white.withOpacity(0)),
              ),
            ),
            //correct area
            Positioned(
              left: dgesuchterPixel,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (firstTry) {
                      tappedCorrectly = !tappedCorrectly;
                      firstTry = false;
                    }
                  });
                },
                child: Container(
                  width: 40,
                  height: 30,
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0)),
                ),
              ),
            ),
            //incorrect area to the left
            Positioned(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (firstTry) {
                      tappedIncorrectly = !tappedIncorrectly;
                      firstTry = false;
                    }
                  });
                },
                child: Container(
                  width: dgesuchterPixel,
                  height: 30,
                  decoration: BoxDecoration(color: Colors.red.withOpacity(0)),
                ),
              ),
            ),
            //incorrect area to the right
            Positioned(
              left: dgesuchterPixel + 40,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (firstTry) {
                      tappedIncorrectly = !tappedIncorrectly;
                      firstTry = false;
                    }
                  });
                },
                child: Container(
                  width: screenwidth,
                  height: 30,
                  decoration: BoxDecoration(color: Colors.red.withOpacity(0)),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 50),
        SizedBox(height: 50),
        fertigButtonTap(context, constraints, controller, tappedCorrectly,
            tappedIncorrectly),
      ]);
    }
  }
}

// original source for LinePainter: https://github.com/JohannesMilke/custom_paint_ii_example/blob/master/lib/page/line_paint_page.dart
class LinePainter extends CustomPainter {
  double dgesuchterPixel;
  int endPixel;
  bool paintRed;
  int rngStart;
  int rngEnd;
  int diff;
  LinePainter(dgesuchterPixel, endPixel, paintRed, rngStart, rngEnd) {
    this.dgesuchterPixel = dgesuchterPixel;
    this.endPixel = endPixel;
    this.paintRed = paintRed;
    this.rngStart = rngStart;
    this.rngEnd = rngEnd;
    diff = rngEnd - rngStart;
  }
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;
    final paint2 = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;
    ;
    //Hauptteil des Zahlenstrahls
    canvas.drawLine(
      Offset(endPixel.toDouble() * 0, size.height * 0.5),
      Offset(endPixel.toDouble() * 1, size.height * 0.5),
      paint,
    );
    /*Teil Pfeilspitze nach oben
    canvas.drawLine(
      Offset(size.width * 0.95, size.height * 0),
      Offset(size.width * 1, size.height * 0.5),
      paint,
    );
    //Teil der Pfeilspitze nach unten
    canvas.drawLine(
      Offset(size.width * 0.95, size.height * 1),
      Offset(size.width * 1, size.height * 0.5),
      paint,
    );*/
    //Unterteilung des Zahlenstrahls
    if (diff <= 100 && diff % 10 == 0) {
      for (int i = 0; i <= diff / 10; i++) {
        if (i == 0 || i == diff || diff % 2 == 0 && i == diff / 10 / 2) {
          canvas.drawLine(
            Offset(endPixel * i / (diff / 10), size.height * 0.1),
            Offset(endPixel * i / (diff / 10), size.height * 0.9),
            paint,
          );
        }
        canvas.drawLine(
          Offset(endPixel * i / (diff / 10), size.height * 0.2),
          Offset(endPixel * i / (diff / 10), size.height * 0.8),
          paint,
        );
      }
    } else if (diff <= 100 && diff % 5 == 0) {
      for (int i = 0; i <= diff / 5; i++) {
        if (i == 0 || i == diff || diff % 2 == 0 && i == diff / 5 / 2) {
          canvas.drawLine(
            Offset(endPixel * i / (diff / 5), size.height * 0.1),
            Offset(endPixel * i / (diff / 5), size.height * 0.9),
            paint,
          );
        }

        canvas.drawLine(
          Offset(endPixel * i / (diff / 5), size.height * 0.2),
          Offset(endPixel * i / (diff / 5), size.height * 0.8),
          paint,
        );
      }
    } else {
      for (int i = 0; i <= 10; i++) {
        if (i == 0 || i == 10 || i == 5) {
          canvas.drawLine(
            Offset(endPixel * i / 10, size.height * 0.1),
            Offset(endPixel * i / 10, size.height * 0.9),
            paint,
          );
        } else {
          canvas.drawLine(
            Offset(endPixel * i / 10, size.height * 0.2),
            Offset(endPixel * i / 10, size.height * 0.8),
            paint,
          );
        }
      }
    }
    if (paintRed) {
      canvas.drawLine(
        Offset(this.dgesuchterPixel, size.height * 0.1),
        Offset(this.dgesuchterPixel, size.height * 0.9),
        paint2,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

Widget buildText(BuildContext context, int rng, double pixel) {
  return Positioned(
    left: pixel,
    child: Container(
      child: Text(
        rng.toString(),
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Widget lamaHead(
    BuildContext context, Task task, BoxConstraints constraints, bool onTap) {
  return Container(
    height: (constraints.maxHeight / 100) * 15,
    padding: EdgeInsets.only(left: 15, right: 15),
    child: Stack(children: [
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
                onTap
                    ? "Wo befindet sich der unten angegebene Wert auf dem Zahlenstrahl?"
                    : "Gib den im Zahlenstrahl rot markierten Wert an!",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
      ),
    ]),
  );
}

Widget numberLine(
    BuildContext context, int rngStart, int rngEnd, int endPixel) {
  return Container(
    height: 20,
    width: MediaQuery.of(context).size.width,
    child: Stack(
      children: [
        buildText(context, rngStart, 20),
        buildText(context, rngEnd, endPixel.toDouble() + 12),
        //  buildText(context, rngPixelAsValue, dresultPixel + 12),
      ],
    ),
  );
}

Widget keyboard(
    BuildContext context, TextEditingController controller, int rngEnd) {
  return Container(
    width: 100,
    height: 50,
    child: TextField(
      controller: controller,
      maxLength: rngEnd.toString().length,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 30),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
        counterText: "",
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 1),
        ),
      ),
    ),
  );
}

Widget fertigButton(BuildContext context, BoxConstraints constraints,
    TextEditingController controller, double dgesuchteZahl) {
  return Container(
    height: (constraints.maxHeight / 100) * 25,
    child: Center(
      child: InkWell(
          child: Container(
            height: (constraints.maxHeight / 100) * 15,
            width: (constraints.maxWidth / 100) * 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
              color: LamaColors.greenAccent,
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 2),
                    color: LamaColors.black.withOpacity(0.5))
              ],
            ),
            child: Center(
              child: Text(
                "Fertig!",
                style: LamaTextTheme.getStyle(
                  fontSize: 30,
                ),
              ),
            ),
          ),
          onTap: () {
            bool noInput = true;
            if (double.tryParse(controller.text) != null) {
              noInput = false;
            }
            if (noInput) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: Duration(seconds: 2),
                content: Container(
                    height: (constraints.maxHeight / 100) * 6,
                    alignment: Alignment.bottomCenter,
                    child: Center(
                        child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        "Gib eine Zahl ein!",
                        style: LamaTextTheme.getStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ))),
                backgroundColor: LamaColors.mainPink,
              ));
            } else {
              bool answer = double.parse(controller.text) == dgesuchteZahl;
              BlocProvider.of<TaskBloc>(context)
                  .add(AnswerTaskEvent.initNumberLine(answer));
            }
          }),
    ),
  );
}

Widget fertigButtonTap(
    BuildContext context,
    BoxConstraints constraints,
    TextEditingController controller,
    bool tappedCorrectly,
    bool tappedIncorrectly) {
  return Container(
    height: (constraints.maxHeight / 100) * 25,
    child: Center(
      child: InkWell(
          child: Container(
            height: (constraints.maxHeight / 100) * 15,
            width: (constraints.maxWidth / 100) * 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
              color: LamaColors.greenAccent,
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 2),
                    color: LamaColors.black.withOpacity(0.5))
              ],
            ),
            child: Center(
              child: Text(
                "Fertig!",
                style: LamaTextTheme.getStyle(
                  fontSize: 30,
                ),
              ),
            ),
          ),
          onTap: () {
            if (!tappedCorrectly && !tappedIncorrectly) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: Duration(seconds: 2),
                content: Container(
                    height: (constraints.maxHeight / 100) * 6,
                    alignment: Alignment.bottomCenter,
                    child: Center(
                        child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        "Tippe auf den Zahlenstrahl!",
                        style: LamaTextTheme.getStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ))),
                backgroundColor: LamaColors.mainPink,
              ));
            } else {
              BlocProvider.of<TaskBloc>(context)
                  .add(AnswerTaskEvent.initNumberLine(tappedCorrectly));
            }
          }),
    ),
  );
}
