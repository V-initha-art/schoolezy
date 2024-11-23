part of 'auth_cubit.dart';

class AuthState {
  const AuthState._({
    this.status = AuthenticationStatus.unauthenticated,
    this.user = const User(message: null, cookies: null),
  });

  const AuthState.authenticated(User user) : this._(status: AuthenticationStatus.authenticated, user: user);

  const AuthState.unauthenticated() : this._(status: AuthenticationStatus.unauthenticated);

  const AuthState.unknown() : this._(status: AuthenticationStatus.unknown);

  final AuthenticationStatus status;
  final User user;
}
