import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:plenty_cms/widgets/navigation/sidenav.dart';
import 'package:plenty_cms/state/auth_cubit.dart';

class StoryListScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideNav(),
      appBar: AppBar(),
      body: const StoryList(),
    );
  }
}

class StoryList extends StatefulWidget {
  const StoryList({super.key});

  @override
  State<StoryList> createState() => _StoryListState();
}

class _StoryListState extends State<StoryList> {
  late List<dynamic> stories = [];

  @override
  void initState() {
    super.initState();
    var token = context.read<AuthCubit>().state.token ?? '';

    get(Uri.parse('http://localhost:8000/stories'),
        headers: {"x-access-token": token}).then((response) {
      setState(() {
        var body = jsonDecode(response.body);
        stories = body["items"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var availableItems = stories.where((element) => element["name"] != null);

    return ListView.builder(
      itemBuilder: (context, index) {
        var el = availableItems.elementAt(index);
        return ListTile(
          title: Text(el["name"]),
          onTap: () {
            context.go("/story/${el["slug"]}");
          },
        );
      },
      itemCount: availableItems.length,
    );
  }
}
