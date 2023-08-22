import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plenty_cms/state/files_cubit.dart';

import '../../../service/models/content.dart';
import '../../../service/models/new_upload.dart';
import '../../../widgets/form/file_picker_ui.dart';

Widget getFilesFiled(ContentType e, {dynamic data}) {
  List<NewUpload> getFieldData(dynamic data) {
    if (data['list'] != null && data['list'] is List) {
      return data.map((d) => NewUpload.fromJson(d)).toList();
    }

    return [];
  }

  return BlocBuilder<FilesCubitState, List<String>>(
    builder: (context, _state) {
      return FilePickerUi(
          fieldData: [], // getFieldData(data[e.slug].data ?? []),
          onFilesUploaded: (List<NewUpload> files) {
            data[e.slug] = {"files": files};
          });
    },
  );
}
