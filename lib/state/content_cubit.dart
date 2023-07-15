import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plenty_cms/service/client/client.dart';
import 'package:plenty_cms/service/data/rest_response.dart';
import '../service/models/content.dart';

class ContentCubitState {
  Map<String, RestResponse<Content>> cacheByPage = Map();
}

class ContentCubit extends Cubit<ContentCubitState> {
  RestClient client;
  ContentCubit(ContentCubitState initState, {required this.client})
      : super(initState);
}
