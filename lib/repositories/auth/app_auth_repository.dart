import 'package:google_sign_in/google_sign_in.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:pikc_app/repositories/auth/auth_nw_repository.dart';

import 'auth_repository.dart';

class AppAuthRepository extends AuthRepository {
  final _authNwRepository = AuthNwRepository();
  @override
  Future<GoogleSignInAccount> signInByGoogle() {
    return _authNwRepository.signInByGoogle();
  }

  @override
  Future<UserCredential> signUpByEmailPassword(
      {required String email, required String password}) {
    return _authNwRepository.signUpByEmailPassword(
        email: email, password: password);
  }

  @override
  Future<void> signOut() {
    return _authNwRepository.signOut();
  }

  @override
  Future<UserCredential> logInByEmailPassword(
      {required String email, required String password}) {
    return _authNwRepository.logInByEmailPassword(
        email: email, password: password);
  }

  @override
  Future<bool> checkUserDataExists({required String userId}) {
    return _authNwRepository.checkUserDataExists(userId: userId);
  }

  @override
  Future<bool> sendOTP({required String phone}) {
    return _authNwRepository.sendOTP(phone: phone);
  }

  @override
  Future<UserCredential> verifyOTP({required String otp}) {
    return _authNwRepository.verifyOTP(otp: otp);
  }
}
