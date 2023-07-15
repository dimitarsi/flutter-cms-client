import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plenty_cms/screens/content_types/modal.dart';
import 'package:plenty_cms/service/client/client.dart';
import 'package:plenty_cms/widgets/navigation/sidenav.dart';

import '../../app_router.dart';
import '../../service/models/content.dart';

class StoryConfigList extends StatefulWidget {
  const StoryConfigList({super.key, required this.client});

  final RestClient client;

  @override
  State<StoryConfigList> createState() => _StoryConfigListState();
}

class _StoryConfigListState extends State<StoryConfigList> {
  int page = 1;
  int pages = 0;

  Iterable<ContentType> contentTypes = [];

  @override
  void initState() {
    super.initState();
    loadPage(page);
  }

  void loadPage(int nextPage) async {
    var data = await widget.client.listStoryConfigs(page: nextPage);

    setState(
      () {
        try {
          contentTypes = data.entities;
        } catch (_e) {
          print("error - $_e");
        }
        page = nextPage;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideNav(),
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(child: list()),
          Container(
            height: 20,
          ),
          pagination(),
          Container(
            height: 20,
          ),
          ElevatedButton(
              onPressed: openBottomSheet, child: const Text("Add New Item"))
        ],
      ),
    );
  }

  Widget list() {
    return ListView.builder(
      itemBuilder: (context, index) {
        var el = contentTypes.elementAt(index);

        if (el.name == null) {
          return ListTile(
            title: Text("Missing `name` property of item with Id: ${el.id}"),
          );
        }

        return ListTile(
          title: Text(el.name!),
          onTap: () {
            final slug = el.slug ?? '';
            if (slug.isNotEmpty && slug != "invalid") {
              context.go(AppRouter.getContentTypePath(slug));
            }
          },
        );
      },
      itemCount: contentTypes.length,
    );
  }

  Widget pagination() {
    List<Widget> buttons = [];

    buttons.add(TextButton(
        onPressed: page == 1 ? null : () => loadPage(1),
        child: const Icon(Icons.arrow_left)));

    var lowerBoundry = max(1, page - 2);
    var upperBoundry = min(page + 2, pages);
    var medianPage = (pages / 2).floor();

    if (lowerBoundry > 2 && pages > 6) {
      buttons.add(
          TextButton(onPressed: () => loadPage(1), child: const Text("1")));
      buttons.add(
          TextButton(onPressed: () => loadPage(2), child: const Text("2")));
      buttons.add(const Text("..."));
    }

    if (pages > 6 &&
        upperBoundry - lowerBoundry < 4 &&
        lowerBoundry > medianPage) {
      buttons.add(TextButton(
          onPressed: () => loadPage(medianPage), child: Text("$medianPage")));
      buttons.add(const Text("..."));
    }

    for (var index = lowerBoundry; index <= upperBoundry; index++) {
      if (page == index) {
        buttons.add(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: Colors.blueGrey,
            ),
            child: Text(
              "$page",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      } else {
        buttons.add(TextButton(
            onPressed: () => loadPage(index), child: Text("$index")));
      }
    }

    if (pages > 6 &&
        upperBoundry - lowerBoundry < 4 &&
        lowerBoundry < medianPage) {
      buttons.add(const Text("..."));
      buttons.add(TextButton(
          onPressed: () => loadPage(medianPage), child: Text("$medianPage")));
    }

    if (upperBoundry < pages - 2) {
      buttons.add(const Text("..."));
      buttons.add(TextButton(
          onPressed: () => loadPage(pages - 1), child: Text("${pages - 1}")));
      buttons.add(
          TextButton(onPressed: () => loadPage(pages), child: Text("$pages")));
    }

    buttons.add(TextButton(
        onPressed: page == pages ? null : () => loadPage(pages),
        child: const Icon(Icons.arrow_right)));

    return Column(
      children: [
        Text("Lower Boundry $lowerBoundry"),
        Text("Upper Boundry $upperBoundry"),
        Text("Pages $pages"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: buttons,
        ),
      ],
    );
  }

  void openBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return ContentTypeCreateModal(
            client: widget.client,
            onCreate: (id) {
              context.go(AppRouter.getContentTypePath(id));
            },
          );
        });
  }
}
