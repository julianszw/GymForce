import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> loginUser(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Usuario no encontrado.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Contraseña incorrecta.');
      } else {
        throw Exception('Error al iniciar sesión.');
      }
    } catch (e) {
      throw Exception('Error inesperado al iniciar sesión.');
    }
  }

  Future<UserCredential?> registerUser(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('El correo electrónico ya está registrado.');
      } else if (e.code == 'weak-password') {
        throw Exception('La contraseña es demasiado débil.');
      } else {
        throw Exception('Error al registrar el usuario.');
      }
    } catch (e) {
      throw Exception('Error inesperado al registrar el usuario.');
    }
  }

  Future<void> saveUserData(
      UserCredential userCredential, Map<String, dynamic> userData) async {
    try {
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userData);
    } catch (e) {
      throw Exception('Error al guardar los datos del usuario.');
    }
  }

  Future<DocumentSnapshot?> getUserData(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        return userDoc;
      }

      DocumentSnapshot employeeDoc =
          await _firestore.collection('employees').doc(uid).get();

      if (employeeDoc.exists) {
        return employeeDoc;
      }

      return null;
    } catch (e) {
      throw Exception('Error al obtener los datos del usuario.');
    }
  }

  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final profilePicRef = storageRef.child(
          "users/profile_pics/${DateTime.now().millisecondsSinceEpoch}.jpg");

      await profilePicRef.putFile(imageFile);

      final downloadUrl = await profilePicRef.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Error al subir la imagen a Firebase.');
    }
  }
}
