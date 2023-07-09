// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentData _$ContentDataFromJson(Map<String, dynamic> json) => ContentData(
      type: json['type'] as String,
      value: json['value'],
      componentId: json['componentId'] as String?,
    );

Map<String, dynamic> _$ContentDataToJson(ContentData instance) =>
    <String, dynamic>{
      'type': instance.type,
      'value': instance.value,
      'componentId': instance.componentId,
    };
