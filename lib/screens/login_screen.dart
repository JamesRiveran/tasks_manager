import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/DataBaseHelper.dart';
import '../providers/user_provider.dart';
import '../providers/task_provider.dart';
import 'main_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _passwordVisible = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack));
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Ingresa tu correo';
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,4}$').hasMatch(value)) return 'Correo inválido';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Ingresa tu contraseña';
    return null;
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = await DatabaseHelper.instance.authenticate(email, password);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (user != null) {
      userProvider.setActiveUser(user);
      Provider.of<TaskProvider>(context, listen: false).setActiveUser(user);
      userProvider.addUserToSharedPreferences(user);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correo o contraseña incorrectos')),
      );
    }
  }

  void _goToRegister() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 80),
                  Icon(Icons.task_alt, size: 64, color: colorScheme.primary),
                  const SizedBox(height: 16),
                  Text('Bienvenido', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text('Inicia sesión para continuar', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 32),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                          decoration: const InputDecoration(
                            labelText: 'Correo Electrónico',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          validator: _validatePassword,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(_passwordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() => _passwordVisible = !_passwordVisible);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const CircularProgressIndicator(strokeWidth: 2)
                        : const Text('Iniciar Sesión'),
                  ),

                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: _isLoading ? null : _goToRegister,
                    child: const Text('Crear una cuenta'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
