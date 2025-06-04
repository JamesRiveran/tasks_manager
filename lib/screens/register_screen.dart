import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../database/DataBaseHelper.dart';
import '../models/user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) return;

    final user = User(
      id: const Uuid().v4(),
      email: email,
      password: password,
    );

    try {
      await DatabaseHelper.instance.insertUser(user);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correo ya registrado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Correo')),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Contraseña'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _register, child: const Text('Registrar')),
          ],
        ),
      ),
    );
  }
}
