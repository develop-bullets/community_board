part of 'post_list_bloc.dart';

enum PostListStatus {
  // 초기 상태
  initial,
  // 첫 데이터 로딩 중 상태
  loading,
  // 데이터 로딩 성공 상태
  loaded,
  // 초기 로딩 실패 상태
  failure,
  // pagination 에서 다음 페이지 로딩 상태
  fetchingNextPage,
  // 삭제 후 목록을 채우기 위한 로딩 상태
  // post list 목록에서 아이템을 삭제할 때, pagination 숫자를 맞추기 위해
  // next 아이템을 서버에 요청할 때, 사용하는 state
  refilling,
  // 새로고침 상태
  refreshing,
}

class PostListState extends Equatable {
  const PostListState({
    this.status = PostListStatus.initial,
    this.posts = const [],
    this.hasReachedMax = false,
    this.failure,
    this.transientFailure,
    this.scrollToTopEventId,
  });

  final PostListStatus status;
  final List<PostDisplay> posts;
  // 더 이상 불러올 게시물이 없는지 여부를 나타내는 값
  // true 이면 목록에 끝에 도달했다는 의미
  // 이 변수는 pagination 을 구현할 때, 사용됩니다.
  final bool hasReachedMax;
  // 초기 로딩 실패와 같이 전체 화면에 영향을 주는 심각한 오류 정보를 담습니다.
  // 전체 화면이 에러로 바뀌는 심각한 오류
  final Failure? failure;
  // 일시적인 실패 정보를 담는 필드입니다.
  // 기존 목록을 그대로 보여주면서 잠시 스낵바 등으로 알려주면 되는 가벼운 오류
  // 예를 들어 "좋아요 실패", "다음 페이지 로딩 실패" 등을 구분하기 위해 필요합니다.
  final Failure? transientFailure;
  // 목록을 맨 위로 스크롤 시켜야할 때, 사용하는 이벤트 식별자
  // 보통 현재 시간처럼 고유한 값으로 설정됩니다.
  // 예를 들어 다른 화면에서 새 글이 작성되었을 때, 이 값을 업데이트하여
  // 게시물 목록이 자동으로 새로고침되고, 맨 위로 이동하게 만들 수 있습니다.
  final int? scrollToTopEventId;

  @override
  List<Object?> get props {
    return [
      status,
      posts,
      hasReachedMax,
      failure,
      transientFailure,
      scrollToTopEventId,
    ];
  }

  PostListState copyWith({
    PostListStatus? status,
    List<PostDisplay>? posts,
    bool? hasReachedMax,
    Failure? Function()? failure,
    Failure? Function()? transientFailure,
    int? Function()? scrollToTopEventId,
  }) {
    return PostListState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      failure: failure != null ? failure() : this.failure,
      transientFailure: transientFailure != null
          ? transientFailure()
          : this.transientFailure,
      scrollToTopEventId: scrollToTopEventId != null
          ? scrollToTopEventId()
          : this.scrollToTopEventId,
    );
  }
}
