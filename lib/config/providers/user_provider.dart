import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_force/domain/user_state_domain.dart';

// StateNotifier para manejar el estado del usuario
class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState(email: '', isLoggedIn: false));

  void setEmail(String newEmail) {
    state = UserState(
        email: newEmail,
        isLoggedIn: true); // Actualizamos el estado al loguearse
  }

  void logOut() {
    state = UserState(
        email: '', isLoggedIn: false); // Resetear el estado al cerrar sesión
  }
}

// Proveedor de estado para UserNotifier
final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
