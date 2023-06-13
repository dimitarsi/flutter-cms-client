import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:plenty_cms/service/client/client.dart';

import '../../service/models/new_upload.dart';

typedef FilesUploadedHandler = void Function(List<NewUpload>);

class FilePickerUi extends StatefulWidget {
  FilePickerUi(
      {super.key,
      required this.client,
      required this.fieldData,
      this.onFilesUploaded});

  final RestClient client;
  final List<NewUpload> fieldData;
  final List<NewUpload> listOfNewUploads = [];

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
        Text("Total files: ${widget.listOfNewUploads.length}"),
        pickList()
      ],
    );
  }

  Widget _leading(NewUpload f) {
    final type = f.type ?? '';
    if (type.startsWith('image') && f.id != null) {
      return Image.network(widget.client.getImageUrlFromHash(f.id!),
          height: 80, width: 80, fit: BoxFit.fill);
    }

    if (type.startsWith('image') && f.id != null) {
      return const Icon(Icons.image);
    }

    if (type.startsWith('video')) {
      return const Icon(
        Icons.video_file,
        size: 50,
      );
    }

    if (type.contains("pdf")) {
      final style = Theme.of(context)
          .textTheme
          .displaySmall!
          .copyWith(fontSize: 20, fontWeight: FontWeight.bold);
      return Center(
        child: Text(
          "PDF",
          style: style,
        ),
      );
    }

    return const Icon(
      Icons.file_present,
      size: 50,
    );
  }

  Widget availableUploads() {
    List<dynamic> listOfIds = widget.fieldData;

    return SizedBox(
      height: 300,
      child: ListView.builder(
        itemBuilder: (context, index) {
          final field = widget.fieldData.elementAt(index);

          return ListTile(
            title: Text(field.name),
            subtitle: Text(field.id ?? '-1'),
            leading: SizedBox(
              width: 80,
              child: _leading(field),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                listOfIds.removeAt(index);
                _callback();
                setState(() {});
              },
            ),
          );
        },
        itemCount: listOfIds.length,
      ),
    );
  }

  Widget pickButton() {
    return ElevatedButton(
        onPressed: _openFilePickDialog, child: const Text("Select files"));
  }

  Future<void> _openFilePickDialog() async {
    FilePickerResult? pickedFiles =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    List<Future> waitList = [];

    for (PlatformFile file in pickedFiles?.files ?? []) {
      widget.listOfNewUploads.add(NewUpload(name: file.name));
    }

    final files = pickedFiles?.files;

    if (files != null) {
      waitList.add(widget.client.uploadFiles(files));

      var added = await Future.wait(waitList);
      var index = 0;
      for (final resp in added) {
        for (final fileResult in resp) {
          widget.listOfNewUploads[index].id = fileResult['id'];
          widget.listOfNewUploads[index].type = fileResult['type'];
          index++;
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
          itemCount: widget.listOfNewUploads.length,
          itemBuilder: (context, ind) {
            return ListTile(
              title:
                  Text("Item ${widget.listOfNewUploads.elementAt(ind).name}"),
              leading: const Icon(Icons.file_upload),
              trailing: IconButton(
                icon: const Icon(Icons.delete_forever),
                onPressed: () {
                  setState(() {
                    widget.listOfNewUploads.removeAt(ind);
                  });
                },
              ),
            );
          }),
    );
  }

  void _callback() {
    List<NewUpload> oldAndNewListItems = [
      ...widget.fieldData,
      ...widget.listOfNewUploads
    ];

    widget.onFilesUploaded?.call(oldAndNewListItems);
  }
}
