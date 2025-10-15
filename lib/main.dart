import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/services/storage_service.dart';
import 'core/services/http_service.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/tasks/data/repositories/tasks_repository.dart';
import 'features/tasks/presentation/bloc/tasks_bloc.dart';
import 'features/tasks/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar servicios
  final storageService = await StorageService.getInstance();
  final httpService = HttpService(storageService);

  // Inicializar repositorios
  final authRepository = AuthRepository(httpService, storageService);
  final tasksRepository = TasksRepository(httpService);

  runApp(
    MyApp(
      storageService: storageService,
      httpService: httpService,
      authRepository: authRepository,
      tasksRepository: tasksRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final StorageService storageService;
  final HttpService httpService;
  final AuthRepository authRepository;
  final TasksRepository tasksRepository;

  const MyApp({
    super.key,
    required this.storageService,
    required this.httpService,
    required this.authRepository,
    required this.tasksRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // AuthBloc - Gestión de autenticación
        BlocProvider<AuthBloc>(create: (context) => AuthBloc(authRepository)),
        // TasksBloc - Gestión de tareas
        BlocProvider<TasksBloc>(
          create: (context) => TasksBloc(tasksRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Task Manager',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashPage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}
