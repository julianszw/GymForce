class UserState {
  final String uid;
  final String email;
  final String name;
  final String? birthdate;
  final String? address;
  final String? gender;
  final String? phone;
  final String? emergencyPhone;
  final String role;

  UserState({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.birthdate,
    this.address,
    this.gender,
    this.phone,
    this.emergencyPhone,
  });

  // Estado vacío por defecto
  UserState.empty()
      : uid = '',
        email = '',
        name = '',
        role = '',
        birthdate = null,
        address = null,
        gender = null,
        phone = null,
        emergencyPhone = null;

  bool get isLoggedIn => uid.isNotEmpty;
}
