import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_force/presentation/screens/login_screen.dart';
import 'package:gym_force/services/auth_services.dart';

class RegisterSubmitScreen extends StatefulWidget {
  final String email;
  final String name;
  final String password;
  final String birthdate;

  const RegisterSubmitScreen({
    super.key,
    required this.email,
    required this.name,
    required this.password,
    required this.birthdate,
  });

  @override
  _RegisterSubmitScreenState createState() => _RegisterSubmitScreenState();
}

class _RegisterSubmitScreenState extends State<RegisterSubmitScreen> {
  bool _isLoading = false;
  final _addressController = TextEditingController();
  final _genderController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final AuthService _authService = AuthService();

  void registerUser() async {
    String address = _addressController.text;
    String gender = _genderController.text;
    String phone = _phoneController.text;
    String emergencyPhone = _emergencyPhoneController.text;

    if (address.isEmpty ||
        gender.isEmpty ||
        phone.isEmpty ||
        emergencyPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });
      UserCredential userCredential = await _authService.registerUser(
        widget.email,
        widget.password,
      );

      await _authService.saveUserData(userCredential, {
        'email': widget.email,
        'name': widget.name,
        'birthdate': widget.birthdate,
        'address': address,
        'gender': gender,
        'phone': phone,
        'emergencyPhone': emergencyPhone,
        'role': 'user'
      });

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } on FirebaseAuthException catch (e) {
      String message = 'Error al registrar el usuario';
      if (e.code == 'weak-password') {
        message = 'La contraseña es demasiado débil.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Ya hay una cuenta registrada con este email.';
      } else {
        message = e.message ?? message;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('¡Ingresa tus datos!')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Domicilio'),
            ),
            TextField(
              controller: _genderController,
              decoration: const InputDecoration(labelText: 'Sexo'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Número de Celular'),
            ),
            TextField(
              controller: _emergencyPhoneController,
              decoration:
                  const InputDecoration(labelText: 'Número de Emergencia'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                    ),
                    child: const Text('Crear usuario'),
                  ),
          ],
        ),
      ),
    );
  }
}
