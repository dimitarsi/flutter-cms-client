import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plenty_cms/app_router.dart';
import 'package:plenty_cms/service/client/client.dart';

import '../../service/models/content.dart';

class ComponentListPage extends StatefulWidget {
  ComponentListPage({super.key, required this.client});

  RestClient client;

  @override
  State<ComponentListPage> createState() => _ComponentListPageState();
}

class _ComponentListPageState extends State<ComponentListPage> {
  @override
  void initState() {
    loadPage();

    super.initState();
  }

  List<ContentType> items = [];

  void loadPage({page = 1}) async {
    final result = await widget.client.getComponents(page: page);

    setState(() {
      items.addAll(result.entities);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        "Components",
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      Expanded(
        child: ListView.builder(
          itemBuilder: _itemBuilder,
          itemCount: items.length,
        ),
      ),
    ]);
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return ListTile(
      title: Text("${items[index].name}"),
      onTap: () {
        final itemId = items[index].id;

        if (itemId != null && itemId.isNotEmpty) {
          context.go(AppRouter.getComponentEditPath(itemId));
        }
      },
    );
  }
}
