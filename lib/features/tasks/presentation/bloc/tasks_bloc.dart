import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../data/repositories/tasks_repository.dart';
import 'tasks_event.dart';
import 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TasksRepository _tasksRepository;
  final Logger _logger = Logger();

  TasksBloc(this._tasksRepository) : super(const TasksInitial()) {
    on<TasksLoadRequested>(_onTasksLoadRequested);
    on<TaskCreateRequested>(_onTaskCreateRequested);
    on<TaskUpdateRequested>(_onTaskUpdateRequested);
    on<TaskToggleRequested>(_onTaskToggleRequested);
    on<TaskDeleteRequested>(_onTaskDeleteRequested);
    on<TasksStatsRequested>(_onTasksStatsRequested);
  }

  Future<void> _onTasksLoadRequested(
    TasksLoadRequested event,
    Emitter<TasksState> emit,
  ) async {
    emit(const TasksLoading());

    try {
      _logger.d('📋 Cargando tareas...');

      final tasks = await _tasksRepository.getTasks();
      final stats = await _tasksRepository.getStats();

      _logger.i('✅ ${tasks.length} tareas cargadas');

      emit(TasksLoaded(tasks: tasks, stats: stats));
    } catch (e) {
      _logger.e('❌ Error cargando tareas: $e');
      emit(TasksError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onTaskCreateRequested(
    TaskCreateRequested event,
    Emitter<TasksState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TasksLoaded) return;

    emit(TaskOperationLoading(currentState.tasks));

    try {
      _logger.d('✏️ Creando tarea: ${event.title}');

      final newTask = await _tasksRepository.createTask(
        title: event.title,
        description: event.description,
      );

      _logger.i('✅ Tarea creada: ${newTask.id}');

      // Recargar tareas
      add(const TasksLoadRequested());
    } catch (e) {
      _logger.e('❌ Error creando tarea: $e');
      emit(TasksError(e.toString().replaceAll('Exception: ', '')));
      emit(currentState);
    }
  }

  Future<void> _onTaskUpdateRequested(
    TaskUpdateRequested event,
    Emitter<TasksState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TasksLoaded) return;

    emit(TaskOperationLoading(currentState.tasks));

    try {
      _logger.d('✏️ Actualizando tarea: ${event.id}');

      await _tasksRepository.updateTask(
        id: event.id,
        title: event.title,
        description: event.description,
        completed: event.completed,
      );

      _logger.i('✅ Tarea actualizada: ${event.id}');

      // Recargar tareas
      add(const TasksLoadRequested());
    } catch (e) {
      _logger.e('❌ Error actualizando tarea: $e');
      emit(TasksError(e.toString().replaceAll('Exception: ', '')));
      emit(currentState);
    }
  }

  Future<void> _onTaskToggleRequested(
    TaskToggleRequested event,
    Emitter<TasksState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TasksLoaded) return;

    try {
      _logger.d('🔄 Toggle tarea: ${event.id}');

      // Optimistic update
      final updatedTasks = currentState.tasks.map((task) {
        if (task.id == event.id) {
          return task.copyWith(completed: !task.completed);
        }
        return task;
      }).toList();

      emit(currentState.copyWith(tasks: updatedTasks));

      // Actualizar en backend
      await _tasksRepository.toggleTask(event.id);

      _logger.i('✅ Estado cambiado: ${event.id}');

      // Recargar para sincronizar
      add(const TasksLoadRequested());
    } catch (e) {
      _logger.e('❌ Error toggle tarea: $e');
      emit(TasksError(e.toString().replaceAll('Exception: ', '')));
      emit(currentState);
    }
  }

  Future<void> _onTaskDeleteRequested(
    TaskDeleteRequested event,
    Emitter<TasksState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TasksLoaded) return;

    try {
      _logger.d('🗑️ Eliminando tarea: ${event.id}');

      // Optimistic delete
      final updatedTasks = currentState.tasks
          .where((task) => task.id != event.id)
          .toList();

      emit(currentState.copyWith(tasks: updatedTasks));

      // Eliminar en backend
      await _tasksRepository.deleteTask(event.id);

      _logger.i('✅ Tarea eliminada: ${event.id}');

      // Recargar para sincronizar
      add(const TasksLoadRequested());
    } catch (e) {
      _logger.e('❌ Error eliminando tarea: $e');
      emit(TasksError(e.toString().replaceAll('Exception: ', '')));
      emit(currentState);
    }
  }

  Future<void> _onTasksStatsRequested(
    TasksStatsRequested event,
    Emitter<TasksState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TasksLoaded) return;

    try {
      final stats = await _tasksRepository.getStats();
      emit(currentState.copyWith(stats: stats));
    } catch (e) {
      _logger.e('❌ Error obteniendo estadísticas: $e');
    }
  }
}
