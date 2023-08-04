import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
part 'content.g.dart';

@JsonSerializable()
class Content {
  Content(
      {this.id,
      this.name,
      this.slug,
      this.data,
      this.type,
      this.folderLocation,
      this.folderTarget,
      this.configId});

  String? id;
  String? name;
  String? slug;
  String? type;
  String? folderLocation;
  String? folderTarget;
  String? configId;

  dynamic data;

  String getDataAsString() {
    return data as String;
  }

  void setStringData(String val) {
    data = val;
  }

  List<Content> getDataAsComponent() {
    return data as List<Content>;
  }

  void setComponentData(List<Content> newList) {
    data = newList;
  }

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);

  Map<String, dynamic> toJson() => _$ContentToJson(this);
}

@JsonSerializable()
class ContentType {
  ContentType({
    required this.name,
    this.children,
    this.id,
    this.freezed = false,
    this.originalName,
    this.originalSlug,
    required this.slug,
    required this.type,
  });

  String name;
  @JsonKey(name: "_id")
  String? id;
  String type;
  String? originalName;
  String? originalSlug;

  List<ContentType>? children;
  String slug;

  @JsonKey(
    defaultValue: false,
  )
  bool freezed;

  factory ContentType.fromJson(Map<String, dynamic> json) =>
      _$ContentTypeFromJson(json);

  Map<String, dynamic> toJson() => _$ContentTypeToJson(this);

  ContentType cloneDeep() {
    final decoded = jsonDecode(jsonEncode(this));
    return ContentType.fromJson(decoded);
  }

  void addChild(ContentType contentType) {
    if (this.children == null) {
      this.children = [];
    }
    this.children!.add(contentType);
  }
}
