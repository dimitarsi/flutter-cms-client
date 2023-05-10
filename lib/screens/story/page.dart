import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plenty_cms/service/client/client.dart';
import 'package:plenty_cms/service/models/story.dart';
import 'package:plenty_cms/service/models/story_config.dart';
import 'package:plenty_cms/widgets/navigation/sidenav.dart';
import 'package:plenty_cms/state/auth_cubit.dart';

class StoryPageScaffold extends StatelessWidget {
  StoryPageScaffold({super.key, required this.slug, required this.client});

  String slug;

  final RestClient client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideNav(),
      appBar: AppBar(),
      body: StoryPage(
        client: client,
        slug: slug,
      ),
    );
  }
}

class StoryPage extends StatefulWidget {
  StoryPage({super.key, required this.slug, required this.client});

  String slug;
  final RestClient client;

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  TextEditingController controller = TextEditingController();
  TextEditingController dropdownController = TextEditingController();
  String? selectedConfigId;

  late Iterable<StoryConfigResponse> configs = [];

  @override
  void initState() {
    super.initState();

    widget.client.listStoryConfigs().then((value) => {
          setState(
            () => configs = value.entities,
          )
        });

    dropdownController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var dropdownChildren = configs
        .where((element) => element.id == null ? false : element.id!.isNotEmpty)
        .map<DropdownMenuEntry<String>>(
      (e) {
        return DropdownMenuEntry(label: "${e.name}", value: e.id as String);
      },
    );

    StoryConfigResponse? config;

    try {
      configs.firstWhere((element) => element.id == selectedConfigId);
    } catch (e) {}

    List<Widget> dynaimcFields = [];

    if (config != null && config.fields != null) {
      dynaimcFields = config.fields!
          .where((element) =>
              element.groupName != null && element.groupName!.isNotEmpty)
          .map((e) {
        return Text(e.groupName!);
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
                        selectedConfigId = value.toString();
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
                  var slug = controller.text
                      .replaceAll(RegExp(r'(\s+)'), "_")
                      .toLowerCase();
                  widget.client.createStory(Story(
                      name: controller.text,
                      slug: slug,
                      configId: selectedConfigId,
                      data: {}));
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
