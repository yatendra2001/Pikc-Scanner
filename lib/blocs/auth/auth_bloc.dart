import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pikc_app/repositories/auth/auth_repository.dart';
import 'package:pikc_app/utils/session_helper.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.authRepository}) : super(SignInInitial());
  AuthRepository authRepository;

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is GoogleSignInEvent) {
      yield SignInLoadState();
      try {
        final user = await authRepository.signInByGoogle();
        final check = await authRepository.checkUserDataExists(
            userId: FirebaseAuth.instance.currentUser!.uid);
        SessionHelper.displayName = user.displayName;
        SessionHelper.email = user.email;
        SessionHelper.uid = FirebaseAuth.instance.currentUser!.uid;
        SessionHelper.phone = FirebaseAuth.instance.currentUser!.phoneNumber;
        print("Sign In Success");
        yield check ? SignInSuccessState() : SignInDataEmptyState();
      } catch (e) {
        yield SignInFailedState(message: e.toString());
      }
    }
    if (event is SignInByEmailAndPassword) {
      yield SignInLoadState();
      try {
        final userCredential = await authRepository.signUpByEmailPassword(
            email: event.email, password: event.password);
        final check = await authRepository.checkUserDataExists(
            userId: userCredential.user!.uid);
        SessionHelper.displayName = userCredential.user!.displayName;
        SessionHelper.email = userCredential.user!.email;
        SessionHelper.phone = userCredential.user!.phoneNumber;
        SessionHelper.uid = userCredential.user!.uid;
        yield check ? SignInSuccessState() : SignInDataEmptyState();
      } catch (e) {
        yield SignInFailedState(message: e.toString());
      }
    }
    if (event is OtpSignInEvent) {
      try {
        yield SendingOTPState();
        final isOtpSent = await authRepository.sendOTP(phone: event.phone);
        debugPrint("Send otp complete: ${event.phone}  $isOtpSent.toString()");
        SessionHelper.phone = event.phone;
        yield SentOTPState();
      } catch (e) {
        yield SignInFailedState(message: e.toString());
      }
    }
    if (event is OtpVerifyEvent) {
      try {
        yield VerifyingOTPState();
        final userCredential = await authRepository.verifyOTP(otp: event.otp);
        debugPrint("UserCredentials:  $userCredential");
        debugPrint("User uid: ${userCredential.user?.uid}");
        debugPrint(
            "Current User uid: ${FirebaseAuth.instance.currentUser!.uid}");
        final check = await authRepository.checkUserDataExists(
            userId: FirebaseAuth.instance.currentUser!.uid);
        SessionHelper.displayName = userCredential.user!.displayName;
        SessionHelper.email = userCredential.user!.email;
        SessionHelper.uid = userCredential.user!.phoneNumber;
        yield check ? SignInSuccessState() : SignInDataEmptyState();
      } catch (e) {
        yield SignInFailedState(message: e.toString());
      }
    }
    if (event is SignOutEvent) {
      yield SigningOutState();
      await authRepository.signOut();
      yield SignedOutState();
    }
  }
}
