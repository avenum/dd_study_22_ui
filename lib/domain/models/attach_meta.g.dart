// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attach_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttachMeta _$AttachMetaFromJson(Map<String, dynamic> json) => AttachMeta(
      tempId: json['tempId'] as String,
      name: json['name'] as String,
      mimeType: json['mimeType'] as String,
      size: json['size'] as int,
    );

Map<String, dynamic> _$AttachMetaToJson(AttachMeta instance) =>
    <String, dynamic>{
      'tempId': instance.tempId,
      'name': instance.name,
      'mimeType': instance.mimeType,
      'size': instance.size,
    };
