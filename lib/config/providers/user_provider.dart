import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_force/domain/user_state_domain.dart';

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState(email: '', isLoggedIn: false));

  void setEmail(String newEmail) {
    state = UserState(email: newEmail, isLoggedIn: true);
  }

  void logOut() {
    state = UserState(email: '', isLoggedIn: false);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
