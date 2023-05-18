import 'package:flutter/material.dart';
import 'package:plenty_cms/helpers/slugify.dart';
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

    if (widget.slug.isNotEmpty) {
      widget.client.getStoryBySlugOrId(widget.slug).then((value) {
        controller.value = TextEditingValue(
          text: value?.name ?? '',
        );
        selectedConfigId = value?.configId;
        dropdownController.value =
            TextEditingValue(text: value?.configId ?? '');
      });
    }
  }

  void createOrUpdateStory() {
    if (controller.text.isEmpty) {
      return;
    }

    var slug = slugify(controller.text);

    if (widget.slug.isEmpty) {
      widget.client.createStory(Story(
          name: controller.text,
          slug: slug,
          configId: selectedConfigId,
          data: {}));
    } else {
      widget.client.updateStory(
          widget.slug,
          Story(
              configId: selectedConfigId,
              name: controller.text,
              slug: widget.slug,
              data: {}));
    }
  }

  Widget dynamicFields() {
    List<Widget> dynaimcFields = [];

    StoryConfigResponse? config;
    try {
      config = configs.singleWhere(
        (element) => element.id == selectedConfigId,
      );

      if (config != null && config.fields != null) {
        dynaimcFields = config.fields!
            .where((element) =>
                element.groupName != null && element.groupName!.isNotEmpty)
            .map((e) {
          return Text(e.groupName!);
        }).toList();
      }
    } catch (e) {
      // do nothing
    }

    return Row(
      children: dynaimcFields,
    );
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

    try {
      configs.firstWhere((element) => element.id == selectedConfigId);
    } catch (e) {}

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
          dynamicFields(),
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
                onPressed: () {
                  createOrUpdateStory();
                },
                child: Text("Save")),
          ),
        ],
      ),
    ));
  }
}
