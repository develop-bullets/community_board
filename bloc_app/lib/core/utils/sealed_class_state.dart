import 'package:equatable/equatable.dart';

sealed class SealedClassState<F, T> extends Equatable {
  const SealedClassState();

  /// 이 4개는 리다이렉팅 팩토리 생성자(redirecting factory constructor) 입니다.
  /// 각 상태를 쉽게 만들 수 있게 해주는 일종의 바로가기와 유사
  /// 실제 인스턴스를 만드는 작업을 sub-class constructor 에 위임합니다.
  /// 단, sub-class 들과 달리, factory constructor 는 타입으로는 사용할 수 없다는 점에 유의합니다.
  const factory SealedClassState.initial() = SealedClassInitial<F, T>;

  const factory SealedClassState.loading({T? prevData}) =
      SealedClassLoadInProgress<F, T>;

  const factory SealedClassState.success({required T data}) =
      SealedClassLoadSuccess<F, T>;

  const factory SealedClassState.failure({required F failure, T? prevData}) =
      SealedClassLoadFailure<F, T>;

  @override
  List<Object?> get props => [];
}

final class SealedClassInitial<F, T> extends SealedClassState<F, T> {
  const SealedClassInitial();

  @override
  String toString() => 'Initial<$F, $T>()';
}

final class SealedClassLoadInProgress<F, T> extends SealedClassState<F, T> {
  const SealedClassLoadInProgress({this.prevData});

  final T? prevData;

  @override
  List<Object?> get props => [prevData];

  @override
  String toString() => 'Loading<$F, $T>(prevData: $prevData)';
}

final class SealedClassLoadSuccess<F, T> extends SealedClassState<F, T> {
  const SealedClassLoadSuccess({required this.data});

  final T data;

  @override
  List<Object?> get props => [data];

  @override
  String toString() => 'Success<$F, $T>(data: $data)';
}

final class SealedClassLoadFailure<F, T> extends SealedClassState<F, T> {
  const SealedClassLoadFailure({required this.failure, this.prevData});

  final F failure;
  final T? prevData;

  @override
  List<Object?> get props => [failure, prevData];

  @override
  String toString() =>
      'Failure<$F, $T>(failure: $failure, prevData: $prevData)';
}

// for UI
/// state의 현재 또는 이전의 데이터 값을 얻는 getter: currentOrPreviousData
/// 현재 state 가 data를 가지고 있는지를 체크하는 getter: hasData
extension SealedClassStateDataUtils<F, T> on SealedClassState<F, T> {
  T? get currentOrPreviousData {
    return switch (this) {
      SealedClassLoadSuccess<F, T>(data: final data) => data,
      SealedClassLoadInProgress<F, T>(prevData: final prevData) => prevData,
      SealedClassLoadFailure<F, T>(prevData: final prevData) => prevData,
      // SealedClassInitial<F, T>
      _ => null,
    };
  }

  bool get hasData => currentOrPreviousData != null;
}
