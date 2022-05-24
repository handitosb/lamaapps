import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/manage_taskset_bloc.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/bloc/task_bloc2.dart';
import 'package:lama_app/app/event/manage_taskset_event.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/screens/task_screen.dart';
import 'package:lama_app/app/screens/taskset_edit_screen.dart';
import 'package:lama_app/app/state/manage_taskset_state.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';


class ManageTasksetScreen extends StatefulWidget {
  final TasksetRepository tasksetRepository;
  

  ManageTasksetScreen(this.tasksetRepository);

  @override
  State<StatefulWidget> createState() {
    return ManageTasksetScreenState(tasksetRepository);
  }
}

class ManageTasksetScreenState extends State<ManageTasksetScreen> {
  TasksetRepository tasksetRepository;
  ManageTasksetScreenState(
      this.tasksetRepository);

  
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ManageTasksetBloc>(context)
        .add(LoadAllTasksetsEvent(tasksetRepository.tasksetLoader.toString())); //Fehler. Es soll alle Tasksets geladen werden. Problem: userRepository
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: LamaColors.mainPink,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.white,
              child: Container(
                margin: EdgeInsets.only(top: (screenSize.height / 100) * 7.5),
                child: Center(
                  child: BlocBuilder<ManageTasksetBloc, ManageTasksetState>(
                    builder: (context, state) {
                      if (state is LoadingAllTasksetsState)
                        return CircularProgressIndicator();
                      else
                        return _buildTasksetList(context, state);
                    },
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: screenSize.width,
                height: (screenSize.height / 100) * 7.5,
                decoration: BoxDecoration(
                  color: LamaColors.mainPink,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 2,
                        offset: Offset(0, 2),
                        spreadRadius: 1,
                        color: Colors.grey)
                  ],
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        icon: Icon(
                          Icons.arrow_back,
                          size: 40,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Tasksets verwalten",
                        style: LamaTextTheme.getStyle(fontSize: 22.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Returns a centered, seperated ListView containing all loaded Tasksets.
  Widget _buildTasksetList(context, state) {
    return Center(
      child: ListView.separated(
        padding: EdgeInsets.only(top: 15, left: 50, right: 50),
        itemCount: state.tasksets.length,
        itemBuilder: (context, index) {
          return _buildTasksetListItem(context, state.tasksets[index]);
        },
        separatorBuilder: (context, index) => SizedBox(height: 10),
      ),
    );
  }

  ///Returns a Container widget representing a single Taskset.
  ///
  ///Used by [_buildTasksetList()]
  Widget _buildTasksetListItem(context, Taskset taskset) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.all(10),
        width: screenSize.width,
        height: (screenSize.height / 100) * 17.5,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [LamaColors.orangeAccent, LamaColors.redAccent]),
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                color: Colors.blueGrey, offset: Offset(0, 1), blurRadius: 1)
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<TaskBloc2>(
                    create: (context) => TaskBloc2(taskset.subject,
                        generateTaskList(taskset)),   //das muss noch ändern nachdem die Tasksets erfolgreich geladen sind. Navigation zu neuer Seite => TasksetsBearbeitung
                    child: TasksetEditScreen(),
                  ),
                ),
              ),
            },
            child: Column(
              children: [
                FittedBox(
                  child: Text(
                    taskset.name,
                    style: LamaTextTheme.getStyle(fontSize: 20, shadows: [
                      Shadow(
                          color: Colors.blueGrey,
                          offset: Offset(0, 1),
                          blurRadius: 2),
                    ]),
                  ),
                ),
                SizedBox(height: (screenSize.height / 100) * 2),
                FittedBox(
                  child: Text(
                    "Aufgaben insgesamt: " + taskset.tasks.length.toString(),
                    style: LamaTextTheme.getStyle(fontSize: 15, shadows: [
                      Shadow(
                          color: Colors.blueGrey,
                          offset: Offset(0, 1),
                          blurRadius: 1),
                    ]),
                  ),
                ),
                SizedBox(height: (screenSize.height / 100) * 1.5),
                Text(
                  "Aufgaben pro Durchgang: " +
                      taskset.randomTaskAmount.toString(),
                  style: LamaTextTheme.getStyle(fontSize: 15, shadows: [
                    Shadow(
                        color: Colors.blueGrey,
                        offset: Offset(0, 1),
                        blurRadius: 1),
                  ]),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
        ));
  }

  ///Returns a list of [Task] that will be passed to the [TaskBloc].
  ///
  ///This list can contain all Tasks of a Taskset (ordered or unordered),
  ///but can also contain only a fraction of the tasks,
  ///based on the Taskset prameters
  List<Task> generateTaskList(Taskset taskset) {
    if (taskset.randomTaskAmount == taskset.tasks.length &&
        !taskset.randomizeOrder) {
      return taskset.tasks;
    }

    List<Task> tasks = [];

    List<Task> tempTasks = [];
    tempTasks.addAll(taskset.tasks);

    var rng = new Random();

    for (int i = taskset.randomTaskAmount; i > 0; i--) {
      int index = rng.nextInt(tempTasks.length);
      tasks.add(tempTasks[index]);
      tempTasks.removeAt(index);
    }
    return tasks;
  }
}
