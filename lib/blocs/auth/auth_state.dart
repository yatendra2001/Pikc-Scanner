part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInInitial extends AuthState {}

class SignInSuccessState extends AuthState {}

class SignInDataEmptyState extends AuthState {}

class SignInFailedState extends AuthState {
  final String message;

  SignInFailedState({required this.message});

  @override
  List<Object?> get props => [message];
}

class SignInLoadState extends AuthState {}

class SigningOutState extends AuthState {}

class SignedOutState extends AuthState {}

class SendingOTPState extends AuthState {}

class SentOTPState extends AuthState {}

class VerifyingOTPState extends AuthState {}
