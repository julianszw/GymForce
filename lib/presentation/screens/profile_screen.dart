import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_force/config/providers/user_provider.dart';
import 'package:gym_force/presentation/widgets/navigation/drawer_nav_menu.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String selectedGender = 'Masculino'; // Valor predeterminado

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('¡Bienvenido, ${user?.name ?? 'Usuario'}!'),
      ),
      drawer: const DrawerNavMenu(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Foto de perfil
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(user?.profile ?? 'assets/profile_picture.jpg'), // Cambia a la imagen deseada
            ),
            const SizedBox(height: 16),

            // Botón "Aplicar cambios"
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Aplicar cambios'),
            ),
            const SizedBox(height: 16),

            // Campo "Nombre y Apellido"
            _ProfileTextField(label: 'Nombre y Apellido', hint: user?.name ?? ''),

            // Selector de género
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sexo',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _GenderButton(
                      label: 'Masculino',
                      isSelected: selectedGender == 'Masculino',
                      onTap: () {
                        setState(() {
                          selectedGender = 'Masculino';
                        });
                      },
                    ),
                    _GenderButton(
                      label: 'Femenino',
                      isSelected: selectedGender == 'Femenino',
                      onTap: () {
                        setState(() {
                          selectedGender = 'Femenino';
                        });
                      },
                    ),
                    _GenderButton(
                      label: 'Otro',
                      isSelected: selectedGender == 'Otro',
                      onTap: () {
                        setState(() {
                          selectedGender = 'Otro';
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),

            // Campo "Fecha de nacimiento"
            _ProfileTextField(label: 'Fecha de nacimiento', hint: user?.birthdate ?? '09/03/2005'),

            // Campo "Domicilio"
            _ProfileTextField(label: 'Domicilio', hint: user?.address ?? 'Av. Corrientes 2553'),

            // Campo "Número de teléfono"
            _ProfileTextField(label: 'Número de teléfono', hint: user?.phone ?? '54 9 11 2482-3758'),

            // Campo "Número en caso de emergencia"
            _ProfileTextField(label: 'Número en caso de emergencia', hint: user?.emergencyPhone ?? '54 9 11 2482-3758'),

            // Botón "Deseo cambiar mi contraseña"
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: Colors.yellow,
              ),
              child: const Text('Deseo cambiar mi contraseña'),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget personalizado para campos de texto
class _ProfileTextField extends StatelessWidget {
  final String label;
  final String hint;

  const _ProfileTextField({required this.label, required this.hint});

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
            decoration: InputDecoration(
              hintText: hint,
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

// Widget personalizado para los botones de género
class _GenderButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black, backgroundColor: isSelected ? Colors.yellow : Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(label),
    );
  }
}
