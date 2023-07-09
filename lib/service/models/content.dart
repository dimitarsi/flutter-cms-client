import 'package:json_annotation/json_annotation.dart';
import 'package:plenty_cms/service/models/content_type.dart';

import 'content_data.dart';

part 'content.g.dart';

@JsonSerializable()
class Content {
  Content(
      {this.id,
      this.name,
      this.slug,
      this.data,
      this.type,
      this.configId,
      this.folder,
      this.config});

  String? id;
  @JsonKey(name: "displayName")
  String? name;
  String? slug;
  String? type;
  String? configId;
  String? folder;
  Map<String, ContentData>? data;
  ContentType? config;

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);

  Map<String, dynamic> toJson() => _$ContentToJson(this);
}
