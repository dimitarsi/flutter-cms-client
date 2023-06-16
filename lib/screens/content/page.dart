import 'package:flutter/material.dart';
import 'package:plenty_cms/helpers/slugify.dart';
import 'package:plenty_cms/service/client/client.dart';
import 'package:plenty_cms/service/models/new_upload.dart';
import 'package:plenty_cms/service/models/story.dart';
import 'package:plenty_cms/service/models/story_config.dart';
import 'package:plenty_cms/widgets/form/file_picker_ui.dart';
import 'package:plenty_cms/widgets/navigation/sidenav.dart';

class StoryPageScaffold extends StatelessWidget {
  const StoryPageScaffold(
      {super.key, required this.slug, required this.client});

  final String slug;

  final RestClient client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideNav(),
      appBar: AppBar(),
      body: StoryPage(
        client: client,
        slug: slug,
      ),
    );
  }
}

class PostType {
  PostType({required this.label, required this.id});

  String label;
  String id;
}

class StoryPage extends StatefulWidget {
  StoryPage({super.key, required this.slug, required this.client});

  final String slug;
  final RestClient client;
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  TextEditingController controller = TextEditingController();
  TextEditingController dropdownController = TextEditingController();
  String? selectedConfigId;

  late Iterable<StoryConfigResponse> configs = [];

  Map<String, dynamic> dataBag = {};

  @override
  void initState() {
    super.initState();
    widget.client.listStoryConfigs().then<void>((configList) {
      widget.client.getStoryBySlugOrId(widget.slug).then<void>((value) {
        setState(() {
          controller.value = TextEditingValue(
            text: value?.name ?? '',
          );
          if (value?.data != null) {
            dataBag = value!.data!;
          }

          final selection = configList.entities.firstWhere((element) {
            return value?.configId == element.id ||
                value?.configId == element.name;
          }, orElse: () => StoryConfigResponse(name: '', id: ''));

          dropdownController.text = selection.name!;
          selectedConfigId = selection.id;

          configs = configList.entities;
        });
      }).catchError(
        (error) {
          print("Unable to fetch `getStoryBySlugOrId` - $error");
        },
        test: (error) => true,
      );
    });
  }

  void createOrUpdateStory() {
    if (controller.text.isEmpty) {
      return;
    }

    var slug = slugify(controller.text);

    var formState = widget.formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    formState.save();

    if (widget.slug.isEmpty) {
      widget.client.createStory(Story(
          name: controller.text,
          slug: slug,
          configId: selectedConfigId,
          data: dataBag));
    } else {
      widget.client.updateStory(
          widget.slug,
          Story(
              configId: selectedConfigId,
              name: controller.text,
              slug: widget.slug,
              data: dataBag));
    }
  }

  Widget dynamicFields() {
    List<Widget> dynaimcFields = [];

    StoryConfigResponse? config;
    try {
      config = configs.singleWhere(
        (element) => element.id == selectedConfigId,
      );

      if (config.fields != null) {
        dynaimcFields = config.fields!
            .where((element) =>
                element.groupName != null && element.groupName!.isNotEmpty)
            .map((e) {
          return Expanded(
            child: Container(
              color: Colors.grey,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              child: Column(children: [
                Row(
                  children: [const Text("Group name"), Text(e.groupName!)],
                ),
                ...getRows(e.rows ?? [])
              ]),
            ),
          );
        }).toList();
      }
    } catch (e) {
      // do nothing
      return Container(
        color: Colors.orangeAccent,
        child: Text("error $e"),
      );
    }

    return Row(
      children: dynaimcFields,
    );
  }

  List<NewUpload> _getFieldData(List<dynamic> data) {
    return data.map((d) => NewUpload.fromJson(d)).toList();
  }

  Iterable<Widget> getRows(Iterable<FieldRow> rows) {
    return rows.map((row) {
      try {
        switch (row.type) {
          case 'text':
            return TextFormField(
              initialValue: dataBag[row.label],
              decoration: InputDecoration(
                  label: Text(row.displayName ?? row.label ?? "Unknown Field")),
              onSaved: (newValue) {
                dataBag[row.label!] = newValue;
              },
            );
          case 'number':
            return TextFormField(
              initialValue: dataBag[row.label],
              validator: (value) {
                final res = double.tryParse(value ?? "");

                if (res == null) {
                  return "Number is needed";
                }

                return null;
              },
              decoration: InputDecoration(
                  label: Text(row.displayName ?? row.label ?? "Unknown Field")),
              onSaved: (newValue) {
                dataBag[row.label!] = newValue;
              },
            );
          case 'files':
            return FilePickerUi(
                client: widget.client,
                fieldData: _getFieldData(dataBag[row.label] ?? []),
                onFilesUploaded: (List<NewUpload> files) {
                  var label = row.label;
                  if (label != null) {
                    dataBag[label] = files;
                  }
                });
          case 'date':
            var now = DateTime.now();
            var parsed = DateTime.tryParse(dataBag[row.label] ?? "");
            var fistDate = now.copyWith(year: now.year - 30);
            var lastDate = now.copyWith(year: now.year + 10);

            return Row(
              children: [
                Flexible(
                    child: IconButton(
                  onPressed: () async {
                    var newDate = await showDatePicker(
                      context: context,
                      initialDate: parsed ?? now,
                      firstDate: fistDate,
                      lastDate: lastDate,
                    );
                    if (newDate != null) {
                      setState(() {
                        if (row.label != null && row.label!.isNotEmpty) {
                          dataBag[row.label!] = newDate.toUtc().toString();
                        }
                      });
                    }
                  },
                  icon: const Icon(Icons.edit_calendar),
                )),
                Flexible(
                  flex: 1,
                  child: InputDatePickerFormField(
                    onDateSaved: (value) {
                      setState(() {
                        if (row.label != null && row.label!.isNotEmpty) {
                          dataBag[row.label!] = value.toUtc().toString();
                        }
                      });
                    },
                    initialDate: parsed ?? now,
                    firstDate: fistDate,
                    lastDate: lastDate,
                    keyboardType: TextInputType.datetime,
                  ),
                ),
              ],
            );
          default:
            return Text("Unknown field type ${row.type}");
        }
      } catch (e) {
        return Text("Unable to render field - ${row.displayName}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final fieldStoryName = TextFormField(
      controller: controller,
      validator: (value) =>
          value == null || value.isEmpty ? "Name is required" : null,
      decoration: const InputDecoration(
        label: Text("Story Name"),
      ),
    );

    return Form(
        key: widget.formKey,
        child: ListView(
          children: [
            Row(
              children: [
                Flexible(
                  flex: 3,
                  child: fieldStoryName,
                ),
                storyType(flex: 1)
              ],
            ),
            dynamicFields(),
            saveButton(),
          ],
        ));
  }

  Widget storyType({required int flex}) {
    var dropdownChildren = configs
        .where((element) => element.id == null ? false : element.id!.isNotEmpty)
        .map(
      (e) {
        return DropdownMenuEntry(value: e.id!, label: "${e.name}");
      },
    );

    if (dropdownChildren.isEmpty) {
      return const SizedBox.shrink();
    }

    return DropdownMenu(
      label: const Text("Type"),
      enableSearch: true,
      dropdownMenuEntries: dropdownChildren.toList(),
      controller: dropdownController,
      onSelected: (value) {
        setState(() {
          selectedConfigId = value.toString();
        });
      },
    );
  }

  ElevatedButton saveButton() {
    return ElevatedButton(
        onPressed: createOrUpdateStory, child: const Text("Save"));
  }
}