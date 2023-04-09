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
    ['/todos', 'Todos', {}],
    [
      '/pages/foo',
      'Pages - Foo',
      {'slug': 'foo'}
    ],
    [
      '/pages/bar',
      'Pages - Bar',
      {'slug': 'bar'}
    ]
  ];

  List<Widget> routes(BuildContext context) {
    var widgets = <Widget>[];

    // routesMap.forEach((key, value) => {
    //       widgets.add(
    //           TextButton(onPressed: () => context.go(key), child: Text(value)))
    //     });

    for (var element in routesMap) {
      widgets.add(
        TextButton(
          onPressed: () => context.go(Uri(
            path: element[0].toString(),
          ).toString()),
          child: Text(element[1].toString()),
        ),
      );
    }

    return widgets;
  }
}
