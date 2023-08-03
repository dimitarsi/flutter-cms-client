import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:plenty_cms/app_router.dart';
import 'package:plenty_cms/service/client/client.dart';
import 'package:plenty_cms/service/models/content.dart';
import 'package:plenty_cms/state/cache_options.dart';
import 'package:plenty_cms/state/content_cubit.dart';
import 'package:plenty_cms/widgets/navigation/sidenav.dart';

import 'modal.dart';

class StoryListScaffold extends StatelessWidget {
  const StoryListScaffold(
      {required this.client,
      super.key,
      required this.folder,
      required this.page});

  final RestClient client;
  final String folder;
  final int page;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideNav(),
      appBar: AppBar(),
      body: StoryList(
        client: client,
        folder: folder,
        page: page,
      ),
    );
  }
}

class StoryList extends StatefulWidget {
  const StoryList(
      {super.key,
      required this.client,
      required this.page,
      required this.folder});

  final RestClient client;
  final String folder;
  final int page;

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

  void loadContentEntries({CacheOptions? options}) {
    // widget.client
    //     .getStories(page: 1, folder: widget.folder)
    //     .then<void>((value) => setState(
    //           () {
    //             stories = value.entities;
    //           },
    //         ));

    context.read<ContentCubit>().loadFromFolder(
        folder: widget.folder, page: widget.page, options: options);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentCubit, ContentCubitState>(
        builder: (context, state) {
      final pageData =
          state.cacheByFolderAndPage["${widget.folder}?page=${widget.page}"];

      final availableItems = pageData?.entities.toList() ?? [];

      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                  onPressed: openBottomSheet,
                  child: const Text("Add New Item")),
            ),
          ),
          if (widget.folder.isNotEmpty && widget.folder != '/')
            ListTile(
              title: const Text(".."),
              leading: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(Icons.arrow_upward),
              ),
              onTap: () {
                final parts = widget.folder.split('/');
                final parent = parts.getRange(0, parts.length - 1).join("/");

                if (parent.isEmpty) {
                  context.push(AppRouter.contentListPath);
                  return;
                }

                context.push("${AppRouter.contentListPath}?folder=$parent");
              },
            ),
          if (availableItems.isEmpty)
            Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("No Items available"),
                    TextButton(
                        onPressed: openBottomSheet, child: Text("Create new"))
                  ],
                ))
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
                            "${AppRouter.contentListPath}?folder=${el.folderTarget}");
                      } else {
                        context.go(AppRouter.getContentEditPath(el.slug!));
                      }
                    },
                  );
                },
                itemCount: availableItems.length,
              ),
            ),
        ],
      );
    });
  }

  final CacheOptions _reload = CacheOptions(reload: true);

  void openBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ContentModalCreate(
            client: widget.client,
            folder: widget.folder ?? "/",
            onFolderCreated: () {
              loadContentEntries(options: _reload);
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
