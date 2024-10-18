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

  bool _validateEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _isEmailValid = _validateEmail(email);
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

        DocumentSnapshot? userDoc = await _authService.getUserData(uid);
        if (userDoc != null) {
          final role = userDoc['role'];
          if (role == 'user') {
            ref.read(userProvider.notifier).setUser(
                  uid: uid,
                  email: email,
                  name: userDoc['name'],
                  birthdate: userDoc['birthdate'],
                  address: userDoc['address'],
                  gender: userDoc['gender'],
                  phone: userDoc['phone'],
                  emergencyPhone: userDoc['emergencyPhone'],
                  role: role,
                );
            GoRouter.of(context).go('/');
          } else if (role == 'employee') {
            ref.read(userProvider.notifier).setUser(
                  uid: uid,
                  email: email,
                  name: userDoc['name'],
                  role: role,
                );
            GoRouter.of(context).go('/help');
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('No se encontraron datos del usuario')),
          );
        }
      } on FirebaseAuthException {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error de autenticación: credenciales inválidas'),
          ),
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
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: 325,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                const Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 80),
                TextField(
                  controller: _emailController,
                  style: const TextStyle(
                      fontSize: 16, height: 1, color: Colors.black),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    errorText: _isEmailValid
                        ? null
                        : 'Por favor, ingrese un email válido',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(
                      fontSize: 16, height: 1, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    errorText: _isPasswordValid
                        ? null
                        : 'Por favor, ingrese su contraseña',
                  ),
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _login,
                          child: const Text(
                            'Ingresar',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
