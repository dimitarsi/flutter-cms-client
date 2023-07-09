import 'package:json_annotation/json_annotation.dart';

part 'content_type.g.dart';

@JsonSerializable()
class ContentType {
  ContentType(
      {required this.name, required this.fields, this.id, required this.slug});

  String name;
  List<Field>? fields;
  @JsonKey(name: "_id")
  String? id;
  String slug;

  factory ContentType.fromJson(Map<String, dynamic> json) =>
      _$ContentTypeFromJson(json);

  Map<String, dynamic> toJson() => _$ContentTypeToJson(this);
}

@JsonSerializable()
class Field {
  Field({this.groupName, this.rows});
  String? groupName;
  List<FieldRow>? rows;

  @JsonKey(name: "_id")
  String? id;

  factory Field.fromJson(Map<String, dynamic> json) => _$FieldFromJson(json);
  Map<String, dynamic> toJson() => _$FieldToJson(this);
}

@JsonSerializable()
class FieldRow {
  FieldRow({this.width, this.slug, this.displayName, this.type, this.data});
  String? slug;
  String? displayName;
  String? type;
  String? width;
  Map<String, String>? data;

  Field? component;

  factory FieldRow.fromJson(Map<String, dynamic> json) =>
      _$FieldRowFromJson(json);

  Map<String, dynamic> toJson() => _$FieldRowToJson(this);
}
