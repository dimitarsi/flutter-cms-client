import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plenty_cms/helpers/slugify.dart';
import 'package:plenty_cms/service/client/client.dart';
import 'package:plenty_cms/service/models/field_type.dart';
import 'package:plenty_cms/service/models/story_config.dart';
import 'package:plenty_cms/widgets/navigation/sidenav.dart';

import '../../app_router.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(data),
    );
  }
}

var dropdownOptions = [
  DropdownMenuEntry(
    value: FieldType.text,
    label: "Text",
  ),
  DropdownMenuEntry(
    value: FieldType.number,
    label: "Number",
  ),
  DropdownMenuEntry(
    value: FieldType.date,
    label: "Date",
  ),
  DropdownMenuEntry(
    value: FieldType.files,
    label: "Files",
  ),
  DropdownMenuEntry(
    value: FieldType.list,
    label: "List",
  ),
  DropdownMenuEntry(
    value: FieldType.ref,
    label: "Reference",
  ),
  DropdownMenuEntry(
    value: FieldType.component,
    label: "Component",
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
      padding: const EdgeInsets.all(3), minimumSize: const Size(30, 30));
  String? referenceListValue;

  @override
  void initState() {
    super.initState();

    widget.client.listStoryConfigs().then<void>((result) => referenceFields =
        result.entities.where(
            (element) => element.slug != widget.slug && element.name != null));

    if (widget.slug.isNotEmpty) {
      widget.client.getStoryConfig(widget.slug).then<void>((value) {
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
      drawer: const SideNav(),
      appBar: AppBar(),
      floatingActionButton: addFieldsButton(),
      body: DropdownButtonHideUnderline(
        child: Form(
          key: widget.contentTypeFormKey,
          child: ListView(
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
    return SizedBox(
      width: min(MediaQuery.of(context).size.width, 1024),
      child: TextFormField(
        controller: groupNameController,
        decoration: groupNameLabel,
        validator: (value) {
          return value == null || value.isEmpty
              ? "Content Type Name is required"
              : null;
        },
      ),
    );
  }

  void _addField() {
    FieldRow newRow = FieldRow(
        width: '100%',
        label: 'field_00',
        displayName: 'Field 00',
        type: FieldType.text);

    if (storyConfig == null) {
      return;
    }

    if (storyConfig!.fields == null) {
      storyConfig!.fields = [
        Field(groupName: 'GroupName 00', rows: [newRow])
      ];
    } else {
      var index = storyConfig!.fields!.length.toString();
      var field =
          Field(groupName: "Field ${index.padLeft(2, "0")}", rows: [newRow]);
      storyConfig!.fields!.add(field);
    }
  }

  void _addFieldRow(Field field) {
    setState(() {
      if (field.rows != null) {
        field.rows!.add(FieldRow(type: FieldType.text));
      } else {
        field.rows = [FieldRow(type: FieldType.text)];
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

    var screenWidth = MediaQuery.of(context).size.width;

    for (var item in storyConfig?.fields ?? []) {
      var field = TextFormField(
        initialValue: item.groupName ?? '',
        decoration: const InputDecoration(label: Text("Group Name")),
        onSaved: (newValue) {
          item.groupName = newValue;
        },
      );
      var deleteButton = _removeButton(() {
        storyConfig?.fields?.remove(item);
      });

      var addRowButton = ElevatedButton(
          onPressed: () {
            _addFieldRow(item);
          },
          child: const Text("Add Row"));

      fieldsList.add(SizedBox(
        width: min(screenWidth, 1024),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: field,
                  ),
                ),
                deleteButton
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: rows(item),
            ),
            addRowButton
          ],
        ),
      ));
    }

    fieldsList.add(ElevatedButton(
        onPressed: () => setState(_addField),
        child: const Text("Add Fields Group")));

    return Column(
      children: fieldsList,
    );
  }

  Widget _getFieldByType(FieldRow element) {
    const defaultFieldName = InputDecoration(labelText: "Field Name");

    return TextFormField(
      decoration: defaultFieldName,
      initialValue: element.displayName,
      onSaved: (value) {
        element.displayName = value.toString();
        element.label = slugify(value ?? '');
      },
    );
  }

  Widget rows(Field field) {
    List<Widget> rowsList = [];

    for (FieldRow element in field.rows ?? []) {
      var inputField = _getFieldByType(element);

      rowsList.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                child: inputField,
              ),
              // if (element.type == 'reference')
              //   ...referenceFieldsList(element),
              Flexible(
                flex: 2,
                child: Column(
                  children: [
                    DropdownMenu(
                      label: const Text("Field Type"),
                      initialSelection: element.type,
                      dropdownMenuEntries: dropdownOptions,
                      onSelected: (value) {
                        setState(() {
                          element.type = value.toString();
                        });
                      },
                    ),
                  ],
                ),
              ),
              Flexible(
                  flex: 1,
                  child: DropdownMenu(
                    label: const Text("Width"),
                    initialSelection: element.width ?? "100",
                    onSelected: (value) {
                      setState(() {
                        element.width = value;
                      });
                    },
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(label: "100%", value: "100"),
                      DropdownMenuEntry(label: "66%", value: "66"),
                      DropdownMenuEntry(label: "50%", value: "50"),
                      DropdownMenuEntry(label: "33%", value: "30"),
                    ],
                  )),
              // TextButton(
              //     onPressed: () {
              //       setState(() {
              //         element.showSettings = !element.showSettings;
              //       });
              //     },
              //     child: const Icon(Icons.settings))
              _removeButton(() {
                field.rows?.remove(element);
              })
            ],
          ),
        ),
      );
    }

    return Column(
      children: rowsList,
    );
  }

  Widget _removeButton(VoidCallback? onPressed) {
    return SizedBox(
      width: 75,
      child: IconButton(
          onPressed: () {
            setState(() {
              onPressed?.call();
            });
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          )),
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
                  Switch(value: true, onChanged: (v) {})
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
      return const SizedBox.shrink();
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
                    context.go(AppRouter.contentTypeListPath);
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
      return DropdownMenuItem<String>(value: e.slug, child: Text(e.name!));
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
      const SizedBox(
        width: 50,
        child: TextField(
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: false),
            decoration: InputDecoration(
              label: Text("Min count"),
            )),
      ),
      const SizedBox(
        width: 50,
        child: TextField(
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: false),
            decoration: InputDecoration(label: Text("Max count"))),
      ),
    ];
  }
}
