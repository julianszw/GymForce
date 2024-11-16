import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_force/config/providers/user_provider.dart';
import 'package:gym_force/domain/user_state_domain.dart';
import 'package:gym_force/presentation/widgets/navigation/drawer_nav_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String? selectedGender;

  TextEditingController nameController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emergencyPhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    nameController.text = user.name ?? '';
    birthdateController.text = user.birthdate ?? '';
    addressController.text = user.address ?? '';
    phoneController.text = user.phone ?? '';
    emergencyPhoneController.text = user.emergencyPhone ?? '';
    selectedGender = (user.gender?.isEmpty ?? true) ? null : user.gender;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('¡Bienvenido, ${user.name ?? 'Usuario'}!'),
      ),
      drawer: const DrawerNavMenu(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: (user.profile != null && user.profile!.isNotEmpty)
                  ? NetworkImage(user.profile!)
                  : AssetImage('assets/profile_picture.jpg') as ImageProvider,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (user.uid != null) {
                    ref.read(userProvider.notifier).setUser(
                      uid: user.uid!,
                      email: user.email,
                      name: nameController.text,
                      role: user.role!,
                      birthdate: birthdateController.text,
                      address: addressController.text,
                      gender: selectedGender,
                      phone: phoneController.text,
                      emergencyPhone: emergencyPhoneController.text,
                      profile: user.profile,
                    );

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
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Aplicar cambios'),
              ),
            ),
            const SizedBox(height: 16),
            _ProfileTextField(label: 'Nombre y Apellido', hint: user.name ?? '', controller: nameController),
            _ProfileTextField(label: 'Fecha de nacimiento', hint: user.birthdate ?? '09/03/2005', controller: birthdateController),
            _ProfileTextField(label: 'Domicilio', hint: user.address ?? 'Av. Corrientes 2553', controller: addressController),
            _ProfileTextField(label: 'Número de teléfono', hint: user.phone ?? '54 9 11 2482-3758', controller: phoneController),
            _ProfileTextField(label: 'Número en caso de emergencia', hint: user.emergencyPhone ?? '54 9 11 2482-3758', controller: emergencyPhoneController),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Género', style: TextStyle(color: Colors.white)),
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
                    underline: SizedBox(),
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

  const _ProfileTextField({required this.label, required this.hint, required this.controller});

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
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
