// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
      page: json['page'] as int?,
      perPage: json['perPage'] as int?,
      count: json['count'] as int?,
      totalPages: json['totalPages'] as int?,
      nextPage: json['nextPage'] as int?,
    );

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'page': instance.page,
      'perPage': instance.perPage,
      'count': instance.count,
      'totalPages': instance.totalPages,
      'nextPage': instance.nextPage,
    };
