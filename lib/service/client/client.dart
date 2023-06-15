import 'dart:convert';

import 'package:file_picker/file_picker.dart';
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
  Uri get storySearchUrl => Uri.parse("$url/stories/search");
  Uri get loginUrl => Uri.parse("$url/login");
  Uri get logoutUrl => Uri.parse("$url/logout");
  Uri get usersUrl => Uri.parse("$url/users");
  Uri get attachmentsUrl => Uri.parse("$url/attachments");
  Uri get validateTokenUrl => Uri.parse("$url/check");

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
    await post(storyConfigUrl,
        headers: allHeaders, body: jsonEncode(data.toJson()));
  }

  Future<void> updateStoryConfig(StoryConfigRequest data) async {
    await patch(Uri.parse("$storyConfigUrl/${data.slug}"),
        headers: allHeaders, body: jsonEncode(data.toJson()));
  }

  Future<String> createStory(Story story) async {
    final result = await post(storyUrl,
        headers: allHeaders, body: jsonEncode(story.toJson()));
    final json = jsonDecode(result.body);

    return json['id'];
  }

  Future<void> updateStory(String slugOrId, Story story) async {
    await patch(Uri.parse("$storyUrl/$slugOrId"),
        headers: allHeaders, body: jsonEncode(story.toJson()));
  }

  Future<RestResponse<Story>> getStories({page = 1, String? folder}) async {
    var url = Uri.parse("$storySearchUrl");

    if (folder != null && folder.isNotEmpty) {
      url = url.replace(
          queryParameters: <String, String>{"page": "$page", "folder": folder});
    } else {
      url = url.replace(queryParameters: <String, String>{"page": "$page"});
    }

    final response = await get(url, headers: authHeader);
    final body = jsonDecode(response.body);

    List<Story> items = [];

    try {
      if (body["items"] != null) {
        for (var element in (body["items"] as List<dynamic>)) {
          items.add(Story.fromJson(element));
        }
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
      final decoded = jsonDecode(response.body);
      final asJson = Story.fromJson(decoded);

      return asJson;
    }

    throw Error.safeToString(
        "Ups something went wrong in `getStoryBySlugOrId`");
  }

  Future<LoginResponse> tryLogin(UserCredentials data) async {
    var response = await post(loginUrl,
        headers: contentTypeHeaders, body: jsonEncode(data.toJson()));

    var res = LoginResponse.fromJson(jsonDecode(response.body));

    return res;
  }

  Future<List<dynamic>> uploadFiles(List<PlatformFile> files) async {
    var request = MultipartRequest('post', attachmentsUrl);

    request.headers.addAll(authHeader);

    for (final f in files) {
      if (f.bytes != null) {
        request.files.add(MultipartFile.fromBytes(
            "attachments", f.bytes as List<int>,
            filename: f.name));
      }
    }

    try {
      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      return jsonDecode(responseData);
    } catch (e) {
      print("Couldn't upload file");
      print(e.toString());
    }

    return [];
  }

  String getImageUrlFromHash(String id) {
    return "$url/media/$id";
  }

  Future<bool> validateToken() async {
    if (token.isEmpty) {
      return false;
    }

    try {
      final data = await get(validateTokenUrl, headers: authHeader);
      return data.statusCode == 200;
    } catch (_e) {
      return false;
    }
  }
}
