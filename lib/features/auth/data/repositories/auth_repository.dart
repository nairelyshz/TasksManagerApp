import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/models/auth_response_model.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/services/http_service.dart';
import '../../../../core/services/storage_service.dart';

class AuthRepository {
  final HttpService _httpService;
  final StorageService _storageService;

  AuthRepository(this._httpService, this._storageService);

  /// Registrar un nuevo usuario
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _httpService.post(
        ApiConstants.authRegister,
        data: {'email': email, 'password': password, 'name': name},
      );

      final authResponse = AuthResponseModel.fromJson(response.data);

      // Guardar token
      await _storageService.saveToken(authResponse.accessToken);

      return authResponse;
    } on DioException catch (e) {
      if (e.response != null) {
        throw _handleError(e.response!);
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  /// Iniciar sesión
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _httpService.post(
        ApiConstants.authLogin,
        data: {'email': email, 'password': password},
      );

      final authResponse = AuthResponseModel.fromJson(response.data);

      // Guardar token
      await _storageService.saveToken(authResponse.accessToken);

      return authResponse;
    } on DioException catch (e) {
      if (e.response != null) {
        throw _handleError(e.response!);
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  /// Cerrar sesión
  Future<void> logout() async {
    await _storageService.deleteToken();
  }

  /// Verificar si el usuario está autenticado
  Future<bool> isAuthenticated() async {
    return await _storageService.hasToken();
  }

  /// Obtener perfil del usuario
  Future<UserModel> getProfile() async {
    try {
      final response = await _httpService.get(ApiConstants.usersProfile);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw _handleError(e.response!);
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  /// Obtener token guardado
  Future<String?> getToken() async {
    return await _storageService.getToken();
  }

  /// Manejar errores de la API
  Exception _handleError(Response response) {
    final statusCode = response.statusCode;
    final data = response.data;

    String message = 'Error desconocido';

    if (data is Map<String, dynamic>) {
      if (data['message'] != null) {
        message = data['message'];
      } else if (data['errors'] != null && data['errors'] is List) {
        message = (data['errors'] as List).join(', ');
      }
    }

    switch (statusCode) {
      case 400:
        return Exception('Datos inválidos: $message');
      case 401:
        return Exception('Credenciales inválidas');
      case 403:
        return Exception('Acceso denegado');
      case 404:
        return Exception('Recurso no encontrado');
      case 409:
        return Exception(message); // Email ya registrado
      case 500:
        return Exception('Error del servidor');
      default:
        return Exception('Error: $message');
    }
  }
}
