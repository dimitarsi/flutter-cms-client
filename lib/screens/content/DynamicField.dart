import 'package:flutter/material.dart';
import 'package:plenty_cms/service/models/content.dart';

class DynamicField extends StatelessWidget {
  DynamicField({super.key, required this.data, required this.contentType});

  final Content data;
  final ContentType contentType;

  @override
  Widget build(BuildContext context) {
    if (data.type != contentType.type) {
      return Text("Content Type mismatch, probably using older version");
    }

    if (data.type == "component") {
      return _componentField();
    }

    return _textField();
  }

  Widget _textField() {
    return TextFormField(
      initialValue: data.getDataAsString(),
      decoration: InputDecoration(label: Text(contentType.name)),
      onSaved: (newValue) {
        data.setStringData(newValue ?? "");
      },
    );
  }

  Widget _componentField() {
    List<Widget> children = [];

    final contentTypeChildren = contentType.children;

    data.getDataAsComponent().asMap().forEach(
      (index, value) {
        if (contentTypeChildren != null) {
          children.add(DynamicField(
              data: value, contentType: contentTypeChildren[index]));
        }
      },
    );

    return Column(
      children: children,
    );
  }
}
