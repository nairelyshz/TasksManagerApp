import 'package:equatable/equatable.dart';
import '../../../../core/models/task_model.dart';

abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object?> get props => [];
}

class TasksInitial extends TasksState {
  const TasksInitial();
}

class TasksLoading extends TasksState {
  const TasksLoading();
}

class TasksLoaded extends TasksState {
  final List<TaskModel> tasks;
  final Map<String, int>? stats;

  const TasksLoaded({required this.tasks, this.stats});

  @override
  List<Object?> get props => [tasks, stats];

  TasksLoaded copyWith({List<TaskModel>? tasks, Map<String, int>? stats}) {
    return TasksLoaded(tasks: tasks ?? this.tasks, stats: stats ?? this.stats);
  }
}

class TasksError extends TasksState {
  final String message;

  const TasksError(this.message);

  @override
  List<Object?> get props => [message];
}

class TaskOperationLoading extends TasksState {
  final List<TaskModel> currentTasks;

  const TaskOperationLoading(this.currentTasks);

  @override
  List<Object?> get props => [currentTasks];
}
