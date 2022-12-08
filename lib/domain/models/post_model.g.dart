// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      id: json['id'] as String,
      description: json['description'] as String?,
      author: User.fromJson(json['author'] as Map<String, dynamic>),
      contents: (json['contents'] as List<dynamic>)
          .map((e) => PostContent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'author': instance.author,
      'contents': instance.contents,
    };
