import 'dart:convert';

import 'package:http/http.dart';
import 'package:plenty_cms/service/data/rest_response.dart';

import '../../models/story_config.dart';
import '../../models/user_auth.dart';
import '../data/pagination.dart';

const applicationJsonUtf8 = "application/json; charset=utf-8";

class RestClient {
  RestClient(
      {this.baseUrl = "http://localhost", this.port = "8000", this.token = ""});

  String port;
  String baseUrl;
  String token;

  Uri get url => Uri.parse("$baseUrl:$port");
  Map<String, String> get authHeader => {"x-access-token": token};
  Map<String, String> get contentTypeHeaders =>
      {"content-type": applicationJsonUtf8};
  Map<String, String> get allHeaders =>
      {"x-access-token": token, "content-type": applicationJsonUtf8};

  Uri get storyConfigUrl => Uri.parse("$url/story-configs");
  Uri get storyUrl => Uri.parse("$url/stories");
  Uri get loginUrl => Uri.parse("$url/login");
  Uri get logoutUrl => Uri.parse("$url/logout");
  Uri get usersUrl => Uri.parse("$url/users");

  Future<StoryConfigResponse> getStoryConfig(String idOrSlug) async {
    var getStoryConfigUrlWithIdOrSlug = Uri.parse("$storyConfigUrl/$idOrSlug");
    var response =
        await get(getStoryConfigUrlWithIdOrSlug, headers: authHeader);

    return StoryConfigResponse.fromJson(jsonDecode(response.body));
  }

  Future<RestResponse<StoryConfigResponse>> listStoryConfigs(
      {int page = 1}) async {
    var listStoryConfigWithPage = Uri.parse("$storyConfigUrl?page=$page");
    var response = await get(listStoryConfigWithPage, headers: authHeader);
    var body = jsonDecode(response.body);

    if (body["pagination"] == null || body["entities"] == null) {
      return RestResponse(hasError: true);
    }

    var items = (body["entities"] as List<Map<String, dynamic>>).map(
      (e) => StoryConfigResponse.fromJson(e),
    );

    return RestResponse(
        pagination: Pagination.fromJson(body["pagination"]),
        entities: items.toList());
  }

  Future<void> createStoryConfig(StoryConfigRequest data) async {
    await post(storyConfigUrl, headers: allHeaders, body: data.toJson());
  }

  Future<void> updateStoryConfig(StoryConfigRequest data) async {
    await patch(storyConfigUrl, headers: allHeaders, body: data.toJson());
  }

  Future<LoginResponse> tryLogin(UserCredentials data) async {
    var response = await post(loginUrl,
        headers: contentTypeHeaders, body: jsonEncode(data.toJson()));

    var res = LoginResponse.fromJson(jsonDecode(response.body));

    return res;
  }
}
