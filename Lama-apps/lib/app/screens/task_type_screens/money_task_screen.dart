import 'dart:ffi';

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
import 'package:collection/collection.dart';
import 'dart:math';
import 'package:decimal/decimal.dart';

/// This file creates the Money task Screen
/// The Money Task is used to learn the calculating with money.
/// Euro Coins (2€, 1€, 0.5€, 0.2€, 0.1€, 5cent, 2cent, 1cent) will be displayed
/// on the Screen. By touching the coin the the Value of the coin will be stored.
/// The goal is to gather the asked amount of money by tapping on the right coins.
///
/// Author: T.Rentsch
/// latest Changes: 22.07.2021

/// Globale Variables
// currentAmountDouble is used to Store the gathered amount of money


class MoneyTaskScreen extends StatefulWidget {
  final TaskMoney task;
  final BoxConstraints constraints;

  MoneyTaskScreen(this.task, this.constraints);

  @override
  State<StatefulWidget> createState() {
    return MoneyTaskState(task, constraints);
  }
}

/// MoneyTaskState class creates the Money Task Screen
class MoneyTaskState extends State<MoneyTaskScreen> {
  // task infos and constraints handed over by tasktypeScreen
  final TaskMoney task;
  final BoxConstraints constraints;
  // Value which is checked after pressing the "fertig" Button
  double finalMoneyAmount;
  // Stores the pressed coins
  // needed for the undo button
  List<double> deletions = [];
double currentAmountDouble = 0;
  //index maps to coins => 2€ = 0 1 € = 1, usw..
  List<int> amounts = [0, 0, 0, 0, 0, 0, 0, 0];
  int i = 0;
  bool answer;
  var random = Random();
  var rnd;
  String moneyAmount;
  int maxAmount;
  String moneyAmountText;
  int minCount = 0;
  double tempAmount = 0;
  int decimals = 3;

  MoneyTaskState(this.task, this.constraints) {
    finalMoneyAmount = currentAmountDouble;
    rnd = random.nextDouble().toStringAsPrecision(3);
    print(rnd);
    this.maxAmount = 10;
    // this.moneyAmount = random.nextInt(1000).toDouble();
    // this.moneyAmount /= 100;
    this.moneyAmount = rnd;
    print(rnd);
    this.moneyAmount = (double.parse(this.moneyAmount) * this.maxAmount).toString();
    print(this.moneyAmount);
    
    while(Decimal.parse(this.tempAmount.toString()) != Decimal.parse(this.moneyAmount)){
      if((Decimal.parse(this.moneyAmount) - Decimal.parse(this.tempAmount.toString())) >= Decimal.parse('2.00')){
         this.tempAmount =  double.parse(this.tempAmount.toStringAsPrecision(3)) + 2.00; minCount += 1; print(2); print (this.tempAmount); print(minCount);
      }else if ((Decimal.parse(this.moneyAmount) - Decimal.parse(this.tempAmount.toString())) >= Decimal.parse('1.00')){
         this.tempAmount =  double.parse(this.tempAmount.toStringAsPrecision(3)) + 1.00; minCount += 1; print(1); print (this.tempAmount); print(minCount);
      }else if ((Decimal.parse(this.moneyAmount) - Decimal.parse(this.tempAmount.toString())) >= Decimal.parse('0.50')){
        this.tempAmount =  double.parse(this.tempAmount.toStringAsPrecision(3)) + 0.50; minCount += 1;print(0.5); print (this.tempAmount); print(minCount);
      }else if ((Decimal.parse(this.moneyAmount) - Decimal.parse(this.tempAmount.toString())) >= Decimal.parse('0.20')){
        this.tempAmount =  double.parse(this.tempAmount.toStringAsPrecision(3)) + 0.20; minCount += 1; print (this.tempAmount); print(minCount);
      }else if ((Decimal.parse(this.moneyAmount) - Decimal.parse(this.tempAmount.toString())) >= Decimal.parse('0.10')){
        this.tempAmount =  double.parse(this.tempAmount.toStringAsPrecision(3)) + 0.10; minCount += 1; print (this.tempAmount); print(minCount);
      }else if ((Decimal.parse(this.moneyAmount) - Decimal.parse(this.tempAmount.toString())) >= Decimal.parse('0.05')){
        this.tempAmount =  double.parse(this.tempAmount.toStringAsPrecision(3)) + 0.05; minCount += 1; print (this.tempAmount); print(minCount);
      }else if ((Decimal.parse(this.moneyAmount) - Decimal.parse(this.tempAmount.toString())) >= Decimal.parse('0.02')){
        this.tempAmount =  double.parse(this.tempAmount.toStringAsPrecision(3)) + 0.02; minCount += 1; print (this.tempAmount); print(minCount);
      }else if ((Decimal.parse(this.moneyAmount) - Decimal.parse(this.tempAmount.toString())) >= Decimal.parse('0.01')){
        this.tempAmount =  double.parse(this.tempAmount.toStringAsPrecision(3)) + 0.01; minCount += 1; print (this.tempAmount); print(minCount);
      }else break;
    }
    moneyAmountText = this.moneyAmount;
    print(moneyAmountText);
    moneyAmountText.replaceAll(RegExp(r'.'), ',');
  }

  @override
  Widget build(BuildContext context) {
    final sum = amounts.sum;
    tempAmount = 0;
    return Column(children: [
      // Row(
      //   children: [

      Text("currentAmountDouble: " + currentAmountDouble.toString()),
      Text("tempAmount: " + tempAmount.toString() + " "),
      Text("Optimum: " + minCount.toString() + " "),
      Text("i:" + i.toString()),

      //   ],double.parse(finalMoneyAmount.toStringAsFixed(2)
      // ),
      // Lama Speechbubble
      Container(
        height: (constraints.maxHeight / 100) * 20,
        padding: EdgeInsets.only(left: 15, right: 15),
        // create space between each child
        child: Stack(
          children: [
            Text(sum.toString()),
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
                      "Sammle $moneyAmountText€ mit den Münzen zusammen!",
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
      //Coin Display 2, 1, 50, 20
      Container(
        height: (constraints.maxHeight / 100) * 25,
        //color: LamaColors.orangeAccent,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                child: Container(
                  height: (constraints.maxHeight / 100) * 20,
                  child: Stack(alignment: Alignment.centerRight, children: [
                    SvgPicture.asset(
                      (false)
                          ? "assets/images/svg/EuroCoins/2_Euro.svg"
                          : (false)
                              ? "assets/images/svg/EuroCoins/2_Euro.svg"
                              : "assets/images/svg/EuroCoins/2_Euro.svg",
                      semanticsLabel: "Zwei Euro",
                      width: (constraints.maxWidth / 100) * 25,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        amounts[0].toString(),
                        style: LamaTextTheme.getStyle(color: LamaColors.black),
                      ),
                    ),
                  ]),
                ),
                onTap: () {
                  setState(() {
                    deletions.add(2);
                    amounts[0]++;
                    currentAmountDouble = currentAmountDouble + 2;
                    currentAmountDouble =
                        double.parse(currentAmountDouble.toStringAsFixed(2));
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: (constraints.maxHeight / 100) * 20,
                  child: Stack(alignment: Alignment.centerRight, children: [
                    // SvgPicture.asset(
                    //   "assets/images/jpg/5euro.jpg",
                    //   semanticsLabel: "Ein Euro",
                    //   width: (constraints.maxWidth / 100) * 23,
                    //),
                    (task.difficulty == 3)
                        ? Image.asset(
                            "assets/images/jpg/5_Euro.jpg",
                            width: (constraints.maxWidth / 100) * 23,
                          )
                        : SvgPicture.asset(
                            "assets/images/svg/EuroCoins/1_Euro.svg",
                            semanticsLabel: "Ein Euro",
                            width: (constraints.maxWidth / 100) * 23,
                          ),

                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        amounts[1].toString(),
                        style: LamaTextTheme.getStyle(color: LamaColors.black),
                      ),
                    ),
                  ]),
                ),
                onTap: () {
                  setState(() {
                    deletions.add(1);
                    amounts[1]++;
                    (task.difficulty == 3)
                        ? currentAmountDouble = currentAmountDouble + 5
                        : currentAmountDouble = currentAmountDouble + 1;
                    currentAmountDouble =
                        double.parse(currentAmountDouble.toStringAsFixed(2));
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: (constraints.maxHeight / 100) * 20,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      SvgPicture.asset(
                        "assets/images/svg/EuroCoins/50_Cent.svg",
                        semanticsLabel: "Fünfzig Cent",
                        width: (constraints.maxWidth / 100) * 23,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          amounts[2].toString(),
                          style:
                              LamaTextTheme.getStyle(color: LamaColors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    deletions.add(0.5);
                    amounts[2]++;
                    currentAmountDouble = currentAmountDouble + 0.5;
                    currentAmountDouble =
                        double.parse(currentAmountDouble.toStringAsFixed(2));
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: (constraints.maxHeight / 100) * 20,
                  child: Stack(alignment: Alignment.centerRight, children: [
                    SvgPicture.asset(
                      "assets/images/svg/EuroCoins/20_Cent.svg",
                      semanticsLabel: "Zwanzig Cent",
                      width: (constraints.maxWidth / 100) * 20,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        amounts[3].toString(),
                        style: LamaTextTheme.getStyle(color: LamaColors.black),
                      ),
                    ),
                  ]),
                ),
                onTap: () {
                  setState(() {
                    deletions.add(0.2);
                    amounts[3]++;
                    currentAmountDouble = currentAmountDouble + 0.2;
                    currentAmountDouble =
                        double.parse(currentAmountDouble.toStringAsFixed(2));
                  });
                },
              ),
            ],
          ),
        ),
      ),
      //Coin Display 10, 5, 2, 1
      Container(
        height: (constraints.maxHeight / 100) * 20,
        padding: EdgeInsets.only(bottom: 20),
        //color: LamaColors.orangeAccent,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                child: Container(
                  height: (constraints.maxWidth / 100) * 20,
                  width: (constraints.maxWidth / 100) * 25,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/svg/EuroCoins/10_Cent.svg",
                        semanticsLabel: "Zehn Cent",
                        width: (constraints.maxWidth / 100) * 20,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          amounts[4].toString(),
                          style:
                              LamaTextTheme.getStyle(color: LamaColors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    deletions.add(0.1);
                    amounts[4]++;
                    currentAmountDouble = currentAmountDouble + 0.1;
                    currentAmountDouble =
                        double.parse(currentAmountDouble.toStringAsFixed(2));
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: (constraints.maxWidth / 100) * 20,
                  width: (constraints.maxWidth / 100) * 23,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/svg/EuroCoins/5_Cent.svg",
                        semanticsLabel: "Fünf Cent",
                        width: (constraints.maxWidth / 100) * 19,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          amounts[5].toString(),
                          style:
                              LamaTextTheme.getStyle(color: LamaColors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    deletions.add(0.05);
                    amounts[5]++;
                    currentAmountDouble = currentAmountDouble + 0.05;
                    currentAmountDouble =
                        double.parse(currentAmountDouble.toStringAsFixed(2));
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: (constraints.maxWidth / 100) * 20,
                  width: (constraints.maxWidth / 100) * 23,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/svg/EuroCoins/2_Cent.svg",
                        semanticsLabel: "Zwei Cent",
                        width: (constraints.maxWidth / 100) * 16,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          amounts[6].toString(),
                          style:
                              LamaTextTheme.getStyle(color: LamaColors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    deletions.add(0.02);
                    amounts[6]++;
                    currentAmountDouble = currentAmountDouble + 0.02;
                    currentAmountDouble =
                        double.parse(currentAmountDouble.toStringAsFixed(2));
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: (constraints.maxWidth / 100) * 20,
                  width: (constraints.maxWidth / 100) * 20,
                  child: Stack(alignment: Alignment.center, children: [
                    SvgPicture.asset(
                      "assets/images/svg/EuroCoins/1_Cent.svg",
                      semanticsLabel: "Ein Cent",
                      width: (constraints.maxWidth / 100) * 13,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        amounts[7].toString(),
                        style: LamaTextTheme.getStyle(color: LamaColors.black),
                      ),
                    ),
                  ]),
                ),
                onTap: () {
                  setState(() {
                    deletions.add(0.01);
                    amounts[7]++;
                    currentAmountDouble = currentAmountDouble + 0.01;
                    currentAmountDouble =
                        double.parse(currentAmountDouble.toStringAsFixed(2));
                  });
                },
              ),
            ],
          ),
        ),
      ),
      // reset and finish Button
      Container(
        height: (constraints.maxHeight / 100) * 20,
        child: Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //undo button
              Container(
                height: (constraints.maxHeight / 100) * 12,
                width: (constraints.maxWidth / 100) * 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: LamaColors.redAccent,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3)),
                    ]),
                child: InkWell(
                  child: IconButton(
                    padding: EdgeInsets.all(1.0),
                    icon: Icon(
                      Icons.replay_rounded,
                      size: 40,
                    ),
                    color: LamaColors.white,
                    onPressed: () {
                      setState(() {
                        if (deletions.isNotEmpty) {
                          currentAmountDouble =
                              currentAmountDouble - deletions.last;
                          double deletedElement = deletions.removeLast();
                          updateAmount(deletedElement);
                        } else {
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Container(
                                    height: (constraints.maxHeight / 100) * 4,
                                    alignment: Alignment.bottomCenter,
                                    child: Center(
                                        child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        "Füge zuerst einen Betrag hinzu",
                                        style: LamaTextTheme.getStyle(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ))),
                                backgroundColor: LamaColors.mainPink,
                                duration: Duration(seconds: 1)),
                          );
                        }
                      });
                    },
                  ),
                ),
              ),
              //fertig button
              Container(
                height: (constraints.maxHeight / 100) * 12,
                width: (constraints.maxWidth / 100) * 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: LamaColors.greenAccent,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3)),
                    ]),
                child: InkWell(
                  child: Center(
                    child: Text(
                      "Fertig",
                      style: LamaTextTheme.getStyle(
                          fontSize: 25,
                          color: LamaColors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  onTap: () {
                    finalMoneyAmount = currentAmountDouble;
                    currentAmountDouble = 0;
                    tempAmount = 0;
                    deletions.clear();
                    print("finalmoneyamount: $finalMoneyAmount");
                    print(
                        "finalMoneyAmount.toStringAsFixed(2): $finalMoneyAmount.toStringAsFixed(2)");
                    print("moneyAmount: $moneyAmount");

                    if ((this.finalMoneyAmount.toString()) ==
                        (this.moneyAmount)) {
                      answer = true;
                      print("correct");
                    } else {
                      answer = false;
                      print("false");
                    }
                    // (finalMoneyAmount.toStringAsFixed(2) == moneyAmount) ? answer = true : answer = false;
                    BlocProvider.of<TaskBloc>(context)
                        .add(AnswerTaskEvent.initMoneyTask(answer));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    ]);
  }

  /// updateAmount is used to refresh the coin press counter
  /// after undoing a tapp the counter of the last tapped coin needs to be decrement
  /// {@param} double [deletedElement] indicates which coin got pressed last
  updateAmount(deletedElement) {
    if (deletedElement == 2) {
      amounts[0]--;
    } else if (deletedElement == 1) {
      amounts[1]--;
    } else if (deletedElement == 0.5) {
      amounts[2]--;
    } else if (deletedElement == 0.2) {
      amounts[3]--;
    } else if (deletedElement == 0.1) {
      amounts[4]--;
    } else if (deletedElement == 0.05) {
      amounts[5]--;
    } else if (deletedElement == 0.02) {
      amounts[6]--;
    } else if (deletedElement == 0.01) {
      amounts[7]--;
    }
  }
}