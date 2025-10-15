import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/models/task_model.dart';
import '../../../../core/services/http_service.dart';

class TasksRepository {
  final HttpService _httpService;

  TasksRepository(this._httpService);

  /// Obtener todas las tareas del usuario
  Future<List<TaskModel>> getTasks() async {
    try {
      final response = await _httpService.get(ApiConstants.tasks);
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => TaskModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Obtener una tarea específica
  Future<TaskModel> getTask(String id) async {
    try {
      final response = await _httpService.get(ApiConstants.taskById(id));
      return TaskModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Crear nueva tarea
  Future<TaskModel> createTask({
    required String title,
    String? description,
    bool completed = false,
  }) async {
    try {
      final response = await _httpService.post(
        ApiConstants.tasks,
        data: {
          'title': title,
          if (description != null && description.isNotEmpty)
            'description': description,
          'completed': completed,
        },
      );
      return TaskModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Actualizar tarea
  Future<TaskModel> updateTask({
    required String id,
    String? title,
    String? description,
    bool? completed,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (title != null) data['title'] = title;
      if (description != null) data['description'] = description;
      if (completed != null) data['completed'] = completed;

      final response = await _httpService.put(
        ApiConstants.taskById(id),
        data: data,
      );
      return TaskModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Toggle estado completado/pendiente
  Future<TaskModel> toggleTask(String id) async {
    try {
      final response = await _httpService.patch(ApiConstants.taskToggle(id));
      return TaskModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Eliminar tarea
  Future<void> deleteTask(String id) async {
    try {
      await _httpService.delete(ApiConstants.taskById(id));
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Obtener estadísticas de tareas
  Future<Map<String, int>> getStats() async {
    try {
      final response = await _httpService.get(ApiConstants.tasksStats);
      return {
        'total': response.data['total'] as int,
        'completed': response.data['completed'] as int,
        'pending': response.data['pending'] as int,
      };
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response != null) {
      final data = e.response!.data;
      String message = 'Error desconocido';

      if (data is Map<String, dynamic> && data['message'] != null) {
        message = data['message'];
      }

      return Exception(message);
    }
    return Exception('Error de conexión: ${e.message}');
  }
}
