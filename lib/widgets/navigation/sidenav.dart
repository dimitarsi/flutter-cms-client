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

  final routesMap = [
    ['/', 'Home', {}],
    ['/login', 'Login', {}],
    ['/story-config-list', 'Content Types', {}],
    [
      '/story-configs',
      'Content Types Create',
      {'slug': ''}
    ],
    ['/story-list', 'Story', {}]
  ];

  List<Widget> routes(BuildContext context) {
    final widgets = routesMap.map((element) {
      final path = "${element.elementAt(0)}";
      final label = "${element.elementAt(1)}";

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
