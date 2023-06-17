import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plenty_cms/app_router.dart';

class SideNav extends Drawer {
  const SideNav({super.key});

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

  List<Map<String, dynamic>> routesMap() {
    return [
      {"path": AppRouter.homePath, "label": "Home", "params": {}},
      {"path": AppRouter.loginPath, "label": "Login", "params": {}},
      {
        "path": AppRouter.contentTypeListPath,
        "label": "Content Types",
        "params": {}
      },
      {"path": AppRouter.contentListPath, "label": "Content", "params": {}},
    ];
  }

  List<Widget> routes(BuildContext context) {
    final widgets = routesMap().map((element) {
      final path = element['path'];
      final label = element['label'];

      return TextButton(
        onPressed: () {
          context.go(Uri(
            path: path,
          ).toString());
        },
        child: Text(label),
      );
    });

    return widgets.toList();
  }
}
