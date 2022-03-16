import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRepository {
  Future<UserCredential> signUpByEmailPassword(
      {required String email, required String password});
  Future<GoogleSignInAccount> signInByGoogle();

  Future<UserCredential> logInByEmailPassword(
      {required String email, required String password});

  Future<bool> sendOTP({required String phone});

  Future<UserCredential> verifyOTP({required String otp});

  Future<bool> checkUserDataExists({required String userId});

  Future<void> signOut();
}
