import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/edit_task_dialog.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      color: task.isCompleted
          ? colorScheme.surfaceContainerHighest
          : colorScheme.surface,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          provider.toggleTaskCompletion(task.id);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            leading: Checkbox(
              shape: const CircleBorder(),
              value: task.isCompleted,
              onChanged: (_) {
                provider.toggleTaskCompletion(task.id);
              },
              activeColor: colorScheme.primary,
            ),
            title: Text(
              task.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                color: task.isCompleted
                    ? colorScheme.onSurfaceVariant.withOpacity(0.6)
                    : colorScheme.onSurface,
              ),
            ),
            subtitle: task.description.isNotEmpty
                ? Text(
                    task.description,
                    style: TextStyle(
                      fontSize: 14,
                      decoration:
                          task.isCompleted ? TextDecoration.lineThrough : null,
                      color: task.isCompleted
                          ? colorScheme.onSurfaceVariant.withOpacity(0.5)
                          : colorScheme.onSurfaceVariant,
                    ),
                  )
                : null,
            trailing: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: colorScheme.onSurfaceVariant),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) {
                switch (value) {
                  case 'toggle':
                    provider.toggleTaskCompletion(task.id);
                    break;
                  case 'edit':
                    showDialog(
                      context: context,
                      builder: (_) => EditTaskDialog(task: task),
                    );
                    break;
                  case 'delete':
                    provider.deleteTask(task.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Tarea eliminada'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        action: SnackBarAction(
                          label: 'DESHACER',
                          textColor: Colors.white,
                          onPressed: () {
                            provider.addTask(task.title, task.description);
                          },
                        ),
                      ),
                    );
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'toggle',
                  child: ListTile(
                    leading: Icon(
                      task.isCompleted ? Icons.refresh : Icons.check,
                      color: colorScheme.primary,
                    ),
                    title: Text(
                      task.isCompleted
                          ? 'Marcar como pendiente'
                          : 'Completar tarea',
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit, color: colorScheme.primary),
                    title: const Text('Editar'),
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: colorScheme.error),
                    title: Text('Eliminar',
                        style: TextStyle(color: colorScheme.error)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
