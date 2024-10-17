import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_force/presentation/screens/login_screen.dart';

class RegisterSubmitScreen extends StatefulWidget {
  final String email;
  final String name;
  final String password;
  final String birthdate;

  RegisterSubmitScreen({
    required this.email,
    required this.name,
    required this.password,
    required this.birthdate,
  });

  @override
  _RegisterSubmitScreenState createState() => _RegisterSubmitScreenState();
}

class _RegisterSubmitScreenState extends State<RegisterSubmitScreen> {
  final _addressController = TextEditingController();
  final _genderController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void registerUser() async {
    String address = _addressController.text;
    String gender = _genderController.text;
    String phone = _phoneController.text;
    String emergencyPhone = _emergencyPhoneController.text;

    // Validación de campos
    if (address.isEmpty ||
        gender.isEmpty ||
        phone.isEmpty ||
        emergencyPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    try {
      // Crear el usuario en Firebase Auth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      );

      // Agregar el usuario a Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': widget.email,
        'name': widget.name,
        'birthdate': widget.birthdate,
        'address': address,
        'gender': gender,
        'phone': phone,
        'emergencyPhone': emergencyPhone,
      });

      // Redirigir a la pantalla de inicio o login
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  LoginScreen())); // Reemplaza con la pantalla deseada
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('¡Ingresa tus datos!')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Domicilio'),
            ),
            TextField(
              controller: _genderController,
              decoration: InputDecoration(labelText: 'Sexo'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Número de Celular'),
            ),
            TextField(
              controller: _emergencyPhoneController,
              decoration: InputDecoration(labelText: 'Número de Emergencia'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: registerUser,
              child: Text('Crear usuario'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
