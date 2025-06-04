import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'providers/task_provider.dart';
import 'providers/theme_provider.dart' as tp;
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await deleteDatabaseManually(); //eliminar
  runApp(const MyApp());
}

Future<void> deleteDatabaseManually() async {
  final dbPath = path.join(await getDatabasesPath(), "tasks_database.db");
  await deleteDatabase(dbPath);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer? _themeTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final themeProvider = Provider.of<tp.ThemeProvider>(context, listen: false);
      themeProvider.checkTimeBasedTheme();

      _themeTimer = Timer.periodic(const Duration(minutes: 1), (_) {
        if (mounted) {
          themeProvider.checkTimeBasedTheme();
        }
      });
    });
  }

  @override
  void dispose() {
    _themeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => tp.ThemeProvider()),
      ],
      child: Consumer<tp.ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Tareas',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}
