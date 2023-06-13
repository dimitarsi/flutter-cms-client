import 'package:json_annotation/json_annotation.dart';

part 'new_upload.g.dart';

@JsonSerializable()
class NewUpload {
  NewUpload({required this.name, this.id, this.type});

  final String name;
  String? id;
  String? type;

  factory NewUpload.fromJson(Map<String, dynamic> json) =>
      _$NewUploadFromJson(json);

  Map<String, dynamic> toJson() => _$NewUploadToJson(this);
}
