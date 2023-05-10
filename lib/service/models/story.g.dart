// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Story _$StoryFromJson(Map<String, dynamic> json) => Story(
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      type: json['type'] as String?,
      configId: json['configId'] as String?,
    );

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
      'name': instance.name,
      'slug': instance.slug,
      'type': instance.type,
      'configId': instance.configId,
      'data': instance.data,
    };
