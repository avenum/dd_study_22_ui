// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostContent _$PostContentFromJson(Map<String, dynamic> json) => PostContent(
      id: json['id'] as String,
      name: json['name'] as String,
      mimeType: json['mimeType'] as String,
      contentLink: json['contentLink'] as String,
      postId: json['postId'] as String?,
    );

Map<String, dynamic> _$PostContentToJson(PostContent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mimeType': instance.mimeType,
      'contentLink': instance.contentLink,
      'postId': instance.postId,
    };
