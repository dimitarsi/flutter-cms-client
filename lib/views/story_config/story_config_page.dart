import 'dart:convert';
import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:plenty_cms/components/navigation/sidenav.dart';
import 'package:http/http.dart';

class StoryConfigPage extends StatefulWidget {
  StoryConfigPage({super.key});

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
  }

  String label;
  String displayName;
  String type;
  String width;
  String value;
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
  List<GroupConfig> groupConfigList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideNav(),
      appBar: AppBar(),
      floatingActionButton: addFieldsButton(),
      body: DropdownButtonHideUnderline(
        child: Column(
          children: [
            pageTitle(),
            Container(
              height: 80,
            ),
            nameSection(),
            groupConfingCount(),
            fileds(),
            saveButtons(context)
          ],
        ),
      ),
    );
  }

  final TextEditingController groupNameController = TextEditingController();
  final groupNameLabel = const InputDecoration(labelText: "Content type name");

  Text groupConfingCount() => Text("Fields ${groupConfigList.length}");

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

  void _addElement() {
    setState(() {
      String index = (groupConfigList.length + 1).toString().padLeft(2, '0');

      groupConfigList
          .add(GroupConfig(displayName: "Field $index", type: "text"));

      groupConfigList = groupConfigList;
    });
  }

  Widget fileds() {
    // var fields = ['Group Name', 'Type', 'Width'];

    List<Widget> fieldsList = [];

    const fieldName = InputDecoration(labelText: "Field Name");

    ButtonStyle bs = ElevatedButton.styleFrom(
        padding: EdgeInsets.all(3), minimumSize: Size(30, 30));

    var index = 0;
    for (var element in groupConfigList) {
      fieldsList.add(Row(
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
                              onChanged: (value) => setState(() {
                                element.displayName = value.toString();
                                element.label = value
                                    .toString()
                                    .replaceAll(RegExp(r'(\s+)'), "_")
                                    .toLowerCase();
                              }),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                element.label,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 10,
                      ),
                      if (element.type == 'reference')
                        ...referenceFields(element),
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
                      TextButton(
                          onPressed: () {
                            setState(() {
                              element.showSettings = !element.showSettings;
                            });
                          },
                          child: const Icon(Icons.settings))
                    ],
                  ),
                ),
                elementSettings(element),
              ],
            ),
          ),
          Container(
            width: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ElevatedButton(
                style: bs.merge(
                    ElevatedButton.styleFrom(backgroundColor: Colors.red)),
                onPressed: () {
                  setState(() {
                    groupConfigList.remove(element);
                  });
                },
                child: Icon(
                  Icons.delete,
                  size: 10,
                )),
          )
        ],
      ));
      index += 1;
    }

    return Column(
      children: [
        ...fieldsList,
        Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Container(
              height: 30,
              width: 4,
              decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(width: 3, color: Colors.lightBlueAccent)),
            )),
        ElevatedButton(
          child: Icon(
            Icons.add,
            size: 10,
          ),
          style: bs,
          onPressed: _addElement,
        )
      ],
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
      onPressed: _addElement,
      child: const Icon(Icons.add_task),
    );
  }

  ButtonStyle buttoStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15));

  Widget saveButtons(BuildContext context) {
    var nonEmptyConfigList = groupConfigList
        .where((element) => element.displayName.isNotEmpty)
        .toList();

    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: SizedBox(
        width: 450,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: () {}, child: const Text("Cancel")),
            GestureDetector(
              onTap: () {
                if (nonEmptyConfigList.isEmpty) {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext _) => const Text("Hello World"));
                }
              },
              child: ElevatedButton(
                onPressed: nonEmptyConfigList.isEmpty
                    ? null
                    : () async {
                        Map<String, String> headers = <String, String>{};
                        headers["x-access-token"] =
                            "365a7406-6e6d-4e60-ad6d-8550513cc62b";
                        headers["content-type"] = "application/json";

                        var body = json.encode({
                          "name": groupNameController.text,
                          "fields": groupConfigList,
                          "slug": groupNameController.text
                              .replaceAll(RegExp(r'\s+'), '_')
                              .toLowerCase()
                        });

                        post(Uri.parse("http://localhost:8000/story-configs"),
                            headers: headers, body: body);
                      },
                style: buttoStyle,
                child: const Text("Create"),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> referenceFields(GroupConfig element) {
    return [
      Expanded(
        flex: 1,
        child: DropdownButton(
          items: [
            DropdownMenuItem(
              child: Text("Content Type Mock 01"),
              value: 1,
            ),
            DropdownMenuItem(child: Text("Content Type Mock 02"), value: 2)
          ],
          onChanged: (Object? value) {},
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
