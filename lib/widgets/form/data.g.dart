// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Content _$ContentFromJson(Map<String, dynamic> json) => Content(
      type: json['type'] as String,
      value: json['value'],
    );

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
      'type': instance.type,
      'value': instance.value,
    };

ContentType _$ContentTypeFromJson(Map<String, dynamic> json) => ContentType(
      name: json['name'] as String,
      value: json['value'],
      type: json['type'] as String,
    );

Map<String, dynamic> _$ContentTypeToJson(ContentType instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'value': instance.value,
    };
