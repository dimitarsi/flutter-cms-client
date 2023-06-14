import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plenty_cms/app_router.dart';
import 'package:plenty_cms/helpers/slugify.dart';
import 'package:plenty_cms/service/client/client.dart';
import 'package:plenty_cms/service/models/story.dart';
import 'package:plenty_cms/widgets/navigation/sidenav.dart';

class StoryListScaffold extends StatelessWidget {
  const StoryListScaffold({required this.client, super.key});

  final RestClient client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideNav(),
      appBar: AppBar(),
      body: StoryList(client: client),
    );
  }
}

class StoryList extends StatefulWidget {
  const StoryList({super.key, required this.client});

  final RestClient client;

  @override
  State<StoryList> createState() => _StoryListState();
}

class _StoryListState extends State<StoryList> {
  late Iterable<Story> stories = [];

  @override
  void initState() {
    super.initState();

    loadContentEntries();
  }

  void loadContentEntries() {
    widget.client.getStories().then<void>((value) => setState(
          () {
            stories = value.entities;
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    var availableItems = stories.where((element) => element.name != null);

    return Column(
      children: [
        if (availableItems.isEmpty)
          const Text("No Items available")
        else
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                var el = availableItems.elementAt(index);
                if (el.name == null || el.slug == null) {
                  return const SizedBox.shrink();
                }

                return ListTile(
                  title: Text(el.name!),
                  onTap: () {
                    context.go(AppRouter.getContentEditPath(el.slug!));
                  },
                );
              },
              itemCount: availableItems.length,
            ),
          ),
        ElevatedButton(
            // TODO: show a bottomsheet and ask for the name
            onPressed: () => {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        final controller = TextEditingController();
                        return Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(label: Text("Title")),
                              controller: controller,
                            ),
                            TextButton(
                                onPressed: () async {
                                  final newId = await widget.client.createStory(
                                      Story(
                                          configId: "",
                                          data: {},
                                          name: controller.text,
                                          slug: slugify(controller.text)));
                                  if (context.mounted) {
                                    context.go(
                                        AppRouter.getContentEditPath(newId));
                                  }
                                },
                                child: Text("Create"))
                          ],
                        );
                      })
                },
            child: const Text("Create new Story"))
      ],
    );
  }
}
