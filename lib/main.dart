import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plenty_cms/service/client/client.dart';
import 'package:plenty_cms/state/auth_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_router.dart';
import 'package:url_strategy/url_strategy.dart';

final publicLocations = ['/login', '/reset-password'];

void main() {
  setPathUrlStrategy();

  RestClient restClient = RestClient();

  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences.getInstance().then<void>(
    (value) async {
      restClient.token = value.getString("authToken") ?? "";

      runApp(MyApp(restClient: restClient));
    },
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.restClient});

  RestClient restClient;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var routes = AppRouter.getRouter(restClient);

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
          var state = AuthState();

          return AuthCubit(state, restClient: restClient);
        }),
      ],
      child: child,
    );
  }
}
