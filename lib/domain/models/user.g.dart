// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      avatarLink: json['avatarLink'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'birthDate': instance.birthDate.toIso8601String(),
      'avatarLink': instance.avatarLink,
    };
