import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart' as app_theme;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<app_theme.ThemeProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Preferencias',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  RadioListTile<app_theme.ThemeMode>(
                    value: app_theme.ThemeMode.light,
                    groupValue: themeProvider.themeMode,
                    onChanged: (value) => themeProvider.setThemeMode(value!),
                    title: const Text('Tema Claro'),
                    secondary: const Icon(Icons.light_mode),
                  ),
                  RadioListTile<app_theme.ThemeMode>(
                    value: app_theme.ThemeMode.dark,
                    groupValue: themeProvider.themeMode,
                    onChanged: (value) => themeProvider.setThemeMode(value!),
                    title: const Text('Tema Oscuro'),
                    secondary: const Icon(Icons.dark_mode),
                  ),
                  RadioListTile<app_theme.ThemeMode>(
                    value: app_theme.ThemeMode.auto,
                    groupValue: themeProvider.themeMode,
                    onChanged: (value) => themeProvider.setThemeMode(value!),
                    title: const Text('Automático (según la hora)'),
                    subtitle: const Text('Oscuro de 6 PM a 6 AM'),
                    secondary: const Icon(Icons.access_time),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Información',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 1,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info_outline, color: colorScheme.primary),
                  title: const Text('Versión'),
                  subtitle: const Text('1.0.0'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.flutter_dash, color: colorScheme.primary),
                  title: const Text('Desarrollado con Flutter'),
                  subtitle: const Text('Material Design 3'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
