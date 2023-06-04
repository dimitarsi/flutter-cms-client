import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:plenty_cms/service/client/client.dart';
import 'package:plenty_cms/service/models/story_config.dart';

typedef FilesUploadedHandler = void Function(List<String>);

class FilePickerUi extends StatefulWidget {
  const FilePickerUi(
      {super.key,
      required this.client,
      required this.fieldData,
      this.onFilesUploaded});

  final RestClient client;
  final dynamic fieldData;

  final FilesUploadedHandler? onFilesUploaded;

  @override
  State<FilePickerUi> createState() => _FilePickerUiState();
}

class _FilePickerUiState extends State<FilePickerUi> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        availableUploads(),
        pickButton(),
        Text("tota files: ${listOfFiles.length}"),
        pickList()
      ],
    );
  }

  List<String> listOfFiles = [];

  Widget availableUploads() {
    if (widget.fieldData != null && widget.fieldData is List) {
      final listOfIds = widget.fieldData;
      List<Widget> items = [];

      for (var item in listOfIds) {
        items.add(Text("id: $item"));
      }

      return Container(
        padding: EdgeInsets.all(8),
        child: Row(children: items.toList()),
      );
    }

    return Placeholder(
      child: Text("Available Uploads"),
    );
    // return ListView.builder(itemBuilder: uploadItem, itemCount: ,)
  }

  Widget pickButton() {
    return ElevatedButton(
        onPressed: _openFilePickDialog, child: Text("Select files"));
  }

  Future<void> _openFilePickDialog() async {
    FilePickerResult? pickedFiles =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    List<Future> waitList = [];

    for (PlatformFile file in pickedFiles?.files ?? []) {
      listOfFiles.add(file.name);
      waitList.add(widget.client.uploadFile(file));
    }

    var added = await Future.wait(waitList);

    widget.onFilesUploaded?.call(added.map((dynamic f) {
      print("f: ${f[0]['name']} and ${f[0]['id']}");
      return "${f[0]['id']}";
    }).toList());

    // widget.onFilesUploaded?.call([]);

    setState(() {
      // listOfFiles.addAll(added.map((f) => f['name']));
    });

    // setState(() {});
    // print("List: ${pickedFiles?.count ?? 0}");
  }

  Widget pickList() {
    return SizedBox(
      height: 300,
      child: ListView.builder(
          itemCount: listOfFiles.length,
          itemBuilder: (context, ind) {
            return ListTile(
              title: Text("Iteme ${listOfFiles.elementAt(ind)}"),
              leading: Icon(Icons.file_upload),
            );
          }),
    );
  }
}
