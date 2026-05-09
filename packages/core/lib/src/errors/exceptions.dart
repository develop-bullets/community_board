// for data - datasource
class AppException implements Exception {
  const AppException({required this.message});

  final String message;

  @override
  String toString() => '${runtimeType.toString()}: $message';
}

// 인증 관련 예외
class AuthenticationException extends AppException {
  const AuthenticationException({required super.message});
}

// 데이터베이스 관련 예외
class DatabaseException extends AppException {
  const DatabaseException({required super.message});
}

// RowLevelSecurity 위반 등 권한 관련 예외
class PermissionException extends DatabaseException {
  const PermissionException({required super.message});
}

// DatabaseError의 일종으로 원하는 데이터를 찾지 못했을 때의 예외
class NotFoundException extends DatabaseException {
  const NotFoundException({required super.message});
}

// supabse storage 예외
class StorageServerException extends AppException {
  const StorageServerException({required super.message});
}

// 네트워크 예외
class NetworkException extends AppException {
  const NetworkException({
    super.message =
    'Newtork connection failed. '
        'Please check your internet connection',
  });
}

// 예상치 못한 분류되지 않은 기타 예외
class UnknownException extends AppException {
  const UnknownException({super.message = 'An unknown error occurred.'});
}