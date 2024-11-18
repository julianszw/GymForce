import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_force/config/providers/payment_provider.dart';
import 'package:gym_force/config/providers/user_provider.dart';
import 'package:gym_force/config/providers/workout_provider.dart';
import 'package:gym_force/domain/workout_domain.dart';
import 'package:gym_force/services/auth_services.dart';
import 'package:gym_force/services/payment_service.dart';
import 'package:gym_force/services/workout_services.dart';
import 'package:gym_force/utils/validators.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final userState = ref.watch(userProvider);
    final paymentState = ref.read(paymentProvider.notifier);
    final workoutState = ref.read(workoutProvider.notifier);

    setState(() {
      _isEmailValid = validateEmail(email);
      _isPasswordValid = validatePassword(password);
    });

    if (_isEmailValid && _isPasswordValid) {
      try {
        setState(() {
          _isLoading = true;
        });
        UserCredential? userCredential =
            await _authService.loginUser(email, password);

        String? uid = userCredential?.user!.uid;

        DocumentSnapshot? userDoc = await _authService.getUserData(uid!);
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
                  profile: userDoc['profile'],
                  role: role,
                );

            List<Map<String, dynamic>> workoutsData =
                await WorkoutService().getUserWorkouts();

            List<Workout> workouts =
                workoutsData.map((data) => Workout.fromJson(data)).toList();

            workoutState.setWorkouts(workouts);

            final payment = await PaymentService().getLatestPaymentForUser(uid);

            if (payment != null) {
              paymentState.setPayment(
                  amount: payment['amount'],
                  date: payment['date'],
                  duration: payment['duration'],
                  title: payment['title'],
                  transactionId: payment['transactionId'],
                  userId: payment['userId'],
                  expirationDate: payment['expirationDate']);
            }
            if (mounted) {
              context.go('/');
              await Future.delayed(const Duration(milliseconds: 200));
            }
          } else if (role == 'employee') {
            ref.read(userProvider.notifier).setUser(
                  uid: uid,
                  email: email,
                  name: userDoc['name'],
                  role: role,
                );
            if (mounted) {
              context.go('/help');
              await Future.delayed(const Duration(milliseconds: 200));
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('No se encontraron datos del usuario')),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message ?? 'Error de autenticación: ${e.code}'),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error inesperado: $e'),
            ),
          );
        }
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
                                fontWeight: FontWeight.bold),
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
