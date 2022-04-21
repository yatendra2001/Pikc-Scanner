import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pikc_app/models/models.dart';
import 'package:pikc_app/repositories/auth/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(LoginState.initial());

  void logInWithGoogle() async {
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      final user = await _authRepository.signInByGoogle();
      final check = await _authRepository.checkUserDataExists(
          userId: FirebaseAuth.instance.currentUser!.uid);
      await _authRepository.updateData(
          uid: FirebaseAuth.instance.currentUser!.uid,
          check: check,
          json: {
            'uid': FirebaseAuth.instance.currentUser!.uid,
            'name': user.displayName ?? "",
            'email': user.email,
          });
      emit(check
          ? state.copyWith(status: LoginStatus.success, isDataEmpty: true)
          : state.copyWith(status: LoginStatus.success, isDataEmpty: false));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: LoginStatus.error));
    }
  }

  void sendOtpOnPhone({required String phone}) async {
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      final isOtpSent = await _authRepository.sendOTP(phone: phone);
      debugPrint("Send otp complete: $phone  $isOtpSent");
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: LoginStatus.error));
    }
  }

  void verifyOtp({required String otp}) async {
    try {
      final userCredential = await _authRepository.verifyOTP(otp: otp);
      final check = await _authRepository.checkUserDataExists(
          userId: FirebaseAuth.instance.currentUser!.uid);
      debugPrint("UserCredentials:  $userCredential");
      debugPrint("User uid: ${userCredential.user?.uid}");
      debugPrint("Current User uid: ${FirebaseAuth.instance.currentUser!.uid}");
      await _authRepository
          .updateData(uid: userCredential.user!.uid, check: check, json: {
        'uid': userCredential.user!.uid,
        'name': userCredential.user?.displayName ?? "",
        'email': userCredential.user?.email ?? "",
        'phone': userCredential.user?.phoneNumber ?? "",
      });
      emit(check
          ? state.copyWith(status: LoginStatus.success, isDataEmpty: true)
          : state.copyWith(status: LoginStatus.success, isDataEmpty: false));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: LoginStatus.error));
    }
  }
}
