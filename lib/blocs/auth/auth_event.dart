part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class GoogleSignInEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}

class SignInByEmailAndPassword extends AuthEvent {
  final String email;
  final String password;

  SignInByEmailAndPassword({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class OtpSignInEvent extends AuthEvent {
  final String phone;
  OtpSignInEvent({
    required this.phone,
  });
  @override
  List<Object?> get props => [phone];
}

class OtpVerifyEvent extends AuthEvent {
  final String otp;
  OtpVerifyEvent({
    required this.otp,
  });

  @override
  List<Object?> get props => [otp];
}
