/// BaseEvent for the [ManageTasksetBloc]
///
/// Author: K.Binder
abstract class ManageTasksetEvent {}

/// Subclass of [ManageTasksetEvent]
///
/// This event contains the [subject] and the [grade] of the
/// tasksets, that should be loaded.
///
/// Author: K.Binder
class LoadAllTasksetsEvent extends ManageTasksetEvent {
  String subject;
  int grade;
  LoadAllTasksetsEvent(this.subject);
}
