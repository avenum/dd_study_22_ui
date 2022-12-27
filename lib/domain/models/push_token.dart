import 'package:json_annotation/json_annotation.dart';

part 'push_token.g.dart';

@JsonSerializable()
class PushToken {
  String token;

  PushToken({
    required this.token,
  });

  factory PushToken.fromJson(Map<String, dynamic> json) =>
      _$PushTokenFromJson(json);

  Map<String, dynamic> toJson() => _$PushTokenToJson(this);
}
