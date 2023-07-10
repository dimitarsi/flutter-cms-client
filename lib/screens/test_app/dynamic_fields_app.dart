import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/form/data.dart';
import '../../widgets/form/dynamic_field.dart';

class DynamicFieldsApp extends StatefulWidget {
  DynamicFieldsApp({super.key});

  GlobalKey<FormState> dynamicFieldsformKey = GlobalKey();

  @override
  State<DynamicFieldsApp> createState() => _DynamicFieldsAppState();
}

class _DynamicFieldsAppState extends State<DynamicFieldsApp> {
  late Content content;
  late ContentType contentType;

  @override
  void initState() {
    content = getContent();
    contentType = getContentType();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: widget.dynamicFieldsformKey,
        child: Container(
          color: Colors.green,
          child: Expanded(
            child: Column(
              children: [
                DynamicField(
                  content: content,
                  contentType: contentType,
                ),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          String contentTypeName = "";
                          GlobalKey<FormState> k = GlobalKey();
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Form(
                                  key: k,
                                  child: Column(
                                    children: [
                                      Text("Parent"),
                                      DropdownMenu(
                                          dropdownMenuEntries:
                                              _dropdownMenuEntries()),
                                      Text("Is Text:"),
                                      Switch(value: false, onChanged: (val) {}),
                                      TextFormField(
                                        onSaved: (val) {
                                          contentTypeName = val ?? "";
                                        },
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            k.currentState?.save();
                                            contentType
                                                .getComponentValue()
                                                ?.add(ContentType(
                                                    name: contentTypeName,
                                                    value: null,
                                                    type: "text"));

                                            context.pop();
                                          },
                                          child: Text("Save Content Type"))
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Text("Create new")),
                    ElevatedButton(
                        onPressed: () {
                          widget.dynamicFieldsformKey.currentState?.save();
                          print(jsonEncode(content.toJson()));
                        },
                        child: Text("Save"))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuEntry> _dropdownMenuEntries() {
    return [];
  }

  Content getContent() {
    final content = Content(type: "text", value: "Hello World");
    final topContent = Content(type: "component", value: [
      content,
      Content(type: "component", value: [
        Content(type: "text", value: ""),
        Content(type: "text", value: ""),
        Content(type: "text", value: ""),
      ])
    ]);

    return topContent;
  }

  ContentType getContentType() {
    return ContentType(
        name: "Top Content",
        value: [
          ContentType(type: "text", value: null, name: "First and Last Name"),
          ContentType(
              type: "component",
              value: [
                ContentType(type: "text", value: null, name: "Birth date"),
                ContentType(
                    type: "text", value: null, name: "Sex and orientation"),
                ContentType(
                    type: "text",
                    value: null,
                    name: "Which city you were born in?"),
              ],
              name: "More Info")
        ],
        type: "component");
  }
}
