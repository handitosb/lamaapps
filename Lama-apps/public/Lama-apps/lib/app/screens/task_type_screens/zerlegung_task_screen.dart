import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';


class NumberBox extends StatelessWidget {
  final Function(int value) onChanged;
  NumberBox({Key key,  this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return 
      Container(
      width: 67,
      height: 60,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
         color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: Colors.blueAccent.withOpacity(0.9))

      ),

      child: TextField(
        decoration: InputDecoration(
            border: InputBorder.none,
       ),


        onChanged: (value){
          onChanged(int.tryParse(value) ?? 0);
        },
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18, 
          letterSpacing: 2, fontWeight: FontWeight.w900 , color: Colors.white
        ),
        keyboardType: TextInputType.number, 
      ),
      
     );
   
 }
}
class ZerlegungTaskScreen extends StatefulWidget {
  ZerlegungTaskScreen({Key key,  this.task, this.constraints}) : super(key: key);
  final TaskZerlegung task;
  final BoxConstraints constraints;
  
  @override
  State<StatefulWidget> createState() {
    return ZerlegungTaskScreenState(constraints);
  }
}
class ZerlegungTaskScreenState extends State<ZerlegungTaskScreen> {
  final BoxConstraints constraints;
  List<int> _answerParts = [];

  ZerlegungTaskScreenState(this.constraints);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _answerParts = List.filled(widget.task.answerParts.length, 0);

  }

  @override
  Widget build(BuildContext context) {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ 
          Container( 
        padding: EdgeInsets.only(left: 20, right: 5),
        child: Stack(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.all(35),
              padding: EdgeInsets.only(left: 30),
              height: 90,
              width: MediaQuery.of(context).size.width,
              child: Bubble(
                nip: BubbleNip.leftCenter,
                child: Center(
                  child: Text( "Zerlegt die Zahlen in einer Zehner und Hunderter und umgekehrt!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ),
          Align( 
            alignment: Alignment.centerLeft,
            child: Container(
             margin: EdgeInsets.only(right:5,left: 3, top: 20),
             padding: EdgeInsets.only(right: 40),
             height: 100,
            child: SvgPicture.asset(
              "assets/images/svg/lama_head.svg",
              semanticsLabel: "Lama Anna",
              width: 60,
            ),
          )),
        ]),
      ), 
          Container(
            margin:EdgeInsets.only(right:10,left: 30, top: 100),
            //height:  (constraints.maxHeight / 100) * 40,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  Container(
                    height:  (constraints.maxHeight / 100) * 8,
                     width: 5,
                      margin: EdgeInsets.only(right:10,left: 15),
                      padding: EdgeInsets.only(right:430),
                      child: Text(widget.task.reverse ? "H":"E",style: TextStyle (fontWeight: FontWeight.w600,
                        fontSize: 35 , color: Colors.pinkAccent
                        
                        ),
                   ),    
                  ),
                  Container(
                     height:  (constraints.maxHeight / 100) * 8,
                     width: 5,
                      margin: EdgeInsets.only(right:10,left: 90),
                      padding: EdgeInsets.only(right:430),
                      child: Text('Z',style: TextStyle (fontWeight: FontWeight.w600,
                        fontSize: 35 , color: Colors.blue
                        
                        ),
                   ),    
                  ),
                  Container(
                     height:  (constraints.maxHeight / 100) * 8,
                     width: 5,
                      margin: EdgeInsets.only(right:10,left: 90),
                      padding: EdgeInsets.only(right:430),
                      child: Text(widget.task.reverse ? "E":"H",style: TextStyle (fontWeight: FontWeight.w600,
                        fontSize: 35 , color: Colors.pinkAccent
                        
                        ),
                   ),    
                  ),

                    ]),
                  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ 
                  NumberBox(onChanged: (value){
                    _answerParts[0] = value;
                  }),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text("+", style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                  ),),),
                  NumberBox(onChanged: (value){
                    _answerParts[1] = value;
                  }),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text("+", style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                    ),),),
                  NumberBox(onChanged: (value){
                    _answerParts[2] = value;
                  }),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text("=", style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                    ),),),
                  Text(widget.task.rightAnswer.toString(),  style: const TextStyle(
                      fontWeight: FontWeight.w700, 
                      fontSize: 25
                  ),)
               
                ],), 
                ])
          ),
          SizedBox(height: 100,),
          
          Padding(
            padding: const EdgeInsets.all(33.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 MaterialButton(onPressed: (){
                    
                  },
                  padding: EdgeInsets.symmetric(horizontal: 45, vertical: 20 ),
                  height: 80,
                  color: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                  child: Icon(Icons.replay, size: 40, color: Colors.white ),
                                  ),
                  MaterialButton(onPressed: (){
                    BlocProvider.of<TaskBloc>(context).add(AnswerTaskEvent.initZerlegung(_answerParts));
                  },
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                  child: Text("Fertig!", style: 
                  TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    letterSpacing: 2
                  )),
                ),

                // MaterialButton(onPressed: (){
                    
                //   },
                //   padding: EdgeInsets.symmetric(horizontal: 45, vertical: 20 ),
                //   height: 80,
                  
                //   color: Colors.purple,
                //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                //   child: Icon(Icons.replay, size: 30, color: Colors.white),
                //                   )
              ],
            ),
          )
    
    ]  
    );
                     
           
  }
}

/* 
Container(
        margin:EdgeInsets.only(right:10,left: 30, top: 100),
        height:  (constraints.maxHeight / 100) * 60,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
          Container(  
          height: (constraints.maxHeight / 100) * 10,
          width: (constraints.maxHeight / 120) * 25,
          margin: EdgeInsets.only(left: 70, right: 20 ),  
          alignment: Alignment.center,
        child:ElevatedButton(onPressed: (){ 
        Container(
          // height: 200,
          // width: 60,
          //  margin: EdgeInsets.only(left: 2, right: 1 ),
          //  padding: EdgeInsets.only(right:9),
            decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(9)),
            color: Colors.blue, 
            boxShadow: [
            BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3))
              ]),);
      BlocProvider.of<TaskBloc>(context).add(AnswerTaskEvent.initZerlegung(_answerParts));
          print("Local answer parts : $_answerParts");
      },
        
        child: Center(  
        child: Text("Fertig",textAlign: TextAlign.center,style: TextStyle (fontWeight: FontWeight.w600,
                fontSize: 35, ),
                ),       
      ),),
      ), */