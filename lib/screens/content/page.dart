import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plenty_cms/service/client/client.dart';
import 'package:plenty_cms/service/models/content.dart';
import 'package:plenty_cms/state/content_cubit.dart';
import 'package:plenty_cms/widgets/navigation/sidenav.dart';

import 'content_type_input_field.dart';

class StoryPageScaffold extends StatelessWidget {
  const StoryPageScaffold(
      {super.key, required this.slug, required this.client});

  final String slug;

  final RestClient client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideNav(),
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

// TODO: Use async.dart with StreamBuilder here
class _StoryPageState extends State<StoryPage> {
  // TextEditingController controller = TextEditingController();
  // TextEditingController dropdownController = TextEditingController();
  // String? selectedConfigId;

  // List<ContentType> configs = [];
  // ContentType? config;

  // Map<String, dynamic> dataBag = {};

  Content? item = null;
  ContentType? contentType = null;

  @override
  void initState() {
    super.initState();

    final contentCubit = context.read<ContentCubit>();

    contentCubit.loadById(widget.slug).then((_void) {
      setState(() {
        final asJson =
            contentCubit.state.cacheByIdOrSlug[widget.slug]?.toJson();
        if (asJson != null) {
          item = Content.fromJson(asJson);
        }
      });
    });
    contentCubit.loadConfigBySlug(widget.slug).then((_void) {
      setState(() {
        contentType =
            contentCubit.state.cacheCTBySlug[widget.slug]?.cloneDeep();
      });
    });
  }

  void createOrUpdateStory({VoidCallback? onSave}) {
    // if (controller.text.isEmpty) {
    //   return;
    // }

    var formState = widget.formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    formState.save();
    onSave?.call();
  }

  // Widget dynamicFields() {
  //   List<Widget> dynaimcFields = [];

  //   try {
  //     final fields = config?.fields;

  //     if (fields != null) {
  //       dynaimcFields = fields
  //           .where((element) =>
  //               element.groupName != null && element.groupName!.isNotEmpty)
  //           .map(_dynamicField)
  //           .toList();
  //     }
  //   } catch (e) {
  //     // do nothing
  //     return Container(
  //       color: Colors.orangeAccent,
  //       child: Text("error $e"),
  //     );
  //   }

  //   return Row(
  //     children: dynaimcFields,
  //   );
  // }

  // Widget _dynamicField(Field e) {
  //   return Expanded(
  //     child: Container(
  //       color: Colors.grey,
  //       padding: const EdgeInsets.all(8.0),
  //       margin: const EdgeInsets.only(top: 8, bottom: 8),
  //       child: Column(children: [
  //         Row(
  //           children: [const Text("Group name"), Text(e.groupName!)],
  //         ),
  //         ...getRows(e.rows ?? [])
  //       ]),
  //     ),
  //   );
  // }

  // List<NewUpload> _getFieldData(List<dynamic> data) {
  //   return data.map((d) => NewUpload.fromJson(d)).toList();
  // }

  // List<Widget> getRows(List<FieldRow> rows) {
  //   return rows.map((e) => DynamicField(data: dataBag[e])).toList();
  // }

  // Iterable<Widget> getRows(Iterable<FieldRow> rows) {
  //   return rows.map((row) {
  //     try {
  //       switch (row.type) {
  //         case 'text':
  //           return TextFormField(
  //             initialValue: dataBag[row.displayName],
  //             decoration: InputDecoration(
  //                 label: Text(
  //                     row.displayName ?? row.displayName ?? "Unknown Field")),
  //             onSaved: (newValue) {
  //               dataBag[row.displayName!] = newValue;
  //             },
  //           );
  //         case 'number':
  //           return TextFormField(
  //             initialValue: dataBag[row.displayName],
  //             validator: (value) {
  //               final res = double.tryParse(value ?? "");

  //               if (res == null) {
  //                 return "Number is needed";
  //               }

  //               return null;
  //             },
  //             decoration: InputDecoration(
  //                 label: Text(row.displayName ?? "Unknown Field")),
  //             onSaved: (newValue) {
  //               dataBag[row.displayName!] = newValue;
  //             },
  //           );
  //         case 'files':
  //           return FilePickerUi(
  //               client: widget.client,
  //               fieldData: _getFieldData(dataBag[row.displayName] ?? []),
  //               onFilesUploaded: (List<NewUpload> files) {
  //                 var label = row.slug;
  //                 if (label != null) {
  //                   dataBag[label] = files;
  //                 }
  //               });
  //         case 'date':
  //           var now = DateTime.now();
  //           var parsed = DateTime.tryParse(dataBag[row.data] ?? "");
  //           var fistDate = now.copyWith(year: now.year - 30);
  //           var lastDate = now.copyWith(year: now.year + 10);

  //           return Row(
  //             children: [
  //               Flexible(
  //                   child: IconButton(
  //                 onPressed: () async {
  //                   var newDate = await showDatePicker(
  //                     context: context,
  //                     initialDate: parsed ?? now,
  //                     firstDate: fistDate,
  //                     lastDate: lastDate,
  //                   );
  //                   if (newDate != null) {
  //                     setState(() {
  //                       if (row.slug != null && row.slug!.isNotEmpty) {
  //                         dataBag[row.slug!] = newDate.toUtc().toString();
  //                       }
  //                     });
  //                   }
  //                 },
  //                 icon: const Icon(Icons.edit_calendar),
  //               )),
  //               Flexible(
  //                 flex: 1,
  //                 child: InputDatePickerFormField(
  //                   onDateSaved: (value) {
  //                     setState(() {
  //                       if (row.slug != null && row.slug!.isNotEmpty) {
  //                         dataBag[row.slug!] = value.toUtc().toString();
  //                       }
  //                     });
  //                   },
  //                   initialDate: parsed ?? now,
  //                   firstDate: fistDate,
  //                   lastDate: lastDate,
  //                   keyboardType: TextInputType.datetime,
  //                 ),
  //               ),
  //             ],
  //           );
  //         case 'ref':
  //           return Row(
  //             children: [
  //               if (dataBag[row.slug!] != null)
  //                 Text("Selected - ${dataBag[row.slug!]['id']}"),
  //               ElevatedButton(
  //                   onPressed: () {
  //                     openRefModal(row.data?['refType'] ?? '',
  //                         onSelect: (refId) {
  //                       setState(() {
  //                         dataBag[row.slug!] = {
  //                           'id': refId,
  //                           'type': row.data?['refType']
  //                         };
  //                       });
  //                     });
  //                   },
  //                   child: Text("Select a reference")),
  //             ],
  //           );
  //         default:
  //           return Text("Unknown field type ${row.type}");
  //       }
  //     } catch (e) {
  //       return Text("Unable to render field - ${row.displayName}");
  //     }
  //   });
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Form(
  //       key: widget.formKey,
  //       child: ListView(
  //         children: [
  //           Row(
  //             children: [storyName(), storyType(flex: 1)],
  //           ),
  //           dynamicFields(),
  //           saveButton(),
  //         ],
  //       ));
  // }

  // Widget storyName() {
  //   final fieldStoryName = TextFormField(
  //     controller: controller,
  //     validator: (value) =>
  //         value == null || value.isEmpty ? "Name is required" : null,
  //     decoration: const InputDecoration(
  //       label: Text("Story Name"),
  //     ),
  //   );

  //   return Flexible(
  //     flex: 3,
  //     child: fieldStoryName,
  //   );
  // }

  // Widget storyType({required int flex}) {
  //   var dropdownChildren = configs
  //       .where((element) => element.id == null ? false : element.id!.isNotEmpty)
  //       .map(
  //     (e) {
  //       return DropdownMenuEntry(value: e.id!, label: "${e.name}");
  //     },
  //   );

  //   if (dropdownChildren.isEmpty) {
  //     return const SizedBox.shrink();
  //   }

  //   return DropdownMenu(
  //     label: const Text("Type"),
  //     enableSearch: true,
  //     dropdownMenuEntries: dropdownChildren.toList(),
  //     controller: dropdownController,
  //     onSelected: (value) {
  //       // loadFullConfig(value.toString());
  //       setState(() {
  //         selectedConfigId = value.toString();
  //       });
  //     },
  //   );
  // }

  ElevatedButton saveButton({VoidCallback? onSave}) {
    return ElevatedButton(
        onPressed: () => createOrUpdateStory(onSave: onSave),
        child: const Text("Save"));
  }

  bool isRefListLoading = false;

  // late final Content item;
  // late final ContentType contentType;

  @override
  Widget build(BuildContext context) {
    final client = context.read<ContentCubit>().client;

    return Form(
      key: widget.formKey,
      child: BlocBuilder<ContentCubit, ContentCubitState>(
          builder: ((context, state) {
        // TODO: make local copy of the values, otherwise it will always replace the *new* one
        // final item = state.cacheByIdOrSlug[widget.slug];
        // final contentType = state.cacheCTBySlug[widget.slug];

        if (item == null || contentType == null) {
          return Text("Loading");
        }

        return Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ...(contentType?.children ?? []).map(
                    (e) =>
                        ContentTypeInputField(contentType: e, content: item!),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                saveButton(onSave: () {
                  if (item != null) {
                    client.updateStory(widget.slug, item!);
                  }
                })
              ],
            )
          ],
        );
      })),
    );
  }

  // void openRefModal(String contentType,
  //     {void Function(String refId)? onSelect}) async {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (context) {
  //         if (isRefListLoading) {
  //           return Icon(Icons.event_busy);
  //         }

  //         return ListView.builder(
  //           itemBuilder: (context, index) {
  //             final name = modalRefList[index].name;
  //             final refId = modalRefList[index].slug;
  //             final configId = modalRefList[index].configId;
  //             List<ContentType>? config =
  //                 configs.where((element) => element.id == configId).toList();

  //             if (name == null || refId == null || config.isEmpty) {
  //               return SizedBox.shrink();
  //             }

  //             final isSameType = config[0].slug == contentType;

  //             return ListTile(
  //               title: Text(
  //                 name,
  //                 style: TextStyle(
  //                     color: isSameType ? Colors.black : Colors.white70),
  //               ),
  //               subtitle: Text("configs found - ${config.length}"),
  //               onTap: () {
  //                 if (isSameType && onSelect != null) {
  //                   onSelect(refId);
  //                   context.pop();
  //                 }
  //               },
  //             );
  //           },
  //           itemCount: modalRefList.length,
  //         );
  //       });

  //   if (modalRefList.isEmpty) {
  //     setState(() {
  //       isRefListLoading = true;
  //     });

  //     final items = await widget.client.getStories();

  //     setState(() {
  //       modalRefList = items.entities.toList();
  //       isRefListLoading = false;
  //     });
  //   }
  // }
}
