class ApiConstants {
  // Base URL - Cambiar según tu entorno
  static const String baseUrl = 'http://localhost:3000/api';

  // Para Android Emulator usa: 'http://10.0.2.2:3000/api'
  // Para iOS Simulator usa: 'http://localhost:3000/api'
  // Para dispositivo físico usa: 'http://TU_IP_LOCAL:3000/api'

  // Auth endpoints
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';

  // Users endpoints
  static const String usersProfile = '/users/profile';
  static const String usersMe = '/users/me';

  // Tasks endpoints
  static const String tasks = '/tasks';
  static String taskById(String id) => '/tasks/$id';
  static String taskToggle(String id) => '/tasks/$id/toggle';
  static const String tasksStats = '/tasks/stats';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
