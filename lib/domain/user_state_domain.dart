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
  final String? profile;
  final String? barrioAsignado;

  UserState(
      {required this.uid,
      required this.email,
      required this.name,
      required this.role,
      this.birthdate,
      this.address,
      this.gender,
      this.phone,
      this.emergencyPhone,
      this.profile,
      this.barrioAsignado});

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
        emergencyPhone = null,
        profile = null,
        barrioAsignado = '';

  bool get isLoggedIn => uid.isNotEmpty;
}
