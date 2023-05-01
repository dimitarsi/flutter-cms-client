import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:plenty_cms/widgets/navigation/sidenav.dart';
import 'package:plenty_cms/state/auth_cubit.dart';

class StoryConfig {
  StoryConfig({required this.displayName, required this.slug});

  String displayName;
  String slug;

  StoryConfig.fromJson(Map<String, dynamic> data)
      : displayName = data['displayName'],
        slug = data['slug'];

  Map<String, dynamic> toJson() => {"displayName": displayName, "slug": slug};
}

class StoryConfigList extends StatefulWidget {
  const StoryConfigList({super.key});

  @override
  State<StoryConfigList> createState() => _StoryConfigListState();
}

class _StoryConfigListState extends State<StoryConfigList> {
  int page = 1;
  int pages = 0;
  bool loading = false;
  String token = "";

  Iterable<StoryConfig> items = [];

  @override
  void initState() {
    super.initState();

    var auth = context.read<AuthCubit>();
    token = auth.state.token ?? "";

    loadPage(page);
  }

  void loadPage(int nextPage) async {
    var data = await get(
        Uri.parse("http://localhost:8000/story-configs?page=$nextPage"),
        headers: {"x-access-token": token});

    var body = jsonDecode(data.body);

    if (body["error"] != null && mounted) {
      if (body["error"].toString().toLowerCase() == "unauthorized") {
        context.read<AuthCubit>().logout();
      }
      return;
    }

    setState(
      () {
        try {
          items = (body["items"] as Iterable<dynamic>).map((e) => StoryConfig(
              displayName: e['name'] ?? "invalid",
              slug: e['slug'] ?? "invalid"));

          pages = body["pagination"]["totalPage"] ?? 0;
        } catch (_e) {
          print("error - $_e");
        }
        loading = false;
        page = nextPage;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideNav(),
      appBar: AppBar(),
      body: Column(
        children: [
          if (loading)
            Text("Loading")
          else ...[
            Expanded(child: list()),
            Container(
              height: 20,
            ),
            pagination(),
            Container(
              height: 20,
            )
          ],
        ],
      ),
    );
  }

  Widget list() {
    return ListView.builder(
      itemBuilder: (context, index) {
        var el = items.elementAt(index);

        return ListTile(
          title: Text(el.displayName),
          onTap: () {
            if (el.slug != "invalid") {
              context.go("/story-configs/${el.slug}");
            }
          },
        );
      },
      itemCount: items.length,
    );
  }

  Widget pagination() {
    List<Widget> buttons = [];

    buttons.add(TextButton(
        onPressed: page == 1 ? null : () => loadPage(1),
        child: Icon(Icons.arrow_left)));

    var lowerBoundry = max(1, page - 2);
    var upperBoundry = min(page + 2, pages);
    var medianPage = (pages / 2).floor();

    if (lowerBoundry > 2 && pages > 6) {
      buttons.add(TextButton(onPressed: () => loadPage(1), child: Text("1")));
      buttons.add(TextButton(onPressed: () => loadPage(2), child: Text("2")));
      buttons.add(Text("..."));
    }

    if (pages > 6 &&
        upperBoundry - lowerBoundry < 4 &&
        lowerBoundry > medianPage) {
      buttons.add(TextButton(
          onPressed: () => loadPage(medianPage), child: Text("$medianPage")));
      buttons.add(Text("..."));
    }

    // else if (lowerBoundry > 1) {
    //   buttons.add(TextButton(onPressed: () => loadPage(1), child: Text("1")));
    //   buttons.add(Text("..."));
    // }

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
              style: TextStyle(color: Colors.white),
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
      buttons.add(Text("..."));
      buttons.add(TextButton(
          onPressed: () => loadPage(medianPage), child: Text("$medianPage")));
    }

    if (upperBoundry < pages - 2) {
      buttons.add(Text("..."));
      buttons.add(TextButton(
          onPressed: () => loadPage(pages - 1), child: Text("${pages - 1}")));
      buttons.add(
          TextButton(onPressed: () => loadPage(pages), child: Text("$pages")));
    }

    buttons.add(TextButton(
        onPressed: page == pages ? null : () => loadPage(pages),
        child: Icon(Icons.arrow_right)));

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
}
