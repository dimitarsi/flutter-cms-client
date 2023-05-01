import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:plenty_cms/widgets/navigation/sidenav.dart';
import 'package:plenty_cms/state/auth_cubit.dart';

class StoryPageScaffold extends StatelessWidget {
  StoryPageScaffold({super.key, required this.slug});

  String slug;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideNav(),
      appBar: AppBar(),
      body: StoryPage(
        slug: slug,
      ),
    );
  }
}

class StoryPage extends StatefulWidget {
  StoryPage({super.key, required this.slug});

  String slug;

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  TextEditingController controller = TextEditingController();
  TextEditingController dropdownController = TextEditingController();
  String? selectedItemSlug;

  late Iterable<dynamic> configs = [];

  @override
  void initState() {
    super.initState();

    loadConfigs();

    dropdownController.addListener(() {
      setState(() {});
    });
  }

  void loadConfigs() {
    var token = context.read<AuthCubit>().state.token ?? '';

    get(Uri.parse('http://localhost:8000/story-configs'),
        headers: {"x-access-token": token}).then((response) {
      setState(() {
        var body = jsonDecode(response.body);
        configs = body["items"];

        // print(items);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var menuItems =
        configs.where((e) => e["slug"] != null && e["fields"] != null);

    var dropdownChildren = menuItems.map<DropdownMenuEntry<String>>(
      (e) {
        return DropdownMenuEntry(
            label: "${e["name"]} ${e["slug"]}", value: e["slug"]);
      },
    );

    var config = configs.firstWhere(
        (element) => element["slug"] == selectedItemSlug,
        orElse: () => null);

    List<Widget> dynaimcFields = [];

    if (config != null && config["fields"] != null) {
      print(config["fields"]);
      dynaimcFields = (config["fields"] as List<dynamic>).map((e) {
        print(e);

        return Text("Foobar - ${e["displayName"]}");
        // var rows = (e["rows"] as List<dynamic>)
        //     .map((row) => Text(row["displayName"]))
        //     .toList();

        // return Row(
        //   children: rows,
        // );
      }).toList();
    }

    return Form(
        child: SizedBox(
      width: 510,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    label: Text("Story Name"),
                  ),
                ),
              ),
              Container(
                width: 10,
              ),
              if (dropdownChildren.isNotEmpty)
                SizedBox(
                  width: 200,
                  child: DropdownMenu(
                    label: Text("Type"),
                    dropdownMenuEntries: dropdownChildren.toList(),
                    controller: dropdownController,
                    onSelected: (value) {
                      setState(() {
                        selectedItemSlug = value.toString();
                      });
                    },
                  ),
                ),
            ],
          ),
          Text("Type ${dropdownController.text}"),
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
                onPressed: () {
                  if (controller.text.isEmpty) {
                    return;
                  }

                  var token = context.read<AuthCubit>().state.token ?? '';

                  post(Uri.parse("http://localhost:8000/stories"), headers: {
                    "x-access-token": token
                  }, body: {
                    "name": controller.text,
                    "slug": controller.text
                        .replaceAll(RegExp(r'(\s+)'), "_")
                        .toLowerCase()
                  });
                },
                child: Text("Save")),
          ),
          if (config != null)
            Row(
              children: dynaimcFields,
            )
        ],
      ),
    ));
  }
}
