import 'package:equatable/equatable.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object?> get props => [];
}

class TasksLoadRequested extends TasksEvent {
  const TasksLoadRequested();
}

class TaskCreateRequested extends TasksEvent {
  final String title;
  final String? description;

  const TaskCreateRequested({required this.title, this.description});

  @override
  List<Object?> get props => [title, description];
}

class TaskUpdateRequested extends TasksEvent {
  final String id;
  final String? title;
  final String? description;
  final bool? completed;

  const TaskUpdateRequested({
    required this.id,
    this.title,
    this.description,
    this.completed,
  });

  @override
  List<Object?> get props => [id, title, description, completed];
}

class TaskToggleRequested extends TasksEvent {
  final String id;

  const TaskToggleRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class TaskDeleteRequested extends TasksEvent {
  final String id;

  const TaskDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class TasksStatsRequested extends TasksEvent {
  const TasksStatsRequested();
}
