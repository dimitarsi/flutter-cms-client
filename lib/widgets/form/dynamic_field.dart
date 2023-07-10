import 'package:flutter/material.dart';

import 'data.dart';

class DynamicField extends StatelessWidget {
  DynamicField({super.key, required this.content, required this.contentType});

  Content content;
  ContentType contentType;

  @override
  Widget build(BuildContext context) {
    if (contentType.type == "text") {
      return TextFormField(
        initialValue: content.getTextValue(),
        decoration: InputDecoration(label: Text(contentType.name)),
        onSaved: (val) {
          content.value = val;
        },
      );
    }

    return _renderComponent();
  }

  Widget _renderComponent() {
    if (contentType.type == "text") {
      return SizedBox.shrink();
    }

    final contentItems = content.getComponentValue();

    if (contentItems == null || contentItems.length == 0) {
      return SizedBox.shrink();
    }

    final List<Widget> items = [];
    var index = 0;

    for (var _ in contentType.getComponentValue() ?? []) {
      items.add(_getChildItem(index));
      index++;
    }

    return Column(
      children: [Text("${contentType.name}"), ...items],
    );
  }

  Widget _getChildItem(int index) {
    final itemType = contentType.getComponentValue() ?? [];
    final item = content.getComponentValue() ?? [];

    if (item[index].type != itemType[index].type) {
      return Text(
          "ContentType and the actual type of the content doen't match. most likey the Content uses an old version of the ContentType");
    }

    return DynamicField(
      content: item[index],
      contentType: itemType[index],
    );
  }
}
