// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentType _$ContentTypeFromJson(Map<String, dynamic> json) => ContentType(
      name: json['name'] as String,
      fields: (json['fields'] as List<dynamic>?)
          ?.map((e) => Field.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['_id'] as String?,
      slug: json['slug'] as String,
    );

Map<String, dynamic> _$ContentTypeToJson(ContentType instance) =>
    <String, dynamic>{
      'name': instance.name,
      'fields': instance.fields,
      '_id': instance.id,
      'slug': instance.slug,
    };

Field _$FieldFromJson(Map<String, dynamic> json) => Field(
      groupName: json['groupName'] as String?,
      rows: (json['rows'] as List<dynamic>?)
          ?.map((e) => FieldRow.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..id = json['_id'] as String?;

Map<String, dynamic> _$FieldToJson(Field instance) => <String, dynamic>{
      'groupName': instance.groupName,
      'rows': instance.rows,
      '_id': instance.id,
    };

FieldRow _$FieldRowFromJson(Map<String, dynamic> json) => FieldRow(
      width: json['width'] as String?,
      slug: json['slug'] as String?,
      displayName: json['displayName'] as String?,
      type: json['type'] as String?,
      data: (json['data'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    )..component = json['component'] == null
        ? null
        : Field.fromJson(json['component'] as Map<String, dynamic>);

Map<String, dynamic> _$FieldRowToJson(FieldRow instance) => <String, dynamic>{
      'slug': instance.slug,
      'displayName': instance.displayName,
      'type': instance.type,
      'width': instance.width,
      'data': instance.data,
      'component': instance.component,
    };
