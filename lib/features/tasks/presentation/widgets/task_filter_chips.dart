import 'package:flutter/material.dart';

enum TaskFilter { all, completed, pending }

class TaskFilterChips extends StatelessWidget {
  final TaskFilter selectedFilter;
  final Function(TaskFilter) onFilterChanged;
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;

  const TaskFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              context: context,
              label: 'Todas',
              count: totalTasks,
              filter: TaskFilter.all,
              icon: Icons.list_alt,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              context: context,
              label: 'Completadas',
              count: completedTasks,
              filter: TaskFilter.completed,
              icon: Icons.check_circle,
              color: Colors.green,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              context: context,
              label: 'Pendientes',
              count: pendingTasks,
              filter: TaskFilter.pending,
              icon: Icons.pending_actions,
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required int count,
    required TaskFilter filter,
    required IconData icon,
    Color? color,
  }) {
    final isSelected = selectedFilter == filter;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: isSelected ? Colors.white : color),
          const SizedBox(width: 6),
          Text('$label ($count)'),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onFilterChanged(filter),
      selectedColor: color ?? Theme.of(context).colorScheme.primary,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : null,
      ),
    );
  }
}

