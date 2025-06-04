import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/edit_task_dialog.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      color: task.isCompleted
          ? colorScheme.surfaceContainerHighest
          : colorScheme.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          provider.toggleTaskCompletion(task.id);
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            leading: Checkbox(
              shape: const CircleBorder(),
              value: task.isCompleted,
              onChanged: (_) {
                provider.toggleTaskCompletion(task.id);
              },
            ),
            title: Text(
              task.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                color: task.isCompleted
                    ? colorScheme.onSurfaceVariant.withOpacity(0.7)
                    : colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              task.description,
              style: TextStyle(
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                color: task.isCompleted
                    ? colorScheme.onSurfaceVariant.withOpacity(0.7)
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: PopupMenuButton(
              icon: Icon(
                Icons.more_vert,
                color: colorScheme.onSurfaceVariant,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'toggle',
                  child: ListTile(
                    leading: Icon(
                      task.isCompleted ? Icons.refresh : Icons.check,
                      color: colorScheme.primary,
                    ),
                    title: Text(
                      task.isCompleted ? 'Marcar como pendiente' : 'Completar tarea',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(
                      Icons.edit,
                      color: colorScheme.primary,
                    ),
                    title: Text(
                      'Editar',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(
                      Icons.delete,
                      color: colorScheme.error,
                    ),
                    title: Text(
                      'Eliminar',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'toggle') {
                  provider.toggleTaskCompletion(task.id);
                } else if (value == 'edit') {
                  showDialog(
                    context: context,
                    builder: (context) => EditTaskDialog(task: task),
                  );
                } else if (value == 'delete') {
                  provider.deleteTask(task.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Tarea eliminada',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      action: SnackBarAction(
                        label: 'DESHACER',
                        textColor: Colors.white,
                        onPressed: () {
                          provider.addTask(task.title, task.description);
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}