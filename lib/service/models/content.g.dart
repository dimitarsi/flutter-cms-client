// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Content _$ContentFromJson(Map<String, dynamic> json) => Content(
      id: json['id'] as String?,
      name: json['displayName'] as String?,
      slug: json['slug'] as String?,
      data: (json['data'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, ContentData.fromJson(e as Map<String, dynamic>)),
      ),
      type: json['type'] as String?,
      configId: json['configId'] as String?,
      folder: json['folder'] as String?,
      config: json['config'] == null
          ? null
          : ContentType.fromJson(json['config'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
      'id': instance.id,
      'displayName': instance.name,
      'slug': instance.slug,
      'type': instance.type,
      'configId': instance.configId,
      'folder': instance.folder,
      'data': instance.data,
      'config': instance.config,
    };
