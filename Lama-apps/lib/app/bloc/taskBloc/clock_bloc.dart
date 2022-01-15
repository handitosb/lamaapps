import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/task-system/task.dart';

class ClockBloc extends Bloc<ClockEvent, ClockState>{
List<String> answerList = [];
final ClockTest task;

ClockBloc(this.task) : super(EmptyClockState());

  @override
  Stream<ClockState> mapEventToState(ClockEvent event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }

}

class ClockEvent{}
class ClockState{}
class EmptyClockState extends ClockState{}