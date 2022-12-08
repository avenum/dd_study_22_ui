import 'package:dd_study_22_ui/domain/db_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_content.g.dart';

@JsonSerializable()
class PostContent implements DbModel {
  @override
  final String id;
  final String name;
  final String mimeType;
  final String contentLink;
  final String postId;
  PostContent({
    required this.id,
    required this.name,
    required this.mimeType,
    required this.contentLink,
    required this.postId,
  });

  factory PostContent.fromJson(Map<String, dynamic> json) =>
      _$PostContentFromJson(json);

  Map<String, dynamic> toJson() => _$PostContentToJson(this);

  factory PostContent.fromMap(Map<String, dynamic> map) =>
      _$PostContentFromJson(map);
  @override
  Map<String, dynamic> toMap() => _$PostContentToJson(this);
}
