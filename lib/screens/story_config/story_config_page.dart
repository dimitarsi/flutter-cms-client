import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:plenty_cms/helpers/slugify.dart';
import 'package:plenty_cms/service/client/client.dart';
import 'package:plenty_cms/service/models/story_config.dart';
import 'package:plenty_cms/widgets/navigation/sidenav.dart';
import 'package:http/http.dart';
import 'package:plenty_cms/state/auth_cubit.dart';

class StoryConfigPage extends StatefulWidget {
  StoryConfigPage({super.key, required this.slug, required this.client});

  String slug;

  RestClient client;
  final GlobalKey<FormState> contentTypeFormKey = GlobalKey();

  @override
  State<StoryConfigPage> createState() => _StoryConfigPageState();
}

class PaddedText extends StatelessWidget {
  final String data;

  const PaddedText(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text(data),
    );
  }
}

const dropdownOptions = [
  DropdownMenuItem(
    value: "text",
    child: PaddedText("Text"),
  ),
  DropdownMenuItem(
    value: "number",
    child: PaddedText("Number"),
  ),
  DropdownMenuItem(
    value: "date",
    child: PaddedText("Date"),
  ),
  DropdownMenuItem(
    value: "gallery",
    child: PaddedText("Gallery"),
  ),
  DropdownMenuItem(
    value: "list",
    child: PaddedText("List"),
  ),
  DropdownMenuItem(
    value: "reference",
    child: PaddedText("Reference"),
  ),
  DropdownMenuItem(
    value: "custom",
    child: PaddedText("Custom"),
  ),
];

class GroupConfig {
  GroupConfig(
      {required this.displayName,
      required this.type,
      this.width = '100%',
      this.value = '',
      this.label = ''}) {
    if (label.isEmpty) {
      label = displayName.replaceAll(RegExp(r'\s+'), "_").toLowerCase();
    }

    controller =
        TextEditingController.fromValue(TextEditingValue(text: displayName));
  }

  String label;
  String displayName;
  String type;
  String width;
  String value;
  late TextEditingController controller;
  final int _uniqId = Random.secure().nextInt(999);
  final int _uniqIdAgain = Random.secure().nextInt(999);

  String get uuid => "$_uniqId-$_uniqIdAgain";

  bool showSettings = false;
  bool hasDefaultValue = false;

  Map<String, String> toJson() {
    return {
      "label": label,
      "displayName": displayName,
      "type": type,
      "width": width,
    };
  }
}

class _StoryConfigPageState extends State<StoryConfigPage> {
  StoryConfigResponse? storyConfig;
  late Iterable<StoryConfigResponse> referenceFields;
  final TextEditingController groupNameController = TextEditingController();
  final groupNameLabel = const InputDecoration(labelText: "Content type name");
  ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15));
  ButtonStyle addFieldOrRowButtonStyle = ElevatedButton.styleFrom(
      padding: EdgeInsets.all(3), minimumSize: Size(30, 30));
  String? referenceListValue;

  @override
  void initState() {
    super.initState();

    widget.client.listStoryConfigs().then((result) => referenceFields =
        result.entities.where(
            (element) => element.slug != widget.slug && element.name != null));

    if (widget.slug.isNotEmpty) {
      widget.client.getStoryConfig(widget.slug).then((value) {
        setState(() {
          groupNameController.value = TextEditingValue(text: value.name ?? '');
          storyConfig = value;
        });
      });
    } else {
      storyConfig = StoryConfigResponse();
      _addField();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideNav(),
      appBar: AppBar(),
      floatingActionButton: addFieldsButton(),
      body: DropdownButtonHideUnderline(
        child: Form(
          key: widget.contentTypeFormKey,
          child: Column(
            children: [
              pageTitle(),
              Container(
                height: 80,
              ),
              nameSection(),
              fields(),
              saveButtons()
            ],
          ),
        ),
      ),
    );
  }

  Widget pageTitle() {
    return Text(
      "Content Types",
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }

  Widget nameSection() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          SizedBox(
            width: 300,
            child: TextField(
              controller: groupNameController,
              decoration: groupNameLabel,
            ),
          ),
          const Divider()
        ],
      ),
    );
  }

  void _addField() {
    FieldRow newRow = FieldRow(
        width: '100%',
        label: 'field_00',
        displayName: 'Field 00',
        type: 'text');

    if (storyConfig == null) {
      return;
    }

    if (storyConfig!.fields == null) {
      storyConfig!.fields = [
        Field(groupName: 'GroupName 00', rows: [newRow])
      ];
    } else {
      var field = Field(groupName: "Field ${storyConfig!.fields!.length}");
      storyConfig!.fields!.add(field);
    }
  }

  void _addFieldRow(Field field) {
    setState(() {
      if (field.rows != null) {
        field.rows!.add(FieldRow());
      } else {
        field.rows = [FieldRow()];
      }
    });
  }

  void _createOrUpdate() async {
    final formState = widget.contentTypeFormKey.currentState!;
    final valid = formState.validate();

    if (!valid) {
      return;
    }

    formState.save();

    if (widget.slug.isEmpty) {
      widget.client.createStoryConfig(StoryConfigRequest(
          slug: slugify(groupNameController.text),
          name: groupNameController.text,
          fields: storyConfig?.fields));
    } else {
      widget.client.updateStoryConfig(StoryConfigRequest(
          slug: widget.slug,
          name: groupNameController.text,
          fields: storyConfig?.fields));
    }
  }

  Widget fields() {
    List<Widget> fieldsList = [];

    for (var item in storyConfig?.fields ?? []) {
      fieldsList.add(Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: item.groupName ?? '',
                  decoration: InputDecoration(label: Text("Group Name")),
                  onSaved: (newValue) {
                    item.groupName = newValue;
                  },
                ),
              )),
              IconButton(
                onPressed: () {
                  setState(() {
                    storyConfig?.fields?.remove(item);
                  });
                },
                icon: Icon(Icons.delete),
              )
            ],
          ),
          rows(item),
          ElevatedButton(
              onPressed: () {
                _addFieldRow(item);
              },
              child: Text("Add Row"))
        ],
      ));
    }

    return Column(
      children: [
        ...fieldsList,
        ElevatedButton(
            onPressed: () => setState(_addField),
            child: Text("Add Fields Group"))
      ],
    );
  }

  Widget rows(Field field) {
    List<Widget> rowsList = [];

    const fieldName = InputDecoration(labelText: "Field Name");

    for (FieldRow element in field.rows ?? []) {
      rowsList.add(Row(
        key: Key(element.hashCode.toString()),
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 5),
            width: min(MediaQuery.of(context).size.width - 20, 1200),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    width: 2, color: Color.fromARGB(179, 208, 208, 208)),
                color: Color.fromARGB(221, 240, 240, 240)),
            child: Column(
              children: [
                SizedBox(
                  width: 1200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConstrainedBox(
                        constraints:
                            BoxConstraints(minWidth: 100, maxWidth: 300),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              decoration: fieldName,
                              // controller: element.controller,
                              onChanged: (value) => setState(() {
                                element.displayName = value.toString();
                                element.label = slugify(value);
                              }),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                element.label ?? 'Label',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 10,
                      ),
                      // if (element.type == 'reference')
                      //   ...referenceFieldsList(element),
                      Container(
                        width: 10,
                      ),
                      ConstrainedBox(
                        constraints:
                            BoxConstraints(minWidth: 100, maxWidth: 300),
                        child: Column(
                          children: [
                            DropdownButton(
                              isExpanded: true,
                              elevation: 10,
                              // alignment: AlignmentDirectional.bottomCenter,
                              items: dropdownOptions,
                              hint: Text("Field Type"),
                              value: element.type,
                              onChanged: (val) {
                                setState(() {
                                  element.type = val.toString();
                                });
                              },
                            ),
                            Container(
                              height: 1,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 10,
                      ),
                      // TextButton(
                      //     onPressed: () {
                      //       setState(() {
                      //         element.showSettings = !element.showSettings;
                      //       });
                      //     },
                      //     child: const Icon(Icons.settings))
                    ],
                  ),
                ),
                // elementSettings(element),
              ],
            ),
          ),
          Container(
            width: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ElevatedButton(
                style: addFieldOrRowButtonStyle.merge(
                    ElevatedButton.styleFrom(backgroundColor: Colors.red)),
                onPressed: () {
                  setState(() {
                    field.rows?.remove(element);
                  });
                },
                child: Icon(
                  Icons.delete,
                  size: 10,
                )),
          )
        ],
      ));
    }

    return Column(
      children: rowsList,
    );
  }

  Widget elementSettings(GroupConfig element) {
    if (!element.showSettings) {
      return Container();
    }

    return Column(
      children: [
        const Text("Settings"),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 100,
              child: TextField(
                decoration: InputDecoration(labelText: "Width"),
              ),
            ),
            const SizedBox(
              width: 20,
              height: 20,
            ),
            if (['text', 'number']
                    .indexWhere((options) => options == element.type) >
                -1)
              SizedBox(
                width: 100,
                child: TextField(
                    decoration:
                        const InputDecoration(labelText: "Default Value"),
                    keyboardType: element.type == 'number'
                        ? TextInputType.number
                        : TextInputType.text),
              ),
            if (element.type == 'date')
              Row(
                children: [
                  const Text("Set current date as default:"),
                  Switch(value: true, onChanged: (_v) {})
                ],
              )
          ],
        ),
      ],
    );
  }

  Widget addFieldsButton() {
    return FloatingActionButton(
      onPressed: _addField,
      child: const Icon(Icons.add_task),
    );
  }

  Widget saveButtons() {
    if (storyConfig == null) {
      return SizedBox.shrink();
    }

    var nonEmptyConfigList = (storyConfig?.fields ?? [])
        .where((element) =>
            element.groupName != null && element.groupName!.isNotEmpty)
        .toList();

    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: SizedBox(
        width: 450,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: () {
                  if (GoRouter.of(context).canPop()) {
                    GoRouter.of(context).pop();
                  } else {
                    context.go('/story-config-list');
                  }
                },
                child: const Text("Cancel")),
            GestureDetector(
              onTap: () {
                if (nonEmptyConfigList.isEmpty) {
                  showModalBottomSheet(
                      context: context,
                      builder: (_) => const Text("Hello World"));
                }
              },
              child: ElevatedButton(
                onPressed: nonEmptyConfigList.isEmpty ? null : _createOrUpdate,
                style: buttonStyle,
                child: Text(widget.slug.isEmpty ? "Create" : "Update"),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> referenceFieldsList(GroupConfig element) {
    List<DropdownMenuItem<String>> items = referenceFields.map((e) {
      return DropdownMenuItem<String>(child: Text(e.name!), value: e.slug);
    }).toList();
    return [
      Expanded(
        flex: 1,
        child: DropdownButton<String>(
          items: items,
          value: referenceListValue,
          onChanged: (Object? value) {
            setState(() {
              referenceListValue = value.toString();
            });
          },
        ),
      ),
      SizedBox(
        width: 50,
        child: TextField(
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: false),
            decoration: InputDecoration(
              label: Text("Min count"),
            )),
      ),
      SizedBox(
        width: 50,
        child: TextField(
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: false),
            decoration: InputDecoration(label: Text("Max count"))),
      ),
    ];
  }
}
