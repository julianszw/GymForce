import 'package:flutter/material.dart';
import 'package:gym_force/presentation/screens/register_submit_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthdateController = TextEditingController();

  void goToNextScreen() {
    String email = _emailController.text;
    String name = _nameController.text;
    String password = _passwordController.text;
    String birthdate = _birthdateController.text;

    // Validación simple
    if (email.isEmpty ||
        name.isEmpty ||
        password.isEmpty ||
        birthdate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    // Navegar a la segunda pantalla pasando los datos de la primera
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterSubmitScreen(
          email: email,
          name: name,
          password: password,
          birthdate: birthdate,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('¡Vamos a crear una cuenta!')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre y Apellido'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            TextField(
              controller: _birthdateController,
              decoration: InputDecoration(labelText: 'Fecha de Nacimiento'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: goToNextScreen,
              child: Text('Siguiente'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
            ),
          ],
        ),
      ),
    );
  }
}
