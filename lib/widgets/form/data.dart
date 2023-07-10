import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class Content {
  Content({required this.type, required this.value});

  String type;
  dynamic value;

  String? getTextValue() {
    if (type == "text") {
      return value;
    }

    return null;
  }

  List<Content>? getComponentValue() {
    if (type == "component" && value is List) {
      return value as List<Content>;
    }

    return null;
  }

  Map<String, dynamic> toJson() => _$ContentToJson(this);

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);
}

@JsonSerializable()
class ContentType {
  ContentType({required this.name, required this.value, required this.type});
  String name;
  String type;
  dynamic value;

  List<ContentType>? getComponentValue() {
    if (type == "component") {
      return value as List<ContentType>;
    }

    return null;
  }

  Map<String, dynamic> toJson() => _$ContentTypeToJson(this);

  factory ContentType.fromJson(Map<String, dynamic> json) =>
      _$ContentTypeFromJson(json);
}
