import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:plenty_cms/service/client/client.dart';

class FilePickerUi extends StatefulWidget {
  const FilePickerUi({super.key, required this.client});

  final RestClient client;

  @override
  State<FilePickerUi> createState() => _FilePickerUiState();
}

class _FilePickerUiState extends State<FilePickerUi> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        pickButton(),
        Text("tota files: ${listOfFiles.length}"),
        pickList()
      ],
    );
  }

  List<String> listOfFiles = [];

  Widget pickButton() {
    return ElevatedButton(
        onPressed: _openFilePickDialog, child: Text("Select files"));
  }

  Future<void> _openFilePickDialog() async {
    FilePickerResult? pickedFiles =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    setState(() {
      for (PlatformFile file in pickedFiles?.files ?? []) {
        listOfFiles.add(file.name);
        widget.client.uploadFile(file);
      }
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
