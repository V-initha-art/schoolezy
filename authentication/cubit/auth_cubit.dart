import 'dart:async';

import 'package:authentication/authenticationrepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/userrepo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const AuthState.unknown()) {
    authenticationStatusSubscription = _authenticationRepository.status.listen(
      _onAuthenticationStatusChanged,
    );
  }

  final AuthenticationRepository _authenticationRepository;
  late StreamSubscription<AuthenticationStatus> authenticationStatusSubscription;
  @override
  Future<void> close() async {
    await authenticationStatusSubscription.cancel();
    _authenticationRepository.dispose();
    await super.close();
  }

  Future<void> _onAuthenticationStatusChanged(
    AuthenticationStatus status,
  ) async {
    final user = await _authenticationRepository.tryGetUser();
    print(user);
    switch (status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthState.unauthenticated());
      case AuthenticationStatus.authenticated:
        return emit(
          user!.message!.data!.username!.isNotEmpty ? AuthState.authenticated(user) : const AuthState.unauthenticated(),
        );
      case AuthenticationStatus.unknown:
        return emit(const AuthState.unknown());
    }
  }

  void onAuthenticationLogoutRequested() => _authenticationRepository.logOut();
}
