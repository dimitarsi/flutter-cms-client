import 'package:flutter/material.dart';

import '../../helpers/slugify.dart';
import '../../service/client/client.dart';
import '../../service/models/content.dart';
import '../../service/models/content_type.dart';

typedef OnFolderCreatedHandler = void Function();
typedef OnDocumentCreatedHandler = void Function(String id);

class ContentModalCreate extends StatefulWidget {
  ContentModalCreate(
      {super.key,
      required this.client,
      this.folder = "/",
      this.onFolderCreated,
      this.onDocumentCreated});

  final RestClient client;
  final GlobalKey<FormState> formKey = GlobalKey();
  final String folder;

  final OnFolderCreatedHandler? onFolderCreated;
  final OnDocumentCreatedHandler? onDocumentCreated;

  @override
  State<ContentModalCreate> createState() => _ContentModalCreateState();
}

class _ContentModalCreateState extends State<ContentModalCreate> {
  String type = "document";
  String title = "";
  String? contentTypeId;
  bool loading = true;

  List<ContentType>? contentTypes;

  // final TextEditingController dropdownController = TextEditingController();

  @override
  void initState() {
    widget.client.listStoryConfigs().then((value) {
      setState(() {
        contentTypes = value.entities.toList();
        loading = false;
      });
    });

    super.initState();
  }

  List<DropdownMenuEntry> getDropdownItems() {
    if (contentTypes == null) {
      return <DropdownMenuEntry>[];
    }

    final items = contentTypes!.where((element) {
      return element.name != null && element.id != null;
    }).map((element) {
      return DropdownMenuEntry(label: element.name!, value: element.id);
    }).toList();

    return items;
  }

  @override
  Widget build(BuildContext context) {
    Widget dropdownSelect;

    var items = getDropdownItems();

    if (type == "document" && items.isNotEmpty) {
      dropdownSelect = DropdownMenu(
        dropdownMenuEntries: items,
        onSelected: (val) {
          contentTypeId = val;
        },
      );
    } else {
      dropdownSelect = const SizedBox.shrink();
    }

    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          if (loading) const Icon(Icons.recycling),
          TextFormField(
            decoration: const InputDecoration(label: Text("Title")),
            validator: (value) {
              return (value ?? "").isEmpty ? "Title is required" : null;
            },
            onSaved: (val) {
              title = val ?? "";
            },
          ),
          dropdownSelect,
          Text("Type $type - ${getDropdownItems().length}"),
          Row(
            children: [
              const Text("Create Folder"),
              Switch(
                value: type == "folder",
                onChanged: (isFolder) {
                  setState(() {
                    type = isFolder ? "folder" : "document";
                  });
                },
              ),
            ],
          ),
          ElevatedButton(
              onPressed: () async {
                final formState = widget.formKey.currentState;

                if (formState != null && formState.validate()) {
                  formState.save();
                } else {
                  return;
                }

                String slug = slugify(title);

                if (type == "folder") {
                  slug = "${widget.folder}/$slug"
                      .replaceAll(RegExp(r'/\/{2,}/'), '/');
                }

                final data = Content(
                    data: {},
                    name: title,
                    slug: slug,
                    type: type,
                    folder: widget.folder);

                if (type == "document" && contentTypeId != null) {
                  data.configId = contentTypeId;
                }

                final newId = await widget.client.createStory(data);

                if (type == "document" && widget.onDocumentCreated != null) {
                  widget.onDocumentCreated!(newId);
                }

                if (type == "folder" && widget.onFolderCreated != null) {
                  widget.onFolderCreated!();
                }
              },
              child: const Text("Create"))
        ],
      ),
    );
  }
}
