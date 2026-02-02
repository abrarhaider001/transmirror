import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transmirror/core/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:transmirror/core/utils/local_storage/storage_utility.dart';
import 'package:transmirror/model/user_model.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred;
    } on FirebaseAuthException catch (e) {
      throw MyFirebaseAuthException(e.code);
    }
  }

  Future<UserCredential> signupWithEmailPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = cred.user!.uid;
      final now = DateTime.now();
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('users').doc(uid).set({
        'fullName': fullName,
        'email': email,
        'createdAt': now,
        'profileImageUrl': '',
      });

      final userModel = UserModel(
        id: uid,
        fullName: fullName,
        email: email,
        profileImageUrl: '',
        createdAt: now,
        deviceTokens: [],
      );
      await MyLocalStorage.instance().writeData('user', userModel.toJson());
      return cred;
    } on FirebaseAuthException catch (e) {
      throw MyFirebaseAuthException(e.code);
    }
  }
}
