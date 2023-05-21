import 'package:plenty_cms/service/data/pagination.dart';

class RestResponse<T> {
  RestResponse(
      {this.entities = const [], this.pagination, this.hasError = false});

  Iterable<T> entities;
  Pagination? pagination;
  bool hasError;
}
