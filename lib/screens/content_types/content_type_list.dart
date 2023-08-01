import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../service/models/content.dart';
import 'content_type_inputs.dart';

class ContentTypeList extends StatefulWidget {
  ContentTypeList({super.key, required this.contentType, this.onSelectType});

  final ContentType contentType;
  final void Function(ContentType selected)? onSelectType;

  @override
  State<ContentTypeList> createState() =>
      _ContentTypeListState(contentType: contentType);
}

class _ContentTypeListState extends State<ContentTypeList> {
  _ContentTypeListState({required this.contentType});

  ContentType contentType;

  @override
  Widget build(BuildContext context) {
    return ContentTypeInputs(
      contentType: contentType,
      onChange: () {
        setState(() {});
      },
      onSelectType: (ContentType contentType) {
        widget.onSelectType?.call(contentType);
      },
      onNavigateTo: (path) => context.push(path),
    );
  }

  Widget saveButtons(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: Text("Cancel")),
          ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: Text("Update"))
        ],
      ),
    );
  }
}
