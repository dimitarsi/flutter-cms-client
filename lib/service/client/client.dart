import 'dart:convert';

import 'package:http/http.dart';
import 'package:plenty_cms/service/data/rest_response.dart';
import 'package:plenty_cms/service/models/story.dart';

import '../models/story_config.dart';
import '../models/user_auth.dart';
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
    var body = jsonDecode(response.body) as Map<String, dynamic>;

    if (body["pagination"] == null || body["items"] == null) {
      return RestResponse(hasError: true);
    }

    List<StoryConfigResponse> items = [];

    try {
      if (body["items"] != null) {
        var validItems = (body["items"]).where(
            (element) => element['_id'] != null && element['slug'] != null);
        for (var item in validItems.toList()) {
          items.add(StoryConfigResponse.fromJson(item));
        }
      }
    } catch (e) {
      rethrow;
    }

    return RestResponse(
        pagination: Pagination.fromJson(body["pagination"]), entities: items);
  }

  Future<void> createStoryConfig(StoryConfigRequest data) async {
    await post(storyConfigUrl, headers: allHeaders, body: data.toJson());
  }

  Future<void> updateStoryConfig(StoryConfigRequest data) async {
    await patch(storyConfigUrl, headers: allHeaders, body: data.toJson());
  }

  Future<void> createStory(Story story) async {
    await post(storyUrl, headers: allHeaders, body: jsonEncode(story.toJson()));
  }

  Future<void> updateStory(String slugOrId, Story story) async {
    await patch(Uri.parse("$storyUrl/$slugOrId"),
        headers: allHeaders, body: jsonEncode(story.toJson()));
  }

  Future<RestResponse<Story>> getStories({page = 1}) async {
    final response =
        await get(Uri.parse("$storyUrl?page=$page"), headers: authHeader);
    final body = jsonDecode(response.body);

    List<Story> items = [];

    try {
      if (body["items"] != null) {
        (body["items"] as List<dynamic>).forEach((element) {
          items.add(Story.fromJson(element));
        });
      }
    } catch (e) {
      print("Error parsing getStory() items");
      rethrow;
    }

    return RestResponse(
        pagination: Pagination.fromJson(body["pagination"]), entities: items);
  }

  Future<Story?> getStoryBySlugOrId(String slugOrId) async {
    final response =
        await get(Uri.parse("$storyUrl/$slugOrId"), headers: authHeader);

    if (response.statusCode < 300) {
      return Story.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  Future<LoginResponse> tryLogin(UserCredentials data) async {
    var response = await post(loginUrl,
        headers: contentTypeHeaders, body: jsonEncode(data.toJson()));

    var res = LoginResponse.fromJson(jsonDecode(response.body));

    return res;
  }
}
