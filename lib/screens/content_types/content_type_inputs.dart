import 'package:flutter/material.dart';
import 'package:plenty_cms/helpers/slugify.dart';

import '../../service/models/content.dart';

class ContentTypeInputs extends StatelessWidget {
  ContentTypeInputs(
      {super.key, required this.contentType, this.child, this.onChange});

  ContentType contentType;
  Widget? child;
  void Function()? onChange;

  List<Widget> getChildren(ContentType contentType, {ContentType? parent}) {
    final input = getInputByType(contentType!, parent: parent);

    List<Widget> nestedChildren =
        (contentType.children ?? []).fold([], (value, e) {
      final nextLevel = getChildren(e, parent: contentType);
      value.addAll(nextLevel);
      return value;
    });

    Widget addButton = IconButton(
        onPressed: () {
          if (contentType.type == "composite") {
            contentType
                .addChild(ContentType(name: "New", slug: "", type: "text"));
            onChange?.call();
          }
        },
        icon: Icon(Icons.add));

    addButton = Align(
      alignment: Alignment.topLeft,
      child: addButton,
    );

    if (nestedChildren.length != 0) {
      nestedChildren = [
        spacerBefore(),
        ...nestedChildren.toList(),
        if (contentType.type == "composite")
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: addButton,
          ),
        spacerAfter()
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

    final childType = parent == null ? "composite" : "text";

    final addButton = IconButton(
        onPressed: () {
          if (contentType.type == "composite") {
            contentType
                .addChild(ContentType(name: "New", slug: "", type: childType));
            onChange?.call();
          }
        },
        icon: Icon(Icons.add));

    return Row(
      children: [
        Flexible(child: input),
        if (parent == null) addButton,
        IconButton(onPressed: () {}, icon: Icon(Icons.select_all)),
        // if (contentType != "composite")
        //   SizedBox(
        //     width: 40,
        //   ),
        if (parent == null)
          SizedBox(
            width: 40,
          ),
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
