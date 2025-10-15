import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/task_model.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../bloc/tasks_bloc.dart';
import '../bloc/tasks_event.dart';
import '../bloc/tasks_state.dart';
import '../widgets/task_item.dart';
import '../widgets/task_form_dialog.dart';
import '../widgets/task_filter_chips.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TaskFilter _currentFilter = TaskFilter.all;

  @override
  void initState() {
    super.initState();
    // Cargar tareas al iniciar
    context.read<TasksBloc>().add(const TasksLoadRequested());
  }

  List<TaskModel> _getFilteredTasks(List<TaskModel> tasks) {
    switch (_currentFilter) {
      case TaskFilter.completed:
        return tasks.where((task) => task.completed).toList();
      case TaskFilter.pending:
        return tasks.where((task) => !task.completed).toList();
      case TaskFilter.all:
        return tasks;
    }
  }

  Future<void> _showCreateTaskDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) => const TaskFormDialog(),
    );

    if (result != null && mounted) {
      context.read<TasksBloc>().add(
        TaskCreateRequested(
          title: result['title'],
          description: result['description'],
        ),
      );
    }
  }

  Future<void> _showEditTaskDialog(task) async {
    final result = await showDialog(
      context: context,
      builder: (context) => TaskFormDialog(task: task),
    );

    if (result != null && mounted) {
      context.read<TasksBloc>().add(
        TaskUpdateRequested(
          id: task.id,
          title: result['title'],
          description: result['description'],
          completed: result['completed'],
        ),
      );
    }
  }

  Future<void> _showDeleteConfirmation(String taskId, String taskTitle) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Tarea'),
        content: Text('¿Estás seguro de eliminar "$taskTitle"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.read<TasksBloc>().add(TaskDeleteRequested(taskId));
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              this.context.read<AuthBloc>().add(const AuthLogoutRequested());
              Navigator.pushReplacementNamed(this.context, '/login');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Salir de la Aplicación'),
        content: const Text('¿Estás seguro de que quieres salir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );

    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mis Tareas'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _handleLogout,
              tooltip: 'Cerrar Sesión',
            ),
          ],
        ),
      body: BlocConsumer<TasksBloc, TasksState>(
        listener: (context, state) {
          if (state is TasksError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Reintentar',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<TasksBloc>().add(const TasksLoadRequested());
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TasksLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TasksLoaded || state is TaskOperationLoading) {
            final allTasks = state is TasksLoaded
                ? state.tasks
                : (state as TaskOperationLoading).currentTasks;

            final filteredTasks = _getFilteredTasks(allTasks);

            final stats = state is TasksLoaded ? state.stats : null;
            final totalTasks = stats?['total'] ?? allTasks.length;
            final completedTasks = stats?['completed'] ??
                allTasks.where((t) => t.completed).length;
            final pendingTasks =
                stats?['pending'] ?? allTasks.where((t) => !t.completed).length;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<TasksBloc>().add(const TasksLoadRequested());
                await Future.delayed(const Duration(seconds: 1));
              },
              child: Column(
                children: [
                  // Estadísticas
                  if (state is TasksLoaded && state.stats != null)
                    _buildStatsCard(state.stats!),

                  // Filtros
                  TaskFilterChips(
                    selectedFilter: _currentFilter,
                    onFilterChanged: (filter) {
                      setState(() {
                        _currentFilter = filter;
                      });
                    },
                    totalTasks: totalTasks,
                    completedTasks: completedTasks,
                    pendingTasks: pendingTasks,
                  ),

                  // Lista de tareas filtradas
                  Expanded(
                    child: filteredTasks.isEmpty
                        ? _buildEmptyFilterState()
                        : ListView.builder(
                            itemCount: filteredTasks.length,
                            itemBuilder: (context, index) {
                              final task = filteredTasks[index];
                              return TaskItem(
                                task: task,
                                onTap: () => _showEditTaskDialog(task),
                                onToggle: () {
                                  context.read<TasksBloc>().add(
                                        TaskToggleRequested(task.id),
                                      );
                                },
                                onDelete: () {
                                  _showDeleteConfirmation(task.id, task.title);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          }

          return _buildEmptyState();
        },
      ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showCreateTaskDialog,
          icon: const Icon(Icons.add),
          label: const Text('Nueva Tarea'),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 100, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No hay tareas',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'Crea tu primera tarea',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFilterState() {
    String message;
    IconData icon;

    switch (_currentFilter) {
      case TaskFilter.completed:
        message = 'No hay tareas completadas';
        icon = Icons.check_circle_outline;
        break;
      case TaskFilter.pending:
        message = 'No hay tareas pendientes';
        icon = Icons.pending_actions_outlined;
        break;
      case TaskFilter.all:
        return _buildEmptyState();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(Map<String, int> stats) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              'Total',
              stats['total']!,
              Icons.list_alt,
              Colors.blue,
            ),
            _buildStatItem(
              'Completadas',
              stats['completed']!,
              Icons.check_circle,
              Colors.green,
            ),
            _buildStatItem(
              'Pendientes',
              stats['pending']!,
              Icons.pending,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value.toString(),
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
