import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plenty_cms/state/files_cubit.dart';

import '../../../service/models/content.dart';
import '../../../service/models/new_upload.dart';
import '../../../widgets/form/file_picker_ui.dart';

Widget getFilesFiled(ContentType e, {Content? content}) {
  List<NewUpload> getFieldData(List<dynamic> data) {
    return data.map((d) => NewUpload.fromJson(d)).toList();
  }

  return BlocBuilder<FilesCubitState, List<String>>(
    builder: (context, _state) {
      return FilePickerUi(
          fieldData: getFieldData(content?.data ?? []),
          onFilesUploaded: (List<NewUpload> files) {
            if (content != null) {
              content.data = files;
            }
          });
    },
  );
}
