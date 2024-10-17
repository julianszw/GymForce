import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_force/config/providers/user_provider.dart';
import 'package:gym_force/services/auth_services.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _isEmailValid = email.isNotEmpty;
      _isPasswordValid = password.isNotEmpty;
    });

    if (_isEmailValid && _isPasswordValid) {
      try {
        setState(() {
          _isLoading = true;
        });
        UserCredential userCredential =
            await _authService.loginUser(email, password);

        String uid = userCredential.user!.uid;

        DocumentSnapshot userDoc = await _authService.getUserData(uid);

        if (userDoc.exists) {
          ref.read(userProvider.notifier).setUser(
                uid: uid,
                email: email,
                name: userDoc['name'],
                birthdate: userDoc['birthdate'],
                address: userDoc['address'],
                gender: userDoc['gender'],
                phone: userDoc['phone'],
                emergencyPhone: userDoc['emergencyPhone'],
              );

          GoRouter.of(context).go('/');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('No se encontraron datos del usuario')),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de autenticación: ${e.message}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
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
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                errorText: _isPasswordValid
                    ? null
                    : 'Por favor, ingrese su contraseña',
              ),
            ),
            const SizedBox(height: 40),
            TextButton(
                onPressed: () {
                  context.push('/register');
                },
                child: const Text('Registrate')),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text('Entrar'),
                  ),
          ],
        ),
      ),
    );
  }
}
