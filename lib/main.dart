import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:plenty_cms/state/auth_cubit.dart';
import 'package:plenty_cms/state/todos_cubit.dart';
import 'package:plenty_cms/views/error/error_page.dart';
import 'package:plenty_cms/views/pages/page.dart';
import 'package:plenty_cms/views/story_config/story_config_list.dart';
import 'package:plenty_cms/views/todos/todo_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'views/auth/login_page.dart';
import 'views/home/home_page.dart';
import 'package:url_strategy/url_strategy.dart';

import 'views/story_config/story_config_page.dart';

var publicLocations = ['/login', '/reset-password', '/story-configs'];

void main() {
  setPathUrlStrategy();
  SharedPreferences.getInstance()
      .then(
        (value) => runApp(MyApp(
          token: value.getString("authToken"),
        )),
      )
      .catchError(() => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, this.token});

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
            path: '/story-configs',
            builder: (context, state) => StoryConfigList()),
        GoRoute(
            path: '/story-configs/:slug',
            builder: (context, state) =>
                StoryConfigPage(slug: state.params['slug'] ?? ''))
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
        BlocProvider<AuthCubit>(
            create: (_) =>
                AuthCubit(AuthState(token: token, isLoggedIn: token != null))),
        BlocProvider<TodosCubit>(create: (_) => TodosCubit([]))
      ],
      child: child,
    );
  }
}
