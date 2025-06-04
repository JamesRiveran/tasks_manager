import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/DataBaseHelper.dart';
import '../providers/task_provider.dart';
import 'main_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final user = await DatabaseHelper.instance.authenticate(email, password);
    if (user != null) {
      Provider.of<TaskProvider>(context, listen: false).setActiveUser(user);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correo o contraseña inválidos')),
      );
    }
  }

  void _goToRegister() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Correo')),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Contraseña'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('Entrar')),
            TextButton(onPressed: _goToRegister, child: const Text('¿No tienes cuenta? Regístrate')),
          ],
        ),
      ),
    );
  }
}
