import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../database/DataBaseHelper.dart';
import '../models/user.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = Provider.of<TaskProvider>(context).activeUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No hay usuario activo')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: colorScheme.primary.withOpacity(0.15),
                  child: Icon(Icons.person, size: 48, color: colorScheme.primary),
                ),
                const SizedBox(height: 12),
                Text(
                  'Usuario',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Información',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          )),
                  const SizedBox(height: 16),
                  _buildInfoItem(context, 'Nombre completo', 'Usuario de Prueba'),
                  const Divider(),
                  _buildInfoItem(context, 'Correo', user.email),
                  const Divider(),
                  _buildInfoItem(context, 'ID de Usuario', user.id),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 1,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.switch_account, color: colorScheme.primary),
                  title: const Text('Cambiar de usuario'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () async {
                    final users = await DatabaseHelper.instance.getAllUsers();
                    if (!context.mounted) return;
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          title: const Text('Seleccionar usuario'),
                          children: users.map((u) {
                            return SimpleDialogOption(
                              onPressed: () {
                                Provider.of<TaskProvider>(context, listen: false)
                                    .setActiveUser(u);
                                Navigator.pop(context);
                              },
                              child: Text(u.email),
                            );
                          }).toList(),
                        );
                      },
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.logout, color: colorScheme.error),
                  title: Text('Cerrar sesión', style: TextStyle(color: colorScheme.error)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Provider.of<TaskProvider>(context, listen: false).setActiveUser(null);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  )),
          const SizedBox(height: 4),
          Text(value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  )),
        ],
      ),
    );
  }
}
