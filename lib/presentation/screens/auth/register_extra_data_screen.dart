import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/config/providers/user_registration_provider.dart';
import 'package:gym_force/utils/validators.dart';

class RegisterExtraDataScreen extends ConsumerStatefulWidget {
  const RegisterExtraDataScreen({
    super.key,
  });

  @override
  RegisterExtraDataScreenState createState() => RegisterExtraDataScreenState();
}

class RegisterExtraDataScreenState
    extends ConsumerState<RegisterExtraDataScreen> {
  final _addressController = TextEditingController();
  String? gender;
  final _dniController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  bool _isAddressValid = true;
  bool _isGenderValid = true;
  bool _isDniValid = true;
  bool _isPhoneValid = true;
  bool _isEmergencyPhoneValid = true;

  void registerUser() async {
    final userRegistrationNotifier =
        ref.read(userRegistrationProvider.notifier);

    String address = _addressController.text;
    String phone = _phoneController.text;
    String emergencyPhone = _emergencyPhoneController.text;
    String dni = _dniController.text;

    setState(() {
      _isAddressValid = validateAddress(address);
      _isGenderValid = gender != null;
      _isDniValid = validateDNI(dni);
      _isPhoneValid = validatePhoneNumber(phone);
      _isEmergencyPhoneValid = validatePhoneNumber(emergencyPhone);
    });

    if (!_isAddressValid ||
        !_isDniValid ||
        !_isGenderValid ||
        !_isPhoneValid ||
        !_isEmergencyPhoneValid) {
      return;
    }

    try {
      userRegistrationNotifier.updateExtraData(
          address, gender!, dni, phone, emergencyPhone);
      context.push('/register_dni');
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
                        '¡Ingresa tus datos!',
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
                    controller: _addressController,
                    style: const TextStyle(
                        fontSize: 16, height: 1, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Domicilio',
                      errorText: _isAddressValid
                          ? null
                          : 'Por favor, ingrese un domicilio válido',
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    style: const TextStyle(
                        fontSize: 16, height: 1, color: Colors.black),
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10.0),
                        filled: true,
                        fillColor: Colors.white,
                        errorStyle: const TextStyle(color: Colors.red),
                        errorText: _isGenderValid
                            ? null
                            : 'Por favor, seleccione una opción'),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    value: gender,
                    hint: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Género',
                          style: TextStyle(
                            color: Colors.grey,
                          )),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Masculino',
                        child: Text('Masculino'),
                      ),
                      DropdownMenuItem(
                        value: 'Femenino',
                        child: Text('Femenino'),
                      ),
                      DropdownMenuItem(
                        value: 'Otro',
                        child: Text('Otro'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        gender = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _dniController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                        fontSize: 16, height: 1, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'DNI',
                      errorText: _isDniValid
                          ? null
                          : 'Por favor, ingrese un dni válido',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                        fontSize: 16, height: 1, color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Número de celular',
                      errorText: _isPhoneValid
                          ? null
                          : 'Por favor, ingrese un número de celular válido',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emergencyPhoneController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                        fontSize: 16, height: 1, color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Número en caso de emergencia',
                      errorText: _isEmergencyPhoneValid
                          ? null
                          : 'Por favor, ingrese un número de celular válido',
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: registerUser,
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
