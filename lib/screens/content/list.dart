import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plenty_cms/app_router.dart';
import 'package:plenty_cms/service/client/client.dart';
import 'package:plenty_cms/service/models/content.dart';
import 'package:plenty_cms/widgets/navigation/sidenav.dart';

import 'modal.dart';

class StoryListScaffold extends StatelessWidget {
  const StoryListScaffold({required this.client, super.key, this.folder});

  final RestClient client;
  final String? folder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideNav(),
      appBar: AppBar(),
      body: StoryList(client: client, folder: folder),
    );
  }
}

class StoryList extends StatefulWidget {
  const StoryList({super.key, required this.client, this.folder});

  final RestClient client;
  final String? folder;

  @override
  State<StoryList> createState() => _StoryListState();
}

class _StoryListState extends State<StoryList> {
  late Iterable<Content> stories = [];

  @override
  void initState() {
    super.initState();

    loadContentEntries();
  }

  void loadContentEntries() {
    widget.client
        .getStories(page: 1, folder: widget.folder)
        .then<void>((value) => setState(
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
        if (widget.folder != null && widget.folder != '/')
          ListTile(
            title: const Text(".."),
            leading: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.arrow_upward),
            ),
            onTap: () {
              final parts = widget.folder?.split('/');

              if (parts == null || parts.length == 1) {
                context.push(AppRouter.contentListPath);
                return;
              }

              final parent = parts.getRange(0, parts.length - 1).join("/");
              context.push("${AppRouter.contentListPath}?folder=$parent");
            },
          ),
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

                final iconType = el.type == 'folder'
                    ? const Icon(Icons.folder)
                    : const Icon(Icons.edit_document);

                return ListTile(
                  title: Text(el.name!),
                  leading: SizedBox(
                    height: 40,
                    width: 40,
                    child: iconType,
                  ),
                  onTap: () {
                    if (el.type == 'folder') {
                      context.push(
                          "${AppRouter.contentListPath}?folder=${el.slug}");
                    } else {
                      context.go(AppRouter.getContentEditPath(el.slug!));
                    }
                  },
                );
              },
              itemCount: availableItems.length,
            ),
          ),
        ElevatedButton(
            onPressed: openBottomSheet, child: const Text("Add New Item"))
      ],
    );
  }

  void openBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ContentModalCreate(
            client: widget.client,
            folder: widget.folder ?? "/",
            onFolderCreated: () {
              loadContentEntries();
              context.pop();
            },
            onDocumentCreated: (newId) {
              if (context.mounted) {
                context.go(AppRouter.getContentEditPath(newId));
              }
            },
          );
        });
  }
}
