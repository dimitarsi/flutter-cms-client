import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plenty_cms/helpers/slugify.dart';
import 'package:plenty_cms/service/client/client.dart';
import '../../service/models/content.dart';

typedef OnCreateHandler = void Function(String id);

class ContentTypeCreateModal extends StatefulWidget {
  ContentTypeCreateModal({super.key, required this.client, this.onCreate});

  final GlobalKey<FormState> formKey = GlobalKey();
  final RestClient client;
  final OnCreateHandler? onCreate;

  @override
  State<ContentTypeCreateModal> createState() => _ContentTypeCreateModalState();
}

class _ContentTypeCreateModalState extends State<ContentTypeCreateModal> {
  String contentTypeName = "";

  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(label: Text("Name")),
              validator: (val) {
                return val == null || val.isEmpty ? "Required" : null;
              },
              onSaved: (val) {
                contentTypeName = val ?? "";
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  final formState = widget.formKey.currentState;

                  if (formState == null || !formState.validate()) {
                    return;
                  }

                  formState.save();

                  try {
                    final newId = await widget.client.createStoryConfig(
                        ContentType(
                            name: contentTypeName,
                            slug: slugify(contentTypeName),
                            children: [],
                            type: "root"));

                    if (widget.onCreate != null) {
                      widget.onCreate!(newId);
                    }
                  } catch (e) {}

                  if (context.mounted) {
                    context.pop();
                  }
                },
                child: const Text("Create"))
          ],
        ));
  }
}
