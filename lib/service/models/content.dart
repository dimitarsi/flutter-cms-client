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

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);

  Map<String, dynamic> toJson() => _$ContentToJson(this);

  Content cloneDeep() {
    return Content(
        id: id,
        name: name,
        type: type,
        slug: slug,
        folderLocation: folderLocation,
        folderTarget: folderTarget,
        configId: configId,
        data: data == null ? null : data!.cloneDeep());
  }
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
    children ??= [];
    children!.add(contentType);
  }

  bool getToggleDefault() {
    return true;
  }
}

// @JsonSerializable()
// class ContentData {
//   ContentData({required this.type, required this.data});

//   String? type;
//   dynamic data;

//   factory ContentData.fromJson(Map<String, dynamic> json) =>
//       _$ContentDataFromJson(json);

//   Map<String, dynamic> toJson() => _$ContentDataToJson(this);

//   Map<String, ContentData> getComponentData() {
//     return data as Map<String, ContentData>;
//   }

//   String getTextData() {
//     return data as String;
//   }

//   void setTextData(String val) {
//     data = val;
//   }

//   void setComponentData(Map<String, ContentData> val) {
//     data = val;
//   }

//   ContentData cloneDeep() {
//     return ContentData(type: type, data: jsonDecode(jsonEncode(data)));
//   }
// }
