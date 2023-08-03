import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plenty_cms/service/client/client.dart';
import 'package:plenty_cms/service/data/rest_response.dart';
import 'package:plenty_cms/state/cache_options.dart';
import '../service/models/content.dart';

class ContentCubitState {
  final Map<String, RestResponse<Content>> cacheByFolderAndPage;
  final Map<String, Content> cacheByIdOrSlug;

  ContentCubitState(
      {required this.cacheByFolderAndPage, required this.cacheByIdOrSlug});

  factory ContentCubitState.fromState(ContentCubitState prev) {
    return ContentCubitState(
        cacheByFolderAndPage: prev.cacheByFolderAndPage,
        cacheByIdOrSlug: prev.cacheByIdOrSlug);
  }

  factory ContentCubitState.empty() {
    return ContentCubitState(cacheByFolderAndPage: {}, cacheByIdOrSlug: {});
  }
}

class ContentCubit extends Cubit<ContentCubitState> {
  RestClient client;
  ContentCubit(ContentCubitState initState, {required this.client})
      : super(initState);

  void loadFromFolder(
      {required String folder,
      required int page,
      CacheOptions? options}) async {
    final cacheKey = "$folder?page=$page";

    if (state.cacheByFolderAndPage.keys.contains(cacheKey) &&
        options?.reload != true) {
      return;
    }

    final result = await client.getStories(page: page, folder: folder);
    state.cacheByFolderAndPage[cacheKey] = result;

    emit(ContentCubitState.fromState(state));
  }

  void loadById(String idOrSlug) async {
    if (state.cacheByIdOrSlug.keys.contains(idOrSlug)) {
      return;
    }

    final result = await client.getStoryBySlugOrId(idOrSlug);

    if (result != null) {
      state.cacheByIdOrSlug[idOrSlug] = result;

      emit(ContentCubitState.fromState(state));
    }
  }
}
