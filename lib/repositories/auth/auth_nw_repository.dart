import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthNwRepository {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  final auth = FirebaseAuth.instance;
  final usersRef = FirebaseFirestore.instance.collection('users');
  Future<GoogleSignInAccount> signInByGoogle() async {
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final googleAuth = await user.authentication;
        final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
        await FirebaseAuth.instance.signInWithCredential(credential);
        return user;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
    }
    throw Exception('something went wrong');
  }

  Future<UserCredential> signUpByEmailPassword(
      {required String email, required String password}) async {
    String _errorMessage = 'Something went wrong';

    try {
      final user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print(user);
      if (user.credential != null) {
        await FirebaseAuth.instance.signInWithCredential(user.credential!);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      _errorMessage = e.message.toString();
    }
    throw Exception(_errorMessage);
  }

  Future<UserCredential> logInByEmailPassword(
      {required String email, required String password}) async {
    String _errorMessage = 'Something went wrong';
    try {
      final user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user.credential != null) {
        await FirebaseAuth.instance.signInWithCredential(user.credential!);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message.toString();
      debugPrint(e.message);
    }
    throw Exception(_errorMessage);
  }

  Future<UserCredential> logInByUserCredential(
      {required AuthCredential authCredential}) async {
    String _errorMessage = 'Something went wrong';
    try {
      final user =
          await FirebaseAuth.instance.signInWithCredential(authCredential);

      return user;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message.toString();
      debugPrint(e.message);
    }
    throw Exception(_errorMessage);
  }

  String _verificationId = "";
  int? _resendToken;

  Future<bool> sendOTP({required String phone}) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
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

  Future<UserCredential> verifyOTP({required String otp}) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: otp);
    return await auth.signInWithCredential(credential);
  }

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

  // Future<User> getUser() {}

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await auth.signOut();
  }
}
