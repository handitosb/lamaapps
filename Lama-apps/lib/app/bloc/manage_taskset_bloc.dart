import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/manage_taskset_event.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/state/manage_taskset_state.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';


///[Bloc] for the [ManageTasksetScreen]
///
/// * see also
///     [ManageTasksetScreen]
///     [ManageTasksetEvent]
///     [ManageTasksetState]
///
/// Author: K.Binder
class ManageTasksetBloc extends Bloc<ManageTasksetEvent, ManageTasksetState> {
  TasksetRepository repository;

  ManageTasksetBloc(this.repository) : super(LoadingAllTasksetsState());

  @override
  Stream<ManageTasksetState> mapEventToState(ManageTasksetEvent event) async* {
    if (event is LoadAllTasksetsEvent) {
      yield LoadingAllTasksetsState();
      List<Taskset> tasksets =
          repository.getTasksetsForSubjectAndGrade(event.subject, event.grade);
      //This line displays a very short loading animation, if the taskssets get loaded instantly. It serves no real purpose but it makes it look more professional
      await Future.delayed(Duration(milliseconds: 500));
      yield LoadedAllTasksetsState(tasksets);
    }
  }
}
