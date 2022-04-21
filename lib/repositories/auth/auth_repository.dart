import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pikc_app/config/paths.dart';
import 'package:pikc_app/models/models.dart';
import 'package:pikc_app/repositories/auth/base_auth_repository.dart';

class AuthRepository extends BaseAuthRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firebaseFirestore;
  final auth.FirebaseAuth _firebaseAuth;
  final usersRef = FirebaseFirestore.instance.collection('users');

  AuthRepository({
    FirebaseFirestore? firebaseFirestore,
    auth.FirebaseAuth? firebaseAuth,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  @override
  Stream<auth.User?> get user => _firebaseAuth.userChanges();

  @override
  Future<bool> checkUserDataExists({required String userId}) async {
    String _errorMessage = 'Something went wrong';
    try {
      final user = await usersRef.doc(userId).get();
      return user.exists;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint(e.toString());
    }
    throw Exception(_errorMessage);
  }

  @override
  Future<GoogleSignInAccount> signInByGoogle() async {
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final googleAuth = await user.authentication;
        final credential = auth.GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
        await _firebaseAuth.signInWithCredential(credential);
        return user;
      }
    } on auth.FirebaseAuthException catch (e) {
      debugPrint(e.message);
    }
    throw Exception('something went wrong');
  }

  String _verificationId = "";
  int? _resendToken;
  @override
  Future<bool> sendOTP({required String phone}) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (auth.PhoneAuthCredential credential) {},
      verificationFailed: (auth.FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) async {
        _verificationId = verificationId;
        _resendToken = resendToken;
      },
      timeout: const Duration(seconds: 25),
      forceResendingToken: _resendToken,
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = _verificationId;
      },
    );
    debugPrint("_verificationId: $_verificationId");
    return true;
  }

  @override
  Future<auth.UserCredential> verifyOTP({required String otp}) async {
    auth.PhoneAuthCredential credential = auth.PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: otp);
    return await _firebaseAuth.signInWithCredential(credential);
  }

  @override
  Future<void> updateData(
      {required Map<String, String> json,
      required String uid,
      required bool check}) async {
    check
        ? _firebaseFirestore.collection(Paths.users).doc(uid).update(json)
        : _firebaseFirestore.collection(Paths.users).doc(uid).set(json);
  }

  @override
  Future<void> logOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
