import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_force/domain/user_state_domain.dart';

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState.empty());

  void setUser({
    required String uid,
    required String email,
    required String name,
    required String birthdate,
    required String address,
    required String gender,
    required String phone,
    required String emergencyPhone,
  }) {
    state = UserState(
      uid: uid,
      email: email,
      name: name,
      birthdate: birthdate,
      address: address,
      gender: gender,
      phone: phone,
      emergencyPhone: emergencyPhone,
    );
  }

  // void logOut() {
  //   state = UserState.empty();
  // }
  Future<void> logOut() async {
    try {
      // Cerrar sesión en Firebase
      await FirebaseAuth.instance.signOut();

      // Limpiar el estado del usuario en la app
      state = UserState.empty();
    } catch (e) {
      // Manejar errores de logout si es necesario
      print("Error al cerrar sesión: $e");
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
