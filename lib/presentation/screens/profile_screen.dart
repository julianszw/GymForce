import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_force/config/providers/user_provider.dart';
import 'package:gym_force/main.dart';
import 'package:gym_force/presentation/widgets/navigation/drawer_nav_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_force/utils/validators.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Importación necesaria

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState<ProfileScreen> {
  String? selectedGender;
  bool _isLoading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emergencyPhoneController = TextEditingController();

  bool _isNameValid = true;
  bool _isBirthDateValid = true;
  bool _isAddressValid = true;
  bool _isPhoneValid = true;
  bool _isEmergencyPhoneValid = true;
  bool _isEmerencyPhoneNotEqual = true;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting(
        'es', null); // Inicializa los datos de fecha para español
    final user = ref.read(userProvider);
    nameController.text = user.name;
    birthdateController.text = user.birthdate ?? '';
    addressController.text = user.address ?? '';
    phoneController.text = user.phone ?? '';
    emergencyPhoneController.text = user.emergencyPhone ?? '';
    selectedGender = (user.gender?.isEmpty ?? true) ? null : user.gender;
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        birthdateController.text =
            DateFormat("d 'de' MMMM 'del' y", 'es').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('¡Bienvenido, ${user.name}!'),
      ),
      drawer: const DrawerNavMenu(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 118),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        (user.profile != null && user.profile!.isNotEmpty)
                            ? NetworkImage(user.profile!)
                            : const AssetImage('assets/profile_picture.jpg')
                                as ImageProvider,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isNameValid = validateName(nameController.text);
                          _isBirthDateValid =
                              validateAge(birthdateController.text);
                          _isAddressValid =
                              validateAddress(addressController.text);
                          _isPhoneValid =
                              validatePhoneNumber(phoneController.text);
                          _isEmergencyPhoneValid = validatePhoneNumber(
                              emergencyPhoneController.text);
                          _isEmerencyPhoneNotEqual = phoneController.text !=
                              emergencyPhoneController.text;
                        });

                        if (!_isNameValid ||
                            !_isBirthDateValid ||
                            !_isAddressValid ||
                            !_isPhoneValid ||
                            !_isEmergencyPhoneValid ||
                            !_isEmerencyPhoneNotEqual) {
                          return;
                        }
                        try {
                          setState(() {
                            _isLoading = true;
                          });
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .update({
                            'name': nameController.text,
                            'birthdate': birthdateController.text,
                            'address': addressController.text,
                            'gender': selectedGender,
                            'phone': phoneController.text,
                            'emergencyPhone': emergencyPhoneController.text,
                            'profile': user.profile,
                          });

                          ref.read(userProvider.notifier).setUser(
                                uid: user.uid,
                                email: user.email,
                                name: nameController.text,
                                role: user.role,
                                birthdate: birthdateController.text,
                                address: addressController.text,
                                gender: selectedGender,
                                phone: phoneController.text,
                                emergencyPhone: emergencyPhoneController.text,
                                profile: user.profile,
                              );

                          scaffoldMessengerKey.currentState?.showSnackBar(
                            const SnackBar(
                              content: Text('Perfil actualizado correctamente'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } on FirebaseException catch (e) {
                          scaffoldMessengerKey.currentState?.showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Error al actualizar el perfil: ${e.message}'),
                            ),
                          );
                        } catch (e) {
                          scaffoldMessengerKey.currentState?.showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Error inesperado al actualizar el perfil: $e'),
                            ),
                          );
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.yellow,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Aplicar cambios'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _ProfileTextField(
                    label: 'Nombre y Apellido',
                    hint: user.name,
                    controller: nameController,
                    errorText: 'Ingrese nombre y apellido váldios',
                    isFieldValid: _isNameValid,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Fecha de nacimiento',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        TextField(
                          controller: birthdateController,
                          style: const TextStyle(color: Colors.black),
                          readOnly: true,
                          onTap: _selectDate,
                          decoration: InputDecoration(
                            hintText: 'Seleccionar fecha',
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorText: _isBirthDateValid
                                ? null
                                : 'Por favor, ingrese una fecha de nacmiento válida',
                          ),
                        ),
                      ],
                    ),
                  ),
                  _ProfileTextField(
                    label: 'Domicilio',
                    hint: user.address ?? '',
                    controller: addressController,
                    isFieldValid: _isAddressValid,
                    errorText: 'Ingrese una dirección válida',
                  ),
                  _ProfileTextField(
                    label: 'Número de teléfono',
                    hint: user.phone ?? '',
                    controller: phoneController,
                    errorText: 'Ingrese un número válido (ej: 1123889412)',
                    isFieldValid: _isPhoneValid,
                  ),
                  _ProfileTextField(
                    label: 'Número en caso de emergencia',
                    hint: user.emergencyPhone ?? '',
                    controller: emergencyPhoneController,
                    errorText: !_isEmergencyPhoneValid
                        ? 'Ingrese un número válido (ej: 1123889412)'
                        : 'Ingrese un número distinto al tuyo',
                    isFieldValid:
                        _isEmergencyPhoneValid && _isEmerencyPhoneNotEqual,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Género',
                            style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: DropdownButton<String>(
                            value: selectedGender,
                            isExpanded: true,
                            underline: const SizedBox(),
                            items: <String>['Masculino', 'Femenino', 'Otro']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedGender = newValue!;
                              });
                            },
                            dropdownColor: Colors.white,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isFieldValid;
  final String errorText;

  const _ProfileTextField(
      {required this.label,
      required this.hint,
      required this.controller,
      required this.isFieldValid,
      required this.errorText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              errorText: isFieldValid ? null : errorText,
            ),
          ),
        ],
      ),
    );
  }
}
