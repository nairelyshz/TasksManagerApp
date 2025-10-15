import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final Logger _logger = Logger();

  AuthBloc(this._authRepository) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      _logger.d('🔍 Verificando autenticación...');

      final isAuthenticated = await _authRepository.isAuthenticated();

      if (!isAuthenticated) {
        _logger.d('❌ No hay sesión activa');
        emit(const AuthUnauthenticated());
        return;
      }

      // Obtener perfil del usuario
      final user = await _authRepository.getProfile();
      final token = await _authRepository.getToken();

      _logger.d('✅ Sesión activa: ${user.email}');
      emit(AuthAuthenticated(user: user, token: token!));
    } catch (e) {
      _logger.e('❌ Error verificando autenticación: $e');
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      _logger.d('🔐 Iniciando login: ${event.email}');

      final authResponse = await _authRepository.login(
        email: event.email,
        password: event.password,
      );

      _logger.i('✅ Login exitoso: ${authResponse.user.email}');

      emit(
        AuthAuthenticated(
          user: authResponse.user,
          token: authResponse.accessToken,
        ),
      );
    } catch (e) {
      _logger.e('❌ Error en login: $e');
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      _logger.d('📝 Registrando usuario: ${event.email}');

      final authResponse = await _authRepository.register(
        email: event.email,
        password: event.password,
        name: event.name,
      );

      _logger.i('✅ Registro exitoso: ${authResponse.user.email}');

      emit(
        AuthAuthenticated(
          user: authResponse.user,
          token: authResponse.accessToken,
        ),
      );
    } catch (e) {
      _logger.e('❌ Error en registro: $e');
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      _logger.d('👋 Cerrando sesión...');

      await _authRepository.logout();

      _logger.i('✅ Sesión cerrada exitosamente');

      emit(const AuthUnauthenticated());
    } catch (e) {
      _logger.e('❌ Error al cerrar sesión: $e');
      emit(const AuthUnauthenticated());
    }
  }
}
