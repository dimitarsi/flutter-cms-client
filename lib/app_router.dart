import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:plenty_cms/main.dart';
import 'package:plenty_cms/screens/components/components_list.dart';
import 'package:plenty_cms/screens/components/components_page.dart';
import 'package:plenty_cms/widgets/navigation/sidenav.dart';

import 'screens/auth/login_page.dart';
import 'screens/home/home_page.dart';
import 'screens/content/list.dart';
import 'screens/content/page.dart';
import 'screens/content_types/story_config_list.dart';
import 'screens/content_types/story_config_page.dart';
import 'service/client/client.dart';
import 'state/auth_cubit.dart';

typedef RedirectHandler = FutureOr<String?> Function(
    BuildContext, GoRouterState)?;

class AppRouter {
  static GoRouter getRouter(RestClient restClient) {
    return GoRouter(
        routes: _getRoutes(restClient), redirect: _redirect(restClient));
  }

  static RedirectHandler _redirect(RestClient restClient) {
    return (BuildContext context, state) async {
      var auth = context.read<AuthCubit>();

      var isKnownPublicRoute = publicLocations.firstWhere(
          (element) => state.location.startsWith(element),
          orElse: () => '');

      if (isKnownPublicRoute != '') {
        return null;
      }

      final isValid = await restClient.validateToken();

      if (isValid) {
        if (auth.state.isLoggedIn == false) {
          auth.userHasValidToken();
        }

        return null;
      }

      restClient.token = '';
      auth.logout();

      return '/login';
    };
  }

  static String homePath = "/";
  static String loginPath = "/login";
  static String logoutPath = "/logout";
  static String resetPasswordPath = "/reset-password/:token";
  static String contentTypeListPath = "/content-types";
  static String contentTypeCreatePath = "/content-type";
  static String contentTypeEditPath = "/content-type/:slug";
  static String contentListPath = "/content";
  static String contentEditPath = "/content/:slug";
  static String componentsListPath = "/components";
  static String componentsEditPath = "/components/:slug";

  static String getContentTypePath(String slug) => "/content-type/$slug";
  static String getContentEditPath(String slug) => "/content/$slug";
  static String getComponentEditPath(String slug) => "/components/$slug";

  static List<RouteBase> _getRoutes(RestClient restClient) {
    return [
      GoRoute(
        path: homePath,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: loginPath,
        name: 'login',
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: resetPasswordPath,
        name: 'reset-password',
        builder: (context, state) =>
            LoginPage(resetToken: state.params['token']),
      ),
      GoRoute(
          path: contentTypeListPath,
          builder: (context, state) => StoryConfigList(client: restClient)),
      GoRoute(
          path: contentTypeEditPath,
          builder: (context, state) => StoryConfigPage(
              slug: state.params['slug'] ?? '', client: restClient)),
      GoRoute(
          path: contentTypeCreatePath,
          builder: (context, state) =>
              StoryConfigPage(slug: '', client: restClient)),
      GoRoute(
        path: contentListPath,
        builder: (context, state) => StoryListScaffold(
            client: restClient, folder: state.queryParams["folder"]),
      ),
      GoRoute(
        path: componentsListPath,
        builder: (context, state) => Scaffold(
          drawer: SideNav(),
          appBar: AppBar(),
          body: ComponentListPage(client: restClient),
        ),
      ),
      GoRoute(
        path: componentsEditPath,
        builder: (context, state) => Scaffold(
          drawer: SideNav(),
          appBar: AppBar(),
          body: ComponentEditPage(
            client: restClient,
            componentId: state.params['slug'] ?? '',
          ),
        ),
      ),
      // GoRoute(
      //     path: '/story',
      //     builder: (context, state) =>
      //         StoryPageScaffold(client: restClient, slug: '')),
      GoRoute(
          path: contentEditPath,
          builder: (context, state) => StoryPageScaffold(
                slug: state.params['slug'] ?? '',
                client: restClient,
              ))
    ];
  }
}
