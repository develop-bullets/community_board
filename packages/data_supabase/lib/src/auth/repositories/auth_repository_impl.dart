import 'dart:async';

import 'package:core/errors.dart';
import 'package:domain/auth.dart';
import 'package:fpdart/fpdart.dart';

import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required AuthRemoteDataSource authRemoteDataSource})
    : _authRemoteDataSource = authRemoteDataSource;

  final AuthRemoteDataSource _authRemoteDataSource;

  @override
  Stream<UserEntity?> get onAuthStateChanged {
    final controller = StreamController<UserEntity?>();

    final subscription = _authRemoteDataSource.onAuthStateChanged.listen(
      (userModel) {
        controller.add(userModel);
      },
      onError: (error) {
        print('Auth Steam Error: $error');
        // 에러 발생 시에 안전을 위해 logout 상태인 null을 스트림에 추가
        controller.add(null);
      },
    );

    // 앱의 종료 등 이 스크림에 대한 리스너가 없어지면
    // 컨트롤러의 onCancel Callback에서 내부 구독도 취소하고
    // 컨트롤러를 닫음
    controller.onCancel = () {
      subscription.cancel();
    };

    return controller.stream;
  }

  @override
  Future<Either<Failure, void>> signup({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      await _authRemoteDataSource.signup(
        email: email,
        password: password,
        username: username,
      );
      // null을 argument로 준 이유는 return type이 void이기 때문임
      return const Right(null);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  }) async {
    try {
      await _authRemoteDataSource.login(email: email, password: password);
      return const Right(null);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _authRemoteDataSource.logout();
      return const Right(null);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }
}
