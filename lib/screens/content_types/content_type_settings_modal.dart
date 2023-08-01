import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';

import '../../service/models/content.dart';

class ContentTypeSettingsModal extends StatefulWidget {
  ContentTypeSettingsModal(
      {super.key,
      required this.items,
      required this.contentType,
      this.close,
      this.save});

  final List<ContentType> items;

  void Function()? close;
  void Function()? save;

  final ContentType contentType;

  @override
  State<ContentTypeSettingsModal> createState() =>
      _ContentTypeSettingsModalState();
}

final List<dynamic> buttonTypes = [
  {"text": "Text", "color": Colors.red, "type": "text"},
  {"text": "Number", "color": Colors.blue.shade200, "type": "number"},
  {"text": "Date", "color": Colors.green, "type": "date"},
  {"text": "Toggle", "color": Colors.orange, "type": "toggle"},
  {"text": "Rich Text", "color": Colors.purple, "type": "rich-text"},
  {"text": "Media", "color": Colors.yellow.shade700, "type": "media"},
];

class _ContentTypeSettingsModalState extends State<ContentTypeSettingsModal>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;

  String selectedType = "text";

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    selectedType = widget.contentType.type;
  }

  @override
  Widget build(BuildContext context) {
    final buttons = buttonTypes
        .map((e) => Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: e["type"] == selectedType
                          ? Colors.black
                          : Colors.transparent,
                      width: 2)),
              child: TextButton(
                style: TextButton.styleFrom(
                    padding: EdgeInsets.all(0),
                    backgroundColor: e["color"],
                    foregroundColor: Colors.white),
                child: Text(e["text"]),
                onPressed: () {
                  setState(() {
                    selectedType = e["type"];
                  });
                },
              ),
            ))
        .toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  tabController.animateTo(0);
                },
                child: Text("Settings")),
            TextButton(
                onPressed: () {
                  tabController.animateTo(1);
                },
                child: Text("Pick Existing"))
          ],
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.loose,
          child: TabBarView(
              controller: tabController,
              children: [_newContentTypeSettings(buttons), _pickExisting()]),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: () {
                  widget.close?.call();
                },
                child: Text("Close")),
            TextButton(
                onPressed: () {
                  widget.contentType.type = selectedType;
                  widget.contentType.freezed = false;
                  widget.contentType.id = null;

                  widget.save?.call();
                },
                child: Text("Save"))
          ],
        )
      ],
    );
  }

  Widget _pickExisting() {
    return ListView.builder(
      itemBuilder: (context, index) {
        final current = widget.items.elementAt(index);

        return ListTile(
          title: Text(current.name),
          onTap: () {
            // TODO: highlight the selected item only, without already making the changes
            widget.contentType.id = current.id;
            widget.contentType.type = current.type;
            widget.contentType.children = [];
            widget.contentType.name = current.name;
            widget.contentType.slug = current.slug;
            widget.contentType.freezed = true;

            widget.save?.call();
          },
        );
      },
      itemCount: widget.items.length,
    );
  }

  Column _newContentTypeSettings(List<Container> buttons) {
    return Column(
      children: [
        Expanded(
            child: CustomScrollView(
          slivers: [
            SliverList.list(children: [
              CheckboxListTile(
                  value: ["root", "composite"].contains(selectedType),
                  onChanged: (_val) {
                    setState(() {
                      if (selectedType == "composite") {
                        selectedType = "text";
                      } else {
                        selectedType = "composite";
                      }
                    });
                  },
                  title: Text("Group")),
              Text("Type:"),
            ]),
            SliverGrid.extent(
              maxCrossAxisExtent: 80,
              children: buttons,
            )
          ],
        ))
      ],
    );
  }
}
