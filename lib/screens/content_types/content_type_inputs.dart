import 'package:flutter/material.dart';
import 'package:plenty_cms/helpers/slugify.dart';

import '../../service/models/content.dart';

class ContentTypeInputs extends StatelessWidget {
  ContentTypeInputs(
      {super.key,
      required this.contentType,
      this.child,
      this.onChange,
      this.onSelectType});

  ContentType contentType;
  Widget? child;
  void Function()? onChange;
  void Function(ContentType)? onSelectType;

  List<Widget> getChildren(ContentType contentType, {ContentType? parent}) {
    final input = getInputByType(contentType!, parent: parent);

    List<Widget> nestedChildren =
        (contentType.children ?? []).fold([], (value, e) {
      final nextLevel = getChildren(e, parent: contentType);
      value.addAll(nextLevel);
      return value;
    });

    String newInputName = "";

    final addButton = IconButton(
        onPressed: () {
          if (newInputName.isEmpty) {
            return;
          }

          final childType = parent == null ? "composite" : "text";
          final ct = ContentType(
              name: newInputName, slug: slugify(newInputName), type: childType);

          contentType.addChild(ct);

          onChange?.call();
        },
        icon: Icon(Icons.add));

    if (nestedChildren.length != 0) {
      nestedChildren = [
        spacerBefore(),
        ...nestedChildren.toList(),
      ];
    }

    final newInput = TextFormField(
      decoration: InputDecoration(hintText: "Add new field"),
      onChanged: (value) {
        newInputName = value;
      },
    );

    nestedChildren = [
      ...nestedChildren,
      if (contentType.type == "composite")
        Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 15),
              constraints: BoxConstraints(maxWidth: 400),
              child: newInput,
            ),
            addButton
          ],
        ),
      if (contentType.type == "composite") spacerAfter(),
    ];

    if (parent != null && contentType.type == "composite") {
      nestedChildren = [
        ...nestedChildren,
        const Divider(
          height: 2,
        )
      ];
    }

    return [input, ...nestedChildren];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [...getChildren(contentType), if (child != null) child!],
    );
  }

  Widget getInputByType(ContentType contentType, {ContentType? parent}) {
    Widget input = TextFormField(
      initialValue: contentType.name,
      onChanged: (value) {
        contentType.slug = slugify(value);
        contentType.name = value;
      },
    );

    if (parent != null && contentType.type != "composite") {
      input = Padding(
        padding: EdgeInsets.only(left: 15),
        child: input,
      );
    }

    final changeTypeButton = IconButton(
        onPressed: () {
          onSelectType?.call(contentType);
        },
        icon: Icon(Icons.select_all));

    return Row(
      children: [
        Flexible(child: input),
        changeTypeButton,
        if (parent != null)
          IconButton(
            onPressed: () {
              parent.children?.remove(contentType);
              onChange?.call();
            },
            icon: Icon(Icons.delete),
            iconSize: 16,
          )
      ],
    );
  }

  Widget spacerBefore() => Container(height: 15);
  Widget spacerAfter() => Container(height: 40);
}
