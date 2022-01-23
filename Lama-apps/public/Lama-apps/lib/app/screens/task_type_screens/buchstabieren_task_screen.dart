import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';
import 'package:lama_app/app/task-system/task.dart';


class BuchstabierenTaskScreen extends StatefulWidget {
  final TaskBuchstabieren task;
  final BoxConstraints constraints;

  const BuchstabierenTaskScreen({Key key,  this.task, this.constraints}) : super(key: key);

  @override
  _BuchstabierenTaskScreenState createState() => _BuchstabierenTaskScreenState();
}

class _BuchstabierenTaskScreenState extends State<BuchstabierenTaskScreen> {

  int _currSubTaskIndex = 0;
  List<String> _currAnswers = [];

  Map<String, String> _word2ImageMapper = {};
  int _answerFoundCounter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _word2ImageMapper = { for (var w in widget.task.words) w.word: w.image};
    setState(() {
      _fillCurrAnswers();
    });
  }

  void _fillCurrAnswers(){
    _currAnswers = [...widget.task.words[_currSubTaskIndex].wrongWords, widget.task.words[_currSubTaskIndex].word];
    _currAnswers.shuffle();
  }

  void onCheck(String word){

    if(_currSubTaskIndex == widget.task.words.length - 1){
      if(_word2ImageMapper[word] != null){
        setState(() {
          _answerFoundCounter = _answerFoundCounter + 1;
        });
      }
       BlocProvider.of<TaskBloc>(context)
            .add(AnswerTaskEvent.initBuchstabieren(_answerFoundCounter ==  widget.task.words.length));
    }
    else if(_currSubTaskIndex < widget.task.words.length - 1){

      setState(() {
        if(_word2ImageMapper[word] != null){

          _answerFoundCounter = _answerFoundCounter + 1;
        }
        _currSubTaskIndex = _currSubTaskIndex + 1;
        _fillCurrAnswers();
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 32,),
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(image: widget.task.words[_currSubTaskIndex].image.indexOf("assets") == 0
                ? AssetImage(widget.task.words[_currSubTaskIndex].image)
                : NetworkImage(widget.task.words[_currSubTaskIndex].image), fit: BoxFit.cover)
            ),
          ),
        ),
        
          Container( 
        padding: EdgeInsets.only(left: 20, right: 5),
        child: Stack(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.all(30),
              padding: EdgeInsets.only(left: 30),
              height: 90,
              width: MediaQuery.of(context).size.width,
              child: Bubble(
                nip: BubbleNip.leftCenter,
                child: Center(
                  child: Text( "Passende Wort zu dem richtigem Bild auswählen!",
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
        
        
        const SizedBox(height: 32,),
        Align(
          child: Text("Number of answers found : $_answerFoundCounter / ${widget.task.words.length}"),
          alignment: Alignment.center,
        ),
        const SizedBox(height: 32,),
        Wrap(
          spacing: 8,
          alignment: WrapAlignment.center,
          children: [
            ..._currAnswers.map((e) => ElevatedButton(onPressed: (){
              onCheck(e);
            }, child: Text(e)))
          ],
        )
      ],
    );
  }
}