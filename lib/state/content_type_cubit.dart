import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plenty_cms/service/client/client.dart';
import 'package:plenty_cms/service/data/rest_response.dart';

import '../service/models/content.dart';

class ContentTypeState {
  ContentTypeState(
      {Map<String, RestResponse<ContentType>>? listCache,
      Map<String, ContentType>? singleCache}) {
    cacheByPage = listCache ?? {};
    cacheById = singleCache ?? {};
  }

  late Map<String, RestResponse<ContentType>> cacheByPage;
  late Map<String, ContentType> cacheById;
}

class ContentTypeCubit extends Cubit<ContentTypeState> {
  RestClient client;

  ContentTypeCubit(ContentTypeState initialState, {required this.client})
      : super(initialState);

  void loadPage({int page = 1, bool reload = false}) async {
    final pageIsLoaded = state.cacheByPage.keys.contains(page);

    if (pageIsLoaded && reload == false) {
      return;
    }

    final resp = await client.listStoryConfigs(page: page);
    state.cacheByPage["$page"] = resp;

    emit(ContentTypeState(
        listCache: state.cacheByPage, singleCache: state.cacheById));
  }

  void loadSingle({required String idOrSlug, bool reload = false}) async {
    final itemIsLoaded = state.cacheById.keys.contains(idOrSlug);

    if (itemIsLoaded && reload == false) {
      return;
    }

    final resp = await client.getStoryConfig(idOrSlug);
    state.cacheById[idOrSlug] = resp;

    emit(ContentTypeState(
        listCache: state.cacheByPage, singleCache: state.cacheById));
  }

  void update(ContentType contentType) async {
    await client.updateStoryConfig(contentType);

    if (contentType.id != null && contentType.id!.isNotEmpty) {
      state.cacheById[contentType.id!] = contentType;
    }

    emit(ContentTypeState(
        listCache: state.cacheByPage, singleCache: state.cacheById));
  }
}
