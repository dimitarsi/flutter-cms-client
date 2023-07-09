import 'package:flutter/material.dart';
import 'package:plenty_cms/service/models/content_data.dart';
import 'package:plenty_cms/service/models/content_type.dart';

class DynamicField extends StatelessWidget {
  DynamicField({super.key, required this.data, required this.contentType});

  final ContentData data;
  final ContentType contentType;

  @override
  Widget build(BuildContext context) {
    if (data.type == "component") {
      return _componentField();
    }

    return _textField();
  }

  Widget _textField() {
    return TextFormField(
      initialValue: this.data.getTextData(),
      decoration: InputDecoration(label: Text(contentType.name)),
      onSaved: (newValue) {
        data.setTextData(newValue ?? "");
      },
    );
  }

  Widget _componentField() {
    List<Widget> children = [];

    data.getComponentData().forEach(
      (key, value) {
        children.add(DynamicField(data: value, contentType: contentType));
      },
    );

    return Column(
      children: children,
    );
  }
}
