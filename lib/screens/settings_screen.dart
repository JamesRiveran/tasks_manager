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
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tema',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    RadioListTile<app_theme.ThemeMode>(
                      title: const Text('Tema Claro'),
                      value: app_theme.ThemeMode.light,
                      groupValue: themeProvider.themeMode,
                      onChanged: (app_theme.ThemeMode? value) {
                        if (value != null) {
                          themeProvider.setThemeMode(value);
                        }
                      },
                      secondary: const Icon(Icons.light_mode),
                    ),
                    RadioListTile<app_theme.ThemeMode>(
                      title: const Text('Tema Oscuro'),
                      value: app_theme.ThemeMode.dark,
                      groupValue: themeProvider.themeMode,
                      onChanged: (app_theme.ThemeMode? value) {
                        if (value != null) {
                          themeProvider.setThemeMode(value);
                        }
                      },
                      secondary: const Icon(Icons.dark_mode),
                    ),
                    RadioListTile<app_theme.ThemeMode>(
                      title: const Text('Automático (según la hora)'),
                      subtitle: const Text('Oscuro de 6 PM a 6 AM'),
                      value: app_theme.ThemeMode.auto,
                      groupValue: themeProvider.themeMode,
                      onChanged: (app_theme.ThemeMode? value) {
                        if (value != null) {
                          themeProvider.setThemeMode(value);
                        }
                      },
                      secondary: const Icon(Icons.access_time),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Información',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Versión'),
                      subtitle: const Text('1.0.0'),
                      leading: Icon(Icons.info, color: colorScheme.primary),
                    ),
                    ListTile(
                      title: const Text('Desarrollado con Flutter'),
                      subtitle: const Text('Material Design 3'),
                      leading: Icon(Icons.code, color: colorScheme.primary),
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
}