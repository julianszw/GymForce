class UserState {
  final String email;
  final bool isLoggedIn; // Agregamos el estado de autenticación

  UserState({required this.email, this.isLoggedIn = false});
}
