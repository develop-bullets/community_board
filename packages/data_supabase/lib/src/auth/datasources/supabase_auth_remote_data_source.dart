import 'dart:io';

import 'package:core/constants.dart';
import 'package:core/errors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

class SupabaseAuthRemoteDataSource implements AuthRemoteDataSource {
  SupabaseAuthRemoteDataSource({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  @override
  Stream<UserModel?> get onAuthStateChanged {
    return _supabaseClient.auth.onAuthStateChange.map((AuthState state) {
      final user = state.session?.user;
      if (user == null) return null;
      return UserModel.fromSupabaseUser(user);
    });
  }

  @override
  Future<UserModel> signup({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final AuthResponse response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        // 데이터 프로퍼티를 이용해 회원가입 시 추가적인 메타 데이터를 전달 할 수 있음.
        // 그런데 롤키의 value로 string value를 그대로 사용할 경우,
        // 오타 등의 오류가 발생할 가능성이 높습니다. 그렇기 때문에 별도 constant로 정의.
        data: {'username': username, 'role': Roles.user},
      );

      final User? user = response.user;

      // 비정상적인 경우이지만 응답이 성공했음에도 User 객체가 null일 수 있는 가능성에
      // 대비해 방어코드를 작성합니다.
      if (user == null) {
        throw const AuthenticationException(
          message:
              'Registration was successful, '
              'but user information could not be retrieved. (User is null)',
        );
      }

      return UserModel.fromSupabaseUser(user);
    } on AuthException catch (e) {
      throw AuthenticationException(message: e.message);
    // supabase 라이브러리가 throw하는 auth exception 외에 자체적으로 인증 에러를 판단할 경우에는
    // try block에서 AuthenticationException을 throw 할 예정입니다.
    // 이 경우 이미 우리가 만든 커스텀 exception이니까 별도 변환 없이 rethrow 함.
    } on AuthenticationException {
      rethrow;
    // 인터넷 연결 문제 등으로 발생하는 SocketException을 잡아내서 NetworkException으로 변환해
    // 다시 throw 함.
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      throw UnknownException(
        message: 'An unexpected error occurred while signup: ${e.toString()}',
      );
    }
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await _supabaseClient.auth
          .signInWithPassword(email: email, password: password);

      final User? user = response.user;

      if (user == null) {
        throw const AuthenticationException(
          message:
              'Sign in was successful, '
              'but user information could not be retrieved. (User is null)',
        );
      }

      return UserModel.fromSupabaseUser(user);
    } on AuthException catch (e) {
      throw AuthenticationException(message: e.message);
    } on AuthenticationException {
      rethrow;
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      throw UnknownException(
        message: 'An unexpected error occurred while login: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _supabaseClient.auth.signOut();
    // AuthenticationException을 삭제하는 이유는 로그아웃 과정에서는
    // user의 null 유무와 같은 사항을 체크할 필요가 없기 때문임.
    } on AuthException catch (e) {
      throw AuthenticationException(message: e.message);
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      throw UnknownException(
        message:
            'An unexpected error occurred while logging out: ${e.toString()}',
      );
    }
  }
}
