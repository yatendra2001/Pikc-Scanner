part of 'login_cubit.dart';

enum LoginStatus {
  initial,
  submitting,
  otpSent,
  otpVerifying,
  success,
  error,
}

class LoginState extends Equatable {
  final LoginStatus status;

  final Failure failure;

  const LoginState({
    required this.status,
    required this.failure,
  });

  factory LoginState.initial() {
    return const LoginState(
      status: LoginStatus.initial,
      failure: Failure(),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        status,
        failure,
      ];

  LoginState copyWith({
    LoginStatus? status,
    Failure? failure,
  }) {
    return LoginState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
