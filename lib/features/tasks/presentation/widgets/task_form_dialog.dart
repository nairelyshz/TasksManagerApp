import 'package:flutter/material.dart';
import '../../../../core/models/task_model.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';

class TaskFormDialog extends StatefulWidget {
  final TaskModel? task;

  const TaskFormDialog({super.key, this.task});

  @override
  State<TaskFormDialog> createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late bool _completed;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _completed = widget.task?.completed ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'completed': _completed,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 500),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título del dialog
              Text(
                isEditing ? 'Editar Tarea' : 'Nueva Tarea',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),

              // Campo Título
              CustomTextField(
                controller: _titleController,
                label: 'Título',
                hint: 'Ingrese el título de la tarea',
                prefixIcon: const Icon(Icons.title),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El título es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Descripción
              CustomTextField(
                controller: _descriptionController,
                label: 'Descripción (opcional)',
                hint: 'Ingrese una descripción',
                prefixIcon: const Icon(Icons.description),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Checkbox completado (solo en edición)
              if (isEditing)
                CheckboxListTile(
                  title: const Text('Tarea completada'),
                  value: _completed,
                  onChanged: (value) {
                    setState(() {
                      _completed = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),

              const SizedBox(height: 24),

              // Botones
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
                  CustomButton(
                    text: isEditing ? 'Guardar' : 'Crear',
                    onPressed: _handleSave,
                    icon: isEditing ? Icons.save : Icons.add,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
