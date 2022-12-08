import 'package:dd_study_22_ui/domain/db_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post implements DbModel {
  @override
  final String id;
  final String description;
  final String authorId;
  Post({
    required this.id,
    required this.description,
    required this.authorId,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);

  factory Post.fromMap(Map<String, dynamic> map) => _$PostFromJson(map);
  @override
  Map<String, dynamic> toMap() => _$PostToJson(this);
}
