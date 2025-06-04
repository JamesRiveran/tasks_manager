import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/DataBaseHelper.dart';
import '../models/user.dart';
import '../providers/task_provider.dart';
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
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 64,
              backgroundColor: colorScheme.primary.withOpacity(0.2),
              child: Icon(
                Icons.person,
                size: 64,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Usuario',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              user.email,
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
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
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Acciones',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: Icon(Icons.switch_account, color: colorScheme.primary),
                      title: const Text('Cambiar de usuario'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () async {
                        final users = await DatabaseHelper.instance.getAllUsers();
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (_) => SimpleDialog(
                              title: const Text('Seleccionar usuario'),
                              children: users.map<Widget>((User u) {
                                  return SimpleDialogOption(
                                    onPressed: () {
                                      Provider.of<TaskProvider>(context, listen: false).setActiveUser(u);
                                      Navigator.pop(context);
                                    },
                                    child: Text(u.email),
                                  );
                                }).toList(),
                            ),
                          );
                        }
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout, color: colorScheme.error),
                      title: Text(
                        'Cerrar sesión',
                        style: TextStyle(color: colorScheme.error),
                      ),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
