import 'package:lama_app/app/task-system/taskset_model.dart';

///BaseState for the [ManageTasksetBloc].
///
///Author: K.Binder
abstract class ManageTasksetState {}

///Subclass of [ManageTasksetState].
///
///Emitted while the [ManageTasksetBloc] is loading all tasksets.
///
///Author: K.Binder
class LoadingAllTasksetsState extends ManageTasksetState {}

///Subclass of [ManageTasksetState].
///
///Emitted when all tasksets are loaded. They get passed via [tasksets].
class LoadedAllTasksetsState extends ManageTasksetState {
  List<Taskset> tasksets;
  LoadedAllTasksetsState(this.tasksets);
}
