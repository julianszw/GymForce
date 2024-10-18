import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:gym_force/presentation/screens/register_submit_screen.dart';
import 'package:gym_force/utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthdateController = TextEditingController();

  bool _isEmailValid = true;
  bool _isNameValid = true;
  bool _isPasswordValid = true;
  bool _isBirthDateValid = true;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es', null);
  }

  void goToNextScreen() {
    String email = _emailController.text;
    String name = _nameController.text;
    String password = _passwordController.text;
    String birthdate = _birthdateController.text;

    setState(() {
      _isEmailValid = validateEmail(email);
      _isNameValid = validateName(name);
      _isPasswordValid = validatePassword(password);
      _isBirthDateValid = birthdate.isNotEmpty;
    });

    if (!_isEmailValid ||
        !_isNameValid ||
        !_isPasswordValid ||
        !_isBirthDateValid) {
      return;
    }

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

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context, firstDate: DateTime(1950), lastDate: DateTime.now());

    if (picked != null) {
      setState(() {
        _birthdateController.text =
            DateFormat("d 'de' MMMM 'del' y", 'es').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: 325,
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¡Vamos a crear una cuenta!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
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
                    controller: _nameController,
                    style: const TextStyle(
                        fontSize: 16, height: 1, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Nombre y Apellido',
                      errorText: _isNameValid
                          ? null
                          : 'Por favor, ingrese nombre y apellido válidos',
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
                  TextField(
                    controller: _birthdateController,
                    style: const TextStyle(
                        fontSize: 16, height: 1, color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Fecha de nacimiento',
                      errorText: _isBirthDateValid
                          ? null
                          : 'Por favor, ingrese su fecha de nacimiento',
                    ),
                    readOnly: true,
                    onTap: () {
                      _selectDate();
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: goToNextScreen,
                      child: const Text(
                        'Siguiente',
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
      ),
    );
  }
}
