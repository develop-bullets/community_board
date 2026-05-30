part of 'authentication_bloc.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user,
  });

  // 외부에서 사용할 수 있는 공개된 생성자
  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(UserEntity user)
    : this._(status: AuthenticationStatus.authenticated, user: user);

  const AuthenticationState.unauthenticated()
    : this._(status: AuthenticationStatus.unauthenticated);

  final AuthenticationStatus status;
  final UserEntity? user;

  // final UserEntity? user; 때문에 List<Object?>
  @override
  List<Object?> get props => [status, user];
}
