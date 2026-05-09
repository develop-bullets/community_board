import 'package:equatable/equatable.dart';

// for domain - repository
abstract class Failure extends Equatable {
  const Failure({required this.message});

  final String message;

  @override
  List<Object> get props => [message];

  @override
  String toString() => '${runtimeType.toString()}: $message';
}

// API 오류, 데이터베이스 에러 등 일반적인 서버 오류
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

// 네트워크 연결 오류
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Please check your connection...'});
}

// 잘못된 자격증명 등 인증 관련 오류
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({required super.message});
}

// RowLevelSecurity 위반 등 권한 관련 오류
class PermissionFailure extends Failure {
  const PermissionFailure({
    super.message = 'You do not have permission for the request.',
  });
}

// DatabaseError의 일종으로 원하는 데이터를 찾지 못했을 때의 오류
class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'The data requested not found'});
}

// Supabase 리얼타임 기능과 연결이 되지 않을 때의 에러 처리
class ConnectionFailure extends Failure {
  const ConnectionFailure({required super.message});
}

// 예상치 못한 분류되지 않은 기타 오류
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unknown error has occurred. Please try again later.',
  });
}