class UserState {
  final String uid;
  final String email;
  final String name;
  final String birthdate;
  final String address;
  final String gender;
  final String phone;
  final String emergencyPhone;

  UserState({
    required this.uid,
    required this.email,
    required this.name,
    required this.birthdate,
    required this.address,
    required this.gender,
    required this.phone,
    required this.emergencyPhone,
  });

  // Estado vacío por defecto
  UserState.empty()
      : uid = '',
        email = '',
        name = '',
        birthdate = '',
        address = '',
        gender = '',
        phone = '',
        emergencyPhone = '';

  bool get isLoggedIn => uid.isNotEmpty;
}
