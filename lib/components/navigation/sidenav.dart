import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SideNav extends Drawer {
  SideNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: routes(context),
        ),
      )),
    );
  }

  final Map routesMap = {'/': "Home Page", "/login": "Login Page"};

  List<Widget> routes(BuildContext context) {
    var widgets = <Widget>[];

    routesMap.forEach((key, value) => {
          widgets.add(
              TextButton(onPressed: () => context.go(key), child: Text(value)))
        });

    return widgets;
  }
}
