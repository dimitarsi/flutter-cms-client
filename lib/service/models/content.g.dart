// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Content _$ContentFromJson(Map<String, dynamic> json) => Content(
      id: json['id'] as String?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      data: json['data'],
      type: json['type'] as String?,
    );

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'type': instance.type,
      'data': instance.data,
    };

ContentType _$ContentTypeFromJson(Map<String, dynamic> json) => ContentType(
      name: json['name'] as String,
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => ContentType.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['_id'] as String?,
      slug: json['slug'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$ContentTypeToJson(ContentType instance) =>
    <String, dynamic>{
      'name': instance.name,
      '_id': instance.id,
      'type': instance.type,
      'children': instance.children,
      'slug': instance.slug,
    };
