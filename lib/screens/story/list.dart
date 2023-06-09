
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
                    context.go("/story/${el.slug}");
                  },
                );
              },
              itemCount: availableItems.length,
            ),
          ),
        ElevatedButton(
            onPressed: () => context.go('/story'),
            child: const Text("Create new Story"))
      ],
    );
  }
}
