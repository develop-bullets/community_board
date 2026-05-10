import 'dart:async';

import 'package:data_supabase/auth.dart';
// import 'package:data_supabase/post.dart';
// import 'package:data_supabase/profile.dart';
// import 'package:data_supabase/search.dart';
import 'package:domain/auth.dart';
// import 'package:domain/post.dart';
// import 'package:domain/profile.dart';
// import 'package:domain/search.dart';
// import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// import '../../features/auth/presentation/blocs/authentication/authentication_bloc.dart';
// import '../config/router/app_router.dart';

// FutureOr<void> disposeRealtimeDataSource(RealtimeRemoteDataSource instance) {
//   instance.dispose();
// }

// abstract getter 선언만 해도 에러가 발생하지 않은 이유는 RegisterModule이 abstract class이기 때문입니다.
// 그렇지만 local package라 하더라도 복잡한 초기화 로직을 가지고 있을 경우에는
// 단순 getter 선언만으로는 안되고 구체적으로 인스턴스를 얻는 방법을 알려줘야 합니다.
@module
abstract class RegisterModule {
  // SupabaseClient는 외부 라이브러리 클래스 입니다.
  // injectable은 이 클래스의 인스턴스를 어떻게 얻어야 하는지 알 수 없습니다.
  // 왜냐하면 단순 생성자 호출이 아니라 superbase.instance.client를 통해 얻어야 하기 때문입니다.
  // 단순 생성자 호출로 인스턴스를 얻을 수 있다면 get 선언만으로도 충분합니다.
  // 그래서 우리는 이 클래스가 필요하면 이 코드를 실행해서 인스턴스를 가져와라고 직접 방법을 알려줘야 합니다.
  @singleton
  SupabaseClient get supabaseClient => Supabase.instance.client;

  // @singleton
  // GoRouter router(AuthenticationBloc authBloc) => createRouter(authBloc);

  /// --- Data Layer Registration (LazySingleton) ---
  // auth
  // @LazySingleton으로 애노테이트 한 이유는 필요할 때, 인스턴스를 생성하면 되기 때문입니다.
  @LazySingleton(as: AuthRemoteDataSource)
  SupabaseAuthRemoteDataSource get authRemoteDataSource;

  @LazySingleton(as: AuthRepository)
  AuthRepositoryImpl get authRepository;

  // post
  // @LazySingleton(as: PostRemoteDataSource)
  // SupabasePostRemoteDataSource get postRemoteDataSource;

  // @LazySingleton(as: PostRepository)
  // PostRepositoryImpl get postRepository;

  // @LazySingleton(
  //   as: RealtimeRemoteDataSource,
  //   dispose: disposeRealtimeDataSource,
  // )
  // SupabaseRealtimeRemoteDataSource get realtimeRemoteDataSource;

  // @LazySingleton(as: RealtimeRepository)
  // RealtimeRepositoryImpl get realtimeRepository;

  // profile
  // @LazySingleton(as: ProfileRemoteDataSource)
  // SupabaseProfileRemoteDataSource get profileRemoteDataSource;

  // @LazySingleton(as: ProfileRepository)
  // ProfileRepositoryImpl get profileRepository;

  // search
  // @LazySingleton(as: SearchRemoteDataSource)
  // SupabaseSearchRemoteDataSource get searchRemoteDataSource;

  // @LazySingleton(as: SearchRepository)
  // SearchRepositoryImpl get searchRepository;

  /// --- Domain Layer (UseCases) Registration (Injectable - factory) ---
  // UseCases는 호출 시점에만 인스턴스를 만들고 바로 사용하면 되므로 팩토리 방식
  // 즉 injectable로 등록하는게 적합합니다.
  // 이렇게 하면 앱 전체 단 하나의 인스턴스만 유지하는 싱글톤과 달리
  // 요청이 있을 때마다 새로운 객체를 만들어 사용하게 됩니다.
  // auth
  @injectable
  SignupUseCase get signupUseCase;

  @injectable
  LoginUseCase get loginUseCase;

  @injectable
  LogoutUseCase get logoutUseCase;

  // post
  // @injectable
  // GetPostsUseCase get getPostsUseCase;

  // @injectable
  // CreatePostUseCase get createPostUseCase;

  // @injectable
  // UploadPostImageUseCase get uploadPostImageUseCase;

  // @injectable
  // GetPostDetailUseCase get getPostDetailUseCase;

  // @injectable
  // GetCommentsUseCase get getCommentsUseCase;

  // @injectable
  // ToggleLikeUseCase get toggleLikeUseCase;

  // @injectable
  // CreateCommentUseCase get createCommentUseCase;

  // @injectable
  // DeleteCommentUseCase get deleteCommentUseCase;

  // @injectable
  // UpdateCommentUseCase get updateCommentUseCase;

  // @injectable
  // DeletePostUseCase get deletePostUseCase;

  // @injectable
  // DeletePostFolderUseCase get deletePostFolderUseCase;

  // @injectable
  // UpdatePostUseCase get updatePostUseCase;

  // @injectable
  // GetMyPostsUseCase get getMyPostsUseCase;

  // profile
  // @injectable
  // GetProfileUseCase get getProfileUseCase;

  // @injectable
  // UpdateProfileUseCase get upateProfileUseCase;

  // search
  // @injectable
  // SearchPostsUseCase get searchPostsUseCase;

  // @injectable
  // SearchUsersUseCase get searchUsersUseCase;
}