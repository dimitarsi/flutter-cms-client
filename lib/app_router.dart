import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:plenty_cms/main.dart';

import 'screens/auth/login_page.dart';
import 'screens/home/home_page.dart';
import 'screens/pages/page.dart';
import 'screens/story/list.dart';
import 'screens/story/page.dart';
import 'screens/story_config/story_config_list.dart';
import 'screens/story_config/story_config_page.dart';
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

  static List<RouteBase> _getRoutes(RestClient restClient) {
    return [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: '/reset-password/:token',
        name: 'reset-password',
        builder: (context, state) =>
            LoginPage(resetToken: state.params['token']),
      ),
      GoRoute(
          path: '/pages/:slug',
          builder: (context, state) {
            return PagesPage(
              // key: state.pageKey,
              slug: state.params['slug'] ?? 'default',
            );
          }),
      GoRoute(
          path: '/story-config-list',
          builder: (context, state) => StoryConfigList(restClient: restClient)),
      GoRoute(
          path: '/story-configs/:slug',
          builder: (context, state) => StoryConfigPage(
              slug: state.params['slug'] ?? '', client: restClient)),
      GoRoute(
          path: '/story-configs',
          builder: (context, state) =>
              StoryConfigPage(slug: '', client: restClient)),
      GoRoute(
        path: '/story-list',
        builder: (context, state) => StoryListScaffold(
          client: restClient,
        ),
      ),
      GoRoute(
          path: '/story',
          builder: (context, state) =>
              StoryPageScaffold(client: restClient, slug: '')),
      GoRoute(
          path: '/story/:slug',
          builder: (context, state) => StoryPageScaffold(
                slug: state.params['slug'] ?? '',
                client: restClient,
              ))
    ];
  }
}
