import 'package:json_annotation/json_annotation.dart';

part 'story.g.dart';

@JsonSerializable()
class Story {
  Story(
      {this.id,
      this.name,
      this.slug,
      this.data,
      this.type,
      this.configId,
      this.folder});

  String? id;
  String? name;
  String? slug;
  String? type;
  String? configId;
  String? folder;
  Map<String, dynamic>? data;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoryToJson(this);
}
