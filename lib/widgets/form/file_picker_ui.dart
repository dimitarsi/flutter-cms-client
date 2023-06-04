import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:plenty_cms/service/client/client.dart';

typedef FilesUploadedHandler = void Function(List<String>);

class FilePickerUi extends StatefulWidget {
  FilePickerUi(
      {super.key,
      required this.client,
      required this.fieldData,
      this.onFilesUploaded});

  final RestClient client;
  final dynamic fieldData;
  final List<String> listOfNewUploadIds = [];
  final List<String> listOfNewUploadNames = [];

  final FilesUploadedHandler? onFilesUploaded;

  @override
  State<FilePickerUi> createState() => _FilePickerUiState();
}

class _FilePickerUiState extends State<FilePickerUi> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Total ${(widget.fieldData ?? []).length}"),
        availableUploads(),
        pickButton(),
        Text("tota files: ${widget.listOfNewUploadNames.length}"),
        pickList()
      ],
    );
  }

  Widget availableUploads() {
    if (widget.fieldData != null && widget.fieldData is List) {
      List<dynamic> listOfIds = widget.fieldData;
      // List<Widget> items = [];

      // for (var item in listOfIds) {
      //   items.add(Text("id: $item"));
      // }

      return SizedBox(
        height: 300,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("Hash: ${listOfIds[index]}"),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    listOfIds.removeAt(index);
                  });
                },
              ),
            );
          },
          itemCount: listOfIds.length,
        ),
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
      widget.listOfNewUploadNames.add(file.name);
    }

    final files = pickedFiles?.files;

    if (files != null) {
      waitList.add(widget.client.uploadFiles(files));

      var added = await Future.wait(waitList);

      for (final resp in added) {
        for (final fileResult in resp) {
          widget.listOfNewUploadIds.add(fileResult['id']);
        }
      }

      _callback();

      setState(() {});
    }
  }

  Widget pickList() {
    return SizedBox(
      height: 300,
      child: ListView.builder(
          itemCount: widget.listOfNewUploadNames.length,
          itemBuilder: (context, ind) {
            return ListTile(
              title:
                  Text("Iteme ${widget.listOfNewUploadNames.elementAt(ind)}"),
              leading: Icon(Icons.file_upload),
              trailing: IconButton(
                icon: Icon(Icons.delete_forever),
                onPressed: () {
                  setState(() {
                    widget.listOfNewUploadNames.removeAt(ind);
                    widget.listOfNewUploadIds.removeAt(ind);
                  });
                },
              ),
            );
          }),
    );
  }

  void _callback() {
    List<String> oldAndNewListItems = [
      ...widget.fieldData,
      ...widget.listOfNewUploadIds
    ];

    widget.onFilesUploaded?.call(oldAndNewListItems);
  }
}
