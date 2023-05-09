import 'dart:convert';

import 'package:http/http.dart';
import 'package:plenty_cms/service/data/rest_response.dart';

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
      print(
          ">> items is list ${body['items'] is List} and ${(body['items'] as List).length}");
      if (body["items"] != null) {
        print("body is a list");
        var validItems = (body["items"]).where(
            (element) => element['_id'] != null && element['slug'] != null);
        // .map((e) => StoryConfigResponse.fromJson(e));
        // print("after where");
        for (var item in validItems.toList()) {
          // print("add $item");
          items.add(StoryConfigResponse.fromJson(item));
          // items.add(StoryConfigResponse.fromJson({
          //   '_id': '6442337d0e9d1aaf978f1eff',
          //   'fields': [
          //     {
          //       'groupName': 'Group Name',
          //       'rows': [
          //         [
          //           {'width': '100%', 'field': 'FirstName'},
          //           {'width': '100%', 'field': 'LastName'}
          //         ]
          //       ]
          //     }
          //   ],
          //   'name': 'Base Config',
          //   'slug': 'baseConfig6',
          //   'tags': ['base'],
          //   'features': [
          //     {'type': 'likes', 'enabled': false},
          //     {'type': 'comments', 'enabled': false},
          //     {'type': 'ratings', 'enabled': false},
          //   ]
          // }));
        }
        print("added items ${items.length}");
      } else {
        print("body is not a list");
      }
    } catch (e) {
      print(e);
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

  Future<LoginResponse> tryLogin(UserCredentials data) async {
    print("class $hashCode | token $token");

    var response = await post(loginUrl,
        headers: contentTypeHeaders, body: jsonEncode(data.toJson()));

    var res = LoginResponse.fromJson(jsonDecode(response.body));

    return res;
  }
}
