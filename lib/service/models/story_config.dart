import 'package:json_annotation/json_annotation.dart';

part 'story_config.g.dart';

@JsonSerializable()
class StoryConfigBase {
  StoryConfigBase({this.name, this.tags, this.features, this.fields});

  String? name;
  List<String>? tags;

  StoryFeatures? features;
  List<Field>? fields;

  factory StoryConfigBase.fromJson(Map<String, dynamic> json) =>
      _$StoryConfigBaseFromJson(json);

  Map<String, dynamic> toJson() => _$StoryConfigBaseToJson(this);
}

@JsonSerializable()
class StoryConfigRequest extends StoryConfigBase {
  StoryConfigRequest(
      {this.slug, super.features, super.name, super.tags, super.fields});

  String? slug;

  factory StoryConfigRequest.fromJson(Map<String, dynamic> json) =>
      _$StoryConfigRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StoryConfigRequestToJson(this);
}

@JsonSerializable()
class StoryConfigResponse extends StoryConfigBase {
  String? slug;
  @JsonKey(name: "_id")
  String? id;

  StoryConfigResponse({this.slug, this.id, super.name});

  factory StoryConfigResponse.fromJson(Map<String, dynamic> json) =>
      _$StoryConfigResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StoryConfigResponseToJson(this);
}

@JsonSerializable()
class StoryFeatures {
  StoryFeatures({this.likes, this.comments, this.rating});
  ConfigEnabled? likes;
  ConfigEnabled? comments;
  ConfigEnabled? rating;

  factory StoryFeatures.fromJson(Map<String, dynamic> json) =>
      _$StoryFeaturesFromJson(json);
  Map<String, dynamic> toJson() => _$StoryFeaturesToJson(this);
}

@JsonSerializable()
class ConfigEnabled {
  ConfigEnabled({this.enabled});
  bool? enabled;

  factory ConfigEnabled.fromJson(Map<String, dynamic> json) =>
      _$ConfigEnabledFromJson(json);
  Map<String, dynamic> toJson() => _$ConfigEnabledToJson(this);
}

@JsonSerializable()
class Field {
  Field({this.groupName, this.rows});
  String? groupName;
  List<FieldRow>? rows;

  factory Field.fromJson(Map<String, dynamic> json) => _$FieldFromJson(json);
  Map<String, dynamic> toJson() => _$FieldToJson(this);
}

@JsonSerializable()
class FieldRow {
  FieldRow({this.width, this.label, this.displayName, this.type, this.data});
  String? label;
  String? displayName;
  String? type;
  String? width;
  Map<String, String>? data;

  factory FieldRow.fromJson(Map<String, dynamic> json) =>
      _$FieldRowFromJson(json);

  Map<String, dynamic> toJson() => _$FieldRowToJson(this);
}
