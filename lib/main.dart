import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:plenty_cms/service/client/client.dart';
import 'package:plenty_cms/state/auth_cubit.dart';
import 'package:plenty_cms/state/todos_cubit.dart';
import 'package:plenty_cms/screens/error/error_page.dart';
import 'package:plenty_cms/screens/pages/page.dart';
import 'package:plenty_cms/screens/story/list.dart';
import 'package:plenty_cms/screens/story/page.dart';
import 'package:plenty_cms/screens/story_config/story_config_list.dart';
import 'package:plenty_cms/screens/todos/todo_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/auth/login_page.dart';
import 'screens/home/home_page.dart';
import 'package:url_strategy/url_strategy.dart';

import 'screens/story_config/story_config_page.dart';

var publicLocations = ['/login', '/reset-password'];

void main() {
  setPathUrlStrategy();

  RestClient restClient = RestClient();

  SharedPreferences.getInstance().then(
    (value) {
      restClient.token = value.getString("authToken") ?? "";
      runApp(MyApp(
        restClient: restClient,
        token: value.getString("authToken"),
      ));
    },
  ).catchError(() => runApp(MyApp(restClient: restClient)));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, this.token, required this.restClient});

  RestClient restClient;

  String? token;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var routes = GoRouter(
      redirect: (context, state) {
        var auth = context.read<AuthCubit>();

        var isKnownPublicRoute = publicLocations.firstWhere(
            (element) => state.location.startsWith(element),
            orElse: () => '');

        if (auth.state.isLoggedIn || isKnownPublicRoute != '') {
          return null;
        }

        return '/login';
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => HomePage(),
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
        GoRoute(path: '/todos', builder: (context, state) => TodosPage()),
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
            builder: (context, state) =>
                StoryConfigList(restClient: restClient)),
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
      ],
      // errorBuilder: (context, state,) {
      //   print(state.);
      //   return ErrorPage();
      // },
    );

    return createProvider(MaterialApp.router(
      routerConfig: routes,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
    ));
  }

  createProvider(Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) {
          var state = AuthState(token: token, isLoggedIn: token != null);

          return AuthCubit(state, restClient: restClient);
        }),
        BlocProvider<TodosCubit>(create: (_) => TodosCubit([]))
      ],
      child: child,
    );
  }
}
