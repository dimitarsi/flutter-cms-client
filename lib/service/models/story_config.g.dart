// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryConfigBase _$StoryConfigBaseFromJson(Map<String, dynamic> json) =>
    StoryConfigBase(
      name: json['name'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      features: json['features'] == null
          ? null
          : StoryFeatures.fromJson(json['features'] as Map<String, dynamic>),
      fields: (json['fields'] as List<dynamic>?)
          ?.map((e) => Field.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoryConfigBaseToJson(StoryConfigBase instance) =>
    <String, dynamic>{
      'name': instance.name,
      'tags': instance.tags,
      'features': instance.features,
      'fields': instance.fields,
    };

StoryConfigRequest _$StoryConfigRequestFromJson(Map<String, dynamic> json) =>
    StoryConfigRequest(
      slug: json['slug'] as String?,
      features: json['features'] == null
          ? null
          : StoryFeatures.fromJson(json['features'] as Map<String, dynamic>),
      name: json['name'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      fields: (json['fields'] as List<dynamic>?)
          ?.map((e) => Field.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoryConfigRequestToJson(StoryConfigRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'tags': instance.tags,
      'features': instance.features,
      'fields': instance.fields,
      'slug': instance.slug,
    };

StoryConfigResponse _$StoryConfigResponseFromJson(Map<String, dynamic> json) =>
    StoryConfigResponse(
      slug: json['slug'] as String?,
      id: json['_id'] as String?,
      name: json['name'] as String?,
    )
      ..tags =
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList()
      ..features = json['features'] == null
          ? null
          : StoryFeatures.fromJson(json['features'] as Map<String, dynamic>)
      ..fields = (json['fields'] as List<dynamic>?)
          ?.map((e) => Field.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$StoryConfigResponseToJson(
        StoryConfigResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'tags': instance.tags,
      'features': instance.features,
      'fields': instance.fields,
      'slug': instance.slug,
      '_id': instance.id,
    };

StoryFeatures _$StoryFeaturesFromJson(Map<String, dynamic> json) =>
    StoryFeatures(
      likes: json['likes'] == null
          ? null
          : ConfigEnabled.fromJson(json['likes'] as Map<String, dynamic>),
      comments: json['comments'] == null
          ? null
          : ConfigEnabled.fromJson(json['comments'] as Map<String, dynamic>),
      rating: json['rating'] == null
          ? null
          : ConfigEnabled.fromJson(json['rating'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StoryFeaturesToJson(StoryFeatures instance) =>
    <String, dynamic>{
      'likes': instance.likes,
      'comments': instance.comments,
      'rating': instance.rating,
    };

ConfigEnabled _$ConfigEnabledFromJson(Map<String, dynamic> json) =>
    ConfigEnabled(
      enabled: json['enabled'] as bool?,
    );

Map<String, dynamic> _$ConfigEnabledToJson(ConfigEnabled instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
    };

Field _$FieldFromJson(Map<String, dynamic> json) => Field(
      groupName: json['groupName'] as String?,
      rows: (json['rows'] as List<dynamic>?)
          ?.map((e) => FieldRow.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FieldToJson(Field instance) => <String, dynamic>{
      'groupName': instance.groupName,
      'rows': instance.rows,
    };

FieldRow _$FieldRowFromJson(Map<String, dynamic> json) => FieldRow(
      width: json['width'] as String?,
      label: json['label'] as String?,
      displayName: json['displayName'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$FieldRowToJson(FieldRow instance) => <String, dynamic>{
      'label': instance.label,
      'displayName': instance.displayName,
      'type': instance.type,
      'width': instance.width,
    };
