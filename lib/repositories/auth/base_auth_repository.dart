import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuthRepository {
  Stream<auth.User?> get user;
  Future<GoogleSignInAccount> signInByGoogle();

  Future<bool> sendOTP({required String phone});

  Future<auth.UserCredential> verifyOTP({required String otp});

  Future<bool> checkUserDataExists({required String userId});

  Future<void> updateData(
      {required Map<String, String> json,
      required String uid,
      required bool check});

  Future<void> logOut();
}
