import 'package:json_annotation/json_annotation.dart';

part 'content_data.g.dart';

@JsonSerializable()
class ContentData {
  ContentData({required this.type, required this.value, this.componentId});

  String type;
  dynamic value;
  String? componentId;

  factory ContentData.fromJson(Map<String, dynamic> json) =>
      _$ContentDataFromJson(json);

  Map<String, dynamic> toJson() => _$ContentDataToJson(this);

  Map<String, ContentData> getComponentData() {
    return value as Map<String, ContentData>;
  }

  String getTextData() {
    return value as String;
  }

  void setTextData(String val) {
    value = val;
  }

  void setComponentData(Map<String, ContentData> val) {
    value = val;
  }
}
