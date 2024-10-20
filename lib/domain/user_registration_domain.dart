import 'dart:io';

class UserRegistrationData {
  String? email;
  String? name;
  String? password;
  String? birthdate;
  String? address;
  String? gender;
  String? dni;
  String? phone;
  String? emergencyPhone;
  File? documentPhotoPath;
  String? selfiePhotoPath;

  UserRegistrationData({
    this.email,
    this.name,
    this.password,
    this.birthdate,
    this.address,
    this.gender,
    this.dni,
    this.phone,
    this.emergencyPhone,
    this.documentPhotoPath,
    this.selfiePhotoPath,
  });
}
