import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../../repositories/auth/auth_repository.dart';

part 'app_init_event.dart';
part 'app_init_state.dart';

class AppInitBloc extends Bloc<AppInitEvent, AppInitState> {
  final AuthRepository _authRepository;
  late StreamSubscription<auth.User?> _userSubscription;

  AppInitBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AppInitState.unknown()) {
    _userSubscription =
        _authRepository.user.listen((user) => add(AuthUserChanged(user: user)));
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }

  @override
  Stream<AppInitState> mapEventToState(AppInitEvent event) async* {
    if (event is AuthUserChanged) {
      yield* _mapAuthUserChangedToState(event);
    } else if (event is AuthLogoutRequested) {
      await _authRepository.signOut();
    }
  }

  Stream<AppInitState> _mapAuthUserChangedToState(
      AuthUserChanged event) async* {
    yield event.user != null
        ? AppInitState.authenticated(user: event.user!)
        : AppInitState.unauthenticated();
  }
}
