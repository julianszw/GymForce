import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_force/domain/user_state_domain.dart';

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState.empty());

  void setUser(
      {required String uid,
      required String email,
      required String name,
      required String role,
      String? birthdate,
      String? address,
      String? gender,
      String? phone,
      String? emergencyPhone,
      String? profile}) {
    state = UserState(
        uid: uid,
        email: email,
        name: name,
        birthdate: birthdate,
        address: address,
        gender: gender,
        phone: phone,
        emergencyPhone: emergencyPhone,
        profile: profile,
        role: role);
  }

  Future<void> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      state = UserState.empty();
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
