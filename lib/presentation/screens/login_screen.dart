import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/config/providers/user_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  // Cambiar a ConsumerStatefulWidget para manejo de estado
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isEmailValid = true;
  bool _isPasswordValid = true;

  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      // Validamos que el email y la contraseña no estén vacíos
      _isEmailValid = email.isNotEmpty;
      _isPasswordValid = password.isNotEmpty;
    });

    // Si ambos campos son válidos, procedemos a loguear al usuario
    if (_isEmailValid && _isPasswordValid) {
      ref.read(userProvider.notifier).setEmail(email);
      GoRouter.of(context).go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Input de email
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText:
                    _isEmailValid ? null : 'Por favor, ingrese un email válido',
              ),
            ),
            const SizedBox(height: 20),

            // Input de contraseña
            TextField(
              controller: _passwordController,
              obscureText: true, // Oculta el texto para las contraseñas
              decoration: InputDecoration(
                labelText: 'Contraseña',
                errorText: _isPasswordValid
                    ? null
                    : 'Por favor, ingrese su contraseña',
              ),
            ),
            const SizedBox(height: 40),

            // Botón de iniciar sesión
            ElevatedButton(
              onPressed:
                  _login, // Llama a la función de login al presionar el botón
              child: const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
