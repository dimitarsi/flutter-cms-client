import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../service/client/client.dart';

class FilesCubitState extends Cubit<List<String>> {
  final RestClient client;

  FilesCubitState(List<String> initialState, {required this.client})
      : super(initialState);

  Future<List<dynamic>> uploadFiles(List<PlatformFile> newFiles) async {
    return await client.uploadFiles(newFiles);
  }
}
