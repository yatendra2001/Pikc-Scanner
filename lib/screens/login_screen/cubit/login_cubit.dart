import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pikc_app/repositories/auth/auth_repository.dart';
import 'package:pikc_app/models/models.dart';
import 'package:pikc_app/utils/session_helper.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  // final UserRepository _userRepository;
  LoginCubit({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        // _userRepository = userRepository,
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
          ? state.copyWith(status: LoginStatus.success)
          : state.copyWith(status: LoginStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: LoginStatus.error));
    }
  }

  String phone = '';
  void sendOtpOnPhone({required String phone}) async {
    if (state.status == LoginStatus.submitting) return;
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      final isOtpSent = await _authRepository.sendOTP(phone: phone);
      SessionHelper.phone = phone;
      debugPrint("Send otp complete: $phone  $isOtpSent");
      emit(state.copyWith(status: LoginStatus.otpSent));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: LoginStatus.error));
    }
  }

  void verifyOtp({required String otp, Map<String, dynamic>? json}) async {
    try {
      emit(state.copyWith(status: LoginStatus.otpVerifying));
      final userCredential = await _authRepository.verifyOTP(otp: otp);
      debugPrint("UserCredentials:  $userCredential");
      debugPrint("User uid: ${userCredential.user?.uid}");
      debugPrint(
          "Current User uid: ${auth.FirebaseAuth.instance.currentUser!.uid}");
      SessionHelper.uid = userCredential.user?.uid;
      SessionHelper.phone = userCredential.user?.phoneNumber;
      emit(state.copyWith(status: LoginStatus.success));
    } catch (err) {
      emit(state.copyWith(
          failure: const Failure(message: "Unable to verify otp"),
          status: LoginStatus.error));
    }
  }

  // Future<bool> checkNumber(String phone, {bool newAccount = false}) async {
  //   return await _userRepository.searchUserbyPhone(
  //       query: "+91" + phone, newAccount: newAccount);
  // }

  // void checkUsername(String username) async {
  //   try {
  //     if (username.length < 4) {
  //       emit(state.copyWith(usernameStatus: UsernameStatus.usernameExists));
  //     } else {
  //       final check =
  //           await _userRepository.searchUserbyUsername(query: username);
  //       if (check == false) {
  //         emit(state.copyWith(usernameStatus: UsernameStatus.usernameExists));
  //       } else if (check == true) {
  //         emit(
  //             state.copyWith(usernameStatus: UsernameStatus.usernameAvailable));
  //       }
  //     }
  //   } on Failure catch (err) {
  //     emit(state.copyWith(failure: err, status: LoginStatus.error));
  //   }
  // }

  // void updateProfilePhoto(File? profileImage) async {
  //   try {
  //     emit(state.copyWith(profilePhotoStatus: ProfilePhotoStatus.uploading));
  //     if (profileImage != null) {
  //       SessionHelper.profileImageUrl =
  //           await StorageRepository().uploadProfileImage(
  //         url: "",
  //         image: profileImage,
  //       );
  //     }
  //     await _userRepository.updateUser(
  //       user: User(
  //         id: SessionHelper.uid ?? "",
  //         username: SessionHelper.username ?? "",
  //         displayName: SessionHelper.displayName ?? "",
  //         profileImageUrl: SessionHelper.profileImageUrl ?? '',
  //         age: SessionHelper.age ?? '',
  //         phone: SessionHelper.phone ?? '',
  //         followers: 0,
  //         following: 0,
  //         completed: SessionHelper.completed ?? 0,
  //         todo: SessionHelper.todo ?? 0,
  //         bio: "",
  //         walletBalance: 0,
  //       ),
  //     );
  //     emit(state.copyWith(profilePhotoStatus: ProfilePhotoStatus.uploaded));
  //   } on Failure catch (err) {
  //     emit(state.copyWith(
  //         failure: err, profilePhotoStatus: ProfilePhotoStatus.error));
  //   }
  // }

  // Future<void> fetchTopFollowers() async {
  //   try {
  //     emit(state.copyWith(topFollowersStatus: TopFollowersStatus.loading));
  //     final accounts =
  //         await _userRepository.getUsersByFollowers(SessionHelper.uid!);
  //     emit(state.copyWith(
  //         topFollowersStatus: TopFollowersStatus.loaded,
  //         topFollowersAccount: accounts));
  //   } on Failure catch (err) {
  //     emit(state.copyWith(
  //         failure: err, topFollowersStatus: TopFollowersStatus.error));
  //   }
  // }

  // void logoutRequested() {
  //   emit(state.copyWith(status: LoginStatus.initial));
  // }
}
