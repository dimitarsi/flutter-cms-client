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
      folderLocation: json['folderLocation'] as String?,
      folderTarget: json['folderTarget'] as String?,
      configId: json['configId'] as String?,
    );

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'type': instance.type,
      'folderLocation': instance.folderLocation,
      'folderTarget': instance.folderTarget,
      'configId': instance.configId,
      'data': instance.data,
    };

ContentType _$ContentTypeFromJson(Map<String, dynamic> json) => ContentType(
      name: json['name'] as String,
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => ContentType.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['_id'] as String?,
      freezed: json['freezed'] as bool? ?? false,
      originalName: json['originalName'] as String?,
      originalSlug: json['originalSlug'] as String?,
      slug: json['slug'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$ContentTypeToJson(ContentType instance) =>
    <String, dynamic>{
      'name': instance.name,
      '_id': instance.id,
      'type': instance.type,
      'originalName': instance.originalName,
      'originalSlug': instance.originalSlug,
      'children': instance.children,
      'slug': instance.slug,
      'freezed': instance.freezed,
    };
