import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_force/domain/user_registration_domain.dart';

class UserRegistrationNotifier extends StateNotifier<UserRegistrationData> {
  UserRegistrationNotifier() : super(UserRegistrationData());

  void updateBasicData(
      String email, String name, String password, String birthdate) {
    state = UserRegistrationData(
      email: email,
      name: name,
      password: password,
      birthdate: birthdate,
      address: state.address,
      gender: state.gender,
      dni: state.dni,
      phone: state.phone,
      emergencyPhone: state.emergencyPhone,
      documentPhotoPath: state.documentPhotoPath,
      selfiePhotoPath: state.selfiePhotoPath,
    );
  }

  void updateExtraData(String address, String gender, String dni, String phone,
      String emergencyPhone) {
    state = UserRegistrationData(
      email: state.email,
      name: state.name,
      password: state.password,
      birthdate: state.birthdate,
      address: address,
      gender: gender,
      dni: dni,
      phone: phone,
      emergencyPhone: emergencyPhone,
      documentPhotoPath: state.documentPhotoPath,
      selfiePhotoPath: state.selfiePhotoPath,
    );
  }

  void updateDniPhotoPath(File photo) {
    state = UserRegistrationData(
      email: state.email,
      name: state.name,
      password: state.password,
      birthdate: state.birthdate,
      address: state.address,
      gender: state.gender,
      dni: state.dni,
      phone: state.phone,
      emergencyPhone: state.emergencyPhone,
      documentPhotoPath: photo,
      selfiePhotoPath: state.selfiePhotoPath,
    );
  }
}

final userRegistrationProvider =
    StateNotifierProvider<UserRegistrationNotifier, UserRegistrationData>(
        (ref) => UserRegistrationNotifier());
