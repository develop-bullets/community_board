import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../errors/failures.dart';

// usecase는 사용자의 관점에서 의미있는 단일 기능 단위
// 예를 들어 로그인 한다. 회원가입 한다. 게시물을 불러온다. 등이
// 각각 하나의 usecase가 됩니다.
// ReturnType: usecase가 성공했을 때, 반환할 값의 타입
// ParamsType: usecase를 실행하는데 필요한 파라미터의 타입
abstract interface class UseCase<ReturnType, ParamsType> {
  // call method 덕분에 나중에 usecase 클래스의 인스턴스를 마치 함수처럼
  // loginUseCase params와 같이 간결하게 호출할 수 있음
  Future<Either<Failure, ReturnType>> call(ParamsType params);
}

// 로그아웃처럼 파라미터가 필요없는 usecase를 위한 no params 클래스
class NoParams extends Equatable {
  const NoParams();

  // 비교 대상이 없으므로 empty list를 리턴
  @override
  List<Object?> get props => [];
}