import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> loginUser(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> registerUser(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> saveUserData(
      UserCredential userCredential, Map<String, dynamic> userData) async {
    return await _firestore
        .collection('users')
        .doc(userCredential.user!.uid)
        .set(userData);
  }

  Future<DocumentSnapshot?> getUserData(String uid) async {
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
  }
}
