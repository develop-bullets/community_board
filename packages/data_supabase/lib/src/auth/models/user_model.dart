import 'package:domain/auth.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'user_model.g.dart';

// 우리는 새로운 유저를 만들 때, User 모델을 사용하지 않을 것이기 때문에
// createToJson argument의 value로 false를 줌
@JsonSerializable(createToJson: false)
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.username,
    super.avatarUrl,
    required super.role,
  });

  // supabase user 객체에서 user 모델을 만듬
  factory UserModel.fromSupabaseUser(User user) {
    final metaData = user.userMetadata ?? {};

    return UserModel(
      id: user.id,
      username: metaData['username'] as String? ?? '',
      avatarUrl: metaData['avatar_url'] as String?,
      role: metaData['role'] as String? ?? 'user',
    );
  }

  // Profiles 테이블에서 읽어온 Profiles 정보를 User 모델로 변환함
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @JsonKey(name: 'avatar_url')
  @override
  String? get avatarUrl;
}
