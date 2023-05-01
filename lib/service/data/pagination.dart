import 'package:json_annotation/json_annotation.dart';

part 'pagination.g.dart';

@JsonSerializable()
class Pagination {
  Pagination(
      {this.page, this.perPage, this.count, this.totalPages, this.nextPage});

  int? page = 0;
  int? perPage = 0;
  int? count = 0;
  int? totalPages = 0;
  int? nextPage = 0;

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}
