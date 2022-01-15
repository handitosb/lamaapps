import 'dart:async';
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

class ClockTaskScreen extends StatefulWidget {
  final ClockTest task;
  final BoxConstraints constraints;
  ClockTaskScreen(this.task, this.constraints);

  @override
  State<StatefulWidget> createState() {
    return ClockTaskState(task, constraints);
  }
}

class ClockTaskState extends State<ClockTaskScreen> {
  final BoxConstraints constraints;
  final ClockTest task;
  ClockPainter bloc;
  final List<String> answers = [];
  int i = 1;
  int timer = 15;
  String showtimer;
  String sonneMond;
  var randStunde;
  var randMinute;
  var rnd = Random();
  var wrgStunde;
  var wrgMinute;
  var wrgStunde2;
  var wrgMinute2;
  var vierMinute;
  List<String> wrongAnswer;

  String setImage() {
    if (this.randStunde < 5|| this.randStunde > 17) {
      if (this.randStunde == 18 || this.randStunde == 19){
      return  sonneMond = "assets/images/png/sunset.png";
      }else {
      return sonneMond = "assets/images/png/moon.png";
      }
    }
    else {
      if (this.randStunde == 5 || this.randStunde == 6){
       return sonneMond = "assets/images/png/sunrise.png";
      } else{
       return sonneMond = "assets/images/png/sun.png";
        }
    }
  }

  ClockTaskState(this.task, this.constraints) {
    this.wrgStunde2 = rnd.nextInt(24);
    this.wrgMinute2 = rnd.nextInt(2) * 30;
    this.wrgStunde = rnd.nextInt(24);
    this.wrgMinute = rnd.nextInt(2) * 30;
    this.randStunde = rnd.nextInt(24);
    this.randMinute = rnd.nextInt(2) * 30;
    this.vierMinute = rnd.nextInt(4) * 15;

    bloc = ClockPainter(
        task, constraints, this.randStunde, this.randMinute, this.vierMinute);
    task.rightAnswer = bloc.strAnswer();
    answers.add(task.rightAnswer); //get the right answer
    answers.add(wrgAnswer());
    answers.add(wrgAnswer2()); // add the wrong answers
    answers.shuffle();
    print(answers);
  }

  @override
  void initState() {
    if (task.timer == true) {
      showtimer = "15";
      startTimer();
      super.initState();
    } else {
      showtimer = "";
      super.initState();
    }

    super.initState();
  }

  void startTimer() async {
    const sek = Duration(seconds: 1);
    Timer.periodic(sek, (Timer t) {
      setState(() {
        if (timer < 1) {
          t.cancel();
        } else {
          timer = timer - 1;
        }
        showtimer = timer.toString();
      });
    });
  }

  // ignore: missing_return
  String wrgAnswer() {
    if (this.wrgStunde != this.randStunde ||
        this.wrgMinute != this.randMinute) {
      if (task.uhr == "vollStunde") {
        if (this.wrgStunde < 10) {
          return "0" + this.wrgStunde.toString() + ":" + "00";
        } else {
          return this.wrgStunde.toString() + ":" + "00";
        }
      } else if(task.uhr == "halbeStunde") {
        if (this.wrgMinute == 0) {
          if (this.wrgStunde < 10) {
            return "0" + this.wrgStunde.toString() + ":" + "00";
          } else if (this.wrgStunde >= 10) {
            return this.wrgStunde.toString() + ":" + "00";
          }
          } else {
              if (this.wrgStunde < 10) {
                return "0" +
                    this.wrgStunde.toString() +
                    ":" +
                      this.wrgMinute.toString();
              } else if (this.wrgStunde >= 10) {
                  return this.wrgStunde.toString() +
                    ":" +
                    this.wrgMinute.toString();
          }
        }
      } else if(task.uhr == "viertelStunde") {
        if (this.wrgMinute == 0) {
          if (this.wrgStunde < 10) {
            return "0" + this.wrgStunde.toString() + ":" + "00";
          } else {
            return this.wrgStunde.toString() + ":" + "00";
          }
        } else {
          if (this.wrgStunde < 10) {
            return "0" +
                this.wrgStunde.toString() +
                ":" +
                this.wrgMinute.toString();
          } else {
            return this.wrgStunde.toString() +
                ":" +
                this.wrgMinute.toString();
          }
        }
      }
    } else {
      return this.wrgStunde.toString() +
                ":" +
                this.wrgMinute.toString();
    }
  }

  // ignore: missing_return
  String wrgAnswer2() {
    if (this.wrgStunde2 != this.randStunde ||
        this.wrgMinute2 != this.randMinute) {
      if (task.uhr == "vollStunde") {
        if (this.wrgStunde2 < 10) {
          return "0" + this.wrgStunde2.toString() + ":" + "00";
        } else {
          return this.wrgStunde2.toString() + ":" + "00";
        }
      } else if(task.uhr == "halbeStunde") {
        if (this.wrgMinute2 == 0) {
          if (this.wrgStunde2 < 10) {
            return "0" + this.wrgStunde2.toString() + ":" + "00";
          } else if (this.wrgStunde2 >= 10) {
            return this.wrgStunde2.toString() + ":" + "00";
          }
        } else {
          if (this.wrgStunde2 < 10) {
            return "0" +
                this.wrgStunde2.toString() +
                ":" +
                this.wrgMinute2.toString();
          } else {
            return this.wrgStunde2.toString() +
                ":" +
                this.wrgMinute2.toString();
          }
        }
      } else if(task.uhr == "viertelStunde") {
        if (this.wrgMinute2 == 0) {
          if (this.wrgStunde2 < 10) {
            return "0" + this.wrgStunde2.toString() + ":" + "00";
          } else if (this.wrgStunde2 >= 10) {
            return this.wrgStunde2.toString() + ":" + "00";
          }
        } else {
          if (this.wrgStunde2 < 10) {
            return "0" +
                this.wrgStunde2.toString() +
                ":" +
                this.wrgMinute2.toString();
          } else {
            return this.wrgStunde2.toString() +
                ":" +
                this.wrgMinute2.toString();
          }
        }
      }
    } else {
      return this.wrgStunde.toString() +
                ":" +
                this.wrgMinute.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
            ),
            Align(
                alignment: Alignment(1.0, 5.0),
                child: Container(
                    padding: EdgeInsets.only(left: 100, top: 15),
                    child: Image.asset(
                      setImage(),
                      width: 30,
                      height: 30,
                    ))),
          ],
        ),
      ),
      //Items
      Padding(
        padding: EdgeInsets.all(5),
        child: Container(
            height: (constraints.maxHeight / 100) * 45,
            child: Container(
              width: 270,
              height: 270,
              child: CustomPaint(
                  painter: ClockPainter(
                      task, constraints, randStunde, randMinute, vierMinute)),
            )),
      ),
      Container(
        height: (constraints.maxHeight / 100) * 35,
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                child: Align(
              alignment: Alignment.bottomLeft,
              child: Center(
                child: Text(
                  showtimer,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )),
            Container(
              height: 55,
              width: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: LamaColors.greenAccent,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3)),
                  ]),
              child: InkWell(
                onTap: () => BlocProvider.of<TaskBloc>(context)
                    .add(AnswerTaskEvent(answers[0])),
                child: Center(
                  child: Text(
                    answers[0],
                    style: LamaTextTheme.getStyle(
                      color: LamaColors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 55,
              width: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: LamaColors.blueAccent,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3))
                  ]),
              child: InkWell(
                onTap: () => BlocProvider.of<TaskBloc>(context)
                    .add(AnswerTaskEvent(answers[1])),
                child: Center(
                  child: Text(
                    answers[1],
                    style: LamaTextTheme.getStyle(
                      color: LamaColors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 55,
              width: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: LamaColors.greenAccent,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3))
                  ]),
              child: InkWell(
                onTap: () => BlocProvider.of<TaskBloc>(context)
                    .add(AnswerTaskEvent(answers[2])),
                child: Center(
                  child: Text(
                    answers[2],
                    style: LamaTextTheme.getStyle(
                      color: LamaColors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    ]);
  }
}

class ClockPainter extends CustomPainter {
  final ClockTest task;
  var wrgStunde;
  var wrgMinute;
  var rnd = Random();
  var randStunde;
  var randMinute;
  var vierMinute;
  final BoxConstraints constraints;

  ClockPainter(
      this.task, this.constraints, randStunde, randMinute, vierMinute) {
    this.randStunde = randStunde;
    this.randMinute = randMinute;
    this.vierMinute = vierMinute;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

  String strAnswer() {
    if (task.uhr == "halbeStunde") {
      if (this.randMinute == 0) {
        if (this.randStunde < 10) {
          return "0" + this.randStunde.toString() + ":" + "00";
        } else {
          return this.randStunde.toString() + ":" + "00";
        }
      } else {
        if (this.randStunde < 10) {
          return "0" +
              this.randStunde.toString() +
              ":" +
              this.randMinute.toString();
        }
        return this.randStunde.toString() + ":" + this.randMinute.toString();
      }
    } else if (task.uhr == "vollStunde") {
      if (this.randStunde < 10) {
        return "0" + this.randStunde.toString() + ":" + "00";
      } else {
        return this.randStunde.toString() + ":" + "00";
      }
    } else if (task.uhr == "viertelStunde") {
      if (this.vierMinute == 0) {
        if (this.randStunde < 10) {
          return "0" + this.randStunde.toString() + ":" + "00";
        } else {
          return this.randStunde.toString() + ":" + "00";
        }
      } else {
        if (this.randStunde < 10) {
          return "0" +
              this.randStunde.toString() +
              ":" +
              this.vierMinute.toString();
        }
        return this.randStunde.toString() + ":" + this.vierMinute.toString();
      }
    } return this.randStunde.toString() + ":" + this.vierMinute.toString();
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    var X = size.width / 2;
    var Y = size.width / 2;
    var center = Offset(X, Y);
    var rad = min(X, Y);

    var clockDraw = Paint()..color = LamaColors.white;

    var clockOutline = Paint()
      ..color = Colors.black26
      ..strokeWidth = 16
      ..style = PaintingStyle.stroke;

    var clockCenter = Paint()..color = Color(0xFFEAECFF);

    var minClock = Paint()
      ..shader =
          RadialGradient(colors: [Colors.lightBlue, Colors.blueAccent[700]])
              .createShader(Rect.fromCircle(center: center, radius: rad))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;

    var hourClock = Paint()
      ..shader = RadialGradient(colors: [Color(0xFFEA74AB), Color(0xFFC279FB)])
          .createShader(Rect.fromCircle(center: center, radius: rad))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 16;

    var dashNum = Paint()
      ..color = Colors.black
      ..strokeWidth = 5;

    var dashMin = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    canvas.drawCircle(center, rad - 40, clockDraw);
    canvas.drawCircle(center, rad - 40, clockOutline);

    if (task.uhr == "vollStunde") {
      for (int i = 0; i < 24; i++) {
        if (i == randStunde) {
          var minClockX = X + 80 * cos(270 * pi / 180);
          var minClockY = Y + 80 * sin(270 * pi / 180);
          var hourClockX = X + 60 * cos((i * 30 + 270) * pi / 180);
          var hourClockY = Y + 60 * sin((i * 30 + 270) * pi / 180);
          canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
          canvas.drawLine(center, Offset(hourClockX, hourClockY), hourClock);
          print(randStunde.toString() + ":" + randMinute.toString());
        }
      }
    } else if (task.uhr == "halbeStunde") {
      for (int i = 0; i < 24; i++) {
        if (randMinute == 30) {
          if (i == randStunde) {
            var minClockX = X + 80 * cos(90 * pi / 180);
            var minClockY = Y + 80 * sin(90 * pi / 180);
            var hourClockX = X + 60 * cos((i * 30 + 285) * pi / 180);
            var hourClockY = Y + 60 * sin((i * 30 + 285) * pi / 180);
            canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
            canvas.drawLine(center, Offset(hourClockX, hourClockY), hourClock);
            print(randStunde.toString() + ":" + randMinute.toString());
          }
        } else if (randMinute == 0) {
          for (int i = 0; i < 24; i++) {
            if (i == randStunde) {
              var minClockX = X + 80 * cos(270 * pi / 180);
              var minClockY = Y + 80 * sin(270 * pi / 180);
              var hourClockX = X + 60 * cos((i * 30 + 270) * pi / 180);
              var hourClockY = Y + 60 * sin((i * 30 + 270) * pi / 180);
              canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
              canvas.drawLine(
                  center, Offset(hourClockX, hourClockY), hourClock);
              print(randStunde.toString() + ":" + randMinute.toString());
            }
          }
        }
      }
    } else if (task.uhr == "viertelStunde") {
      for (int i = 0; i < 24; i++) {
        if (vierMinute == 30) {
          if (i == randStunde) {
            var minClockX = X + 80 * cos(90 * pi / 180);
            var minClockY = Y + 80 * sin(90 * pi / 180);
            var hourClockX = X + 60 * cos((i * 30 + 285) * pi / 180);
            var hourClockY = Y + 60 * sin((i * 30 + 285) * pi / 180);
            canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
            canvas.drawLine(center, Offset(hourClockX, hourClockY), hourClock);
            print(randStunde.toString() + ":" + randMinute.toString());
          }
        } else if (vierMinute == 15) {
          for (int i = 0; i < 24; i++) {
            if (i == randStunde) {
              var minClockX = X + 80 * cos(360 * pi / 180);
              var minClockY = Y + 80 * sin(360 * pi / 180);
              var hourClockX = X + 60 * cos((i * 30 + 278) * pi / 180);
              var hourClockY = Y + 60 * sin((i * 30 + 278) * pi / 180);
              canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
              canvas.drawLine(
                  center, Offset(hourClockX, hourClockY), hourClock);
              print(randStunde.toString() + ":" + randMinute.toString());
            }
          }
        } else if (vierMinute == 45) {
          for (int i = 0; i < 24; i++) {
            if (i == randStunde) {
              var minClockX = X + 80 * cos(180 * pi / 180);
              var minClockY = Y + 80 * sin(180 * pi / 180);
              var hourClockX = X + 60 * cos((i * 30 + 293) * pi / 180);
              var hourClockY = Y + 60 * sin((i * 30 + 293) * pi / 180);
              canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
              canvas.drawLine(
                  center, Offset(hourClockX, hourClockY), hourClock);
              print(randStunde.toString() + ":" + randMinute.toString());
            }
          }
        } else if (vierMinute == 0) {
          for (int i = 0; i < 24; i++) {
            if (i == randStunde) {
              var minClockX = X + 80 * cos(270 * pi / 180);
              var minClockY = Y + 80 * sin(270 * pi / 180);
              var hourClockX = X + 60 * cos((i * 30 + 270) * pi / 180);
              var hourClockY = Y + 60 * sin((i * 30 + 270) * pi / 180);
              canvas.drawLine(center, Offset(minClockX, minClockY), minClock);
              canvas.drawLine(
                  center, Offset(hourClockX, hourClockY), hourClock);
              print(randStunde.toString() + ":" + randMinute.toString());
            }
          }
        }
      }
    }
    canvas.drawCircle(center, 16, clockCenter);

    var outerClock = rad;
    var innerClock = rad - 20;

    var outerMinute = rad;
    var innerMinute = rad - 14;

    for (double i = 0; i < 360; i += 30) {
      for (double i = 0; i < 360; i += 6) {
        var x1 = X - outerMinute * cos(i * pi / 180);
        var y1 = X - outerMinute * sin(i * pi / 180);

        var x2 = X - innerMinute * cos(i * pi / 180);
        var y2 = X - innerMinute * sin(i * pi / 180);
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashMin);
      }
      var x1 = X - outerClock * cos(i * pi / 180);
      var y1 = X - outerClock * sin(i * pi / 180);

      var x2 = X - innerClock * cos(i * pi / 180);
      var y2 = X - innerClock * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashNum);
    }
  }
}