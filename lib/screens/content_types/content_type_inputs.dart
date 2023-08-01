import 'package:flutter/material.dart';
import 'package:plenty_cms/helpers/slugify.dart';

import '../../app_router.dart';
import '../../service/models/content.dart';

const allowedGroupTypes = ["composite", "root"];

class ContentTypeInputs extends StatelessWidget {
  ContentTypeInputs(
      {super.key,
      required this.contentType,
      this.child,
      this.onChange,
      this.onSelectType,
      this.onNavigateTo});

  ContentType contentType;
  Widget? child;
  void Function()? onChange;
  void Function(ContentType)? onSelectType;
  void Function(String path)? onNavigateTo;

  List<Widget> getChildren(ContentType contentType, {ContentType? parent}) {
    final input = getInputByType(contentType!, parent: parent);

    List<Widget> nestedChildren = contentType.freezed
        ? []
        : (contentType.children ?? []).fold([], (value, e) {
            final nextLevel = getChildren(e, parent: contentType);
            value.addAll(nextLevel);
            return value;
          });

    String newInputName = "";

    final shouldAddGroup = parent == null &&
        contentType.children!
                .where((element) =>
                    element.type == "composite" || element.type == "root")
                .length >
            0;

    add() {
      if (newInputName.isEmpty) {
        return;
      }

      final childType = shouldAddGroup ? "composite" : "text";
      final ct = ContentType(
          name: newInputName, slug: slugify(newInputName), type: childType);

      contentType.addChild(ct);
      onChange?.call();
    }

    final addButton = IconButton(onPressed: add, icon: Icon(Icons.add));

    nestedChildren = nestedChildren.toList();

    final newInputHint =
        shouldAddGroup ? "Add Group" : "Add ${contentType.name} Field";

    Widget newInput = TextFormField(
        decoration: InputDecoration(hintText: newInputHint),
        onChanged: (value) {
          newInputName = value;
        },
        onEditingComplete: add);

    newInput = shouldAddGroup == false
        ? Padding(padding: EdgeInsets.only(left: 15), child: newInput)
        : newInput;

    newInput = Row(
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: 400),
          child: newInput,
        ),
        addButton
      ],
    );

    nestedChildren = [
      ...nestedChildren,
      if (contentType.freezed == false &&
          allowedGroupTypes.contains(contentType.type))
        newInput,
    ];

    return [input, ...nestedChildren];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [...getChildren(contentType), if (child != null) child!],
    );
  }

  Widget getInputByType(ContentType contentType, {ContentType? parent}) {
    final changeTypeButton = IconButton(
        onPressed: () {
          onSelectType?.call(contentType);
        },
        icon: Icon(Icons.select_all));

    final deleteIcon = parent == null
        ? SizedBox.shrink()
        : IconButton(
            onPressed: () {
              parent.children?.remove(contentType);
              onChange?.call();
            },
            icon: Icon(Icons.delete),
            iconSize: 16,
          );

    final linkIcon = IconButton(
      onPressed: () {
        onNavigateTo?.call(AppRouter.getContentTypePath(contentType.slug));
      },
      icon: Icon(Icons.link),
      tooltip: contentType.originalName,
    );

    Widget input = TextFormField(
      // enabled: contentType.freezed != true,
      initialValue: contentType.name,
      onChanged: (value) {
        contentType.slug = slugify(value);
        contentType.name = value;
      },
    );

    input =
        wrapInPadding(contentType: contentType, child: input, parent: parent);

    return Row(
      children: [
        if (contentType.id != null && parent != null) linkIcon,
        Flexible(child: input),
        changeTypeButton,
        if (parent != null) deleteIcon,
      ],
    );
  }

  Widget wrapInPadding({
    required ContentType contentType,
    ContentType? parent,
    required Widget child,
  }) {
    if (allowedGroupTypes.contains(contentType.type) == false &&
        parent != null) {
      return Padding(
        padding: EdgeInsets.only(left: 15),
        child: child,
      );
    }

    return child;
  }

  Widget spacerBefore() => Container(height: 15);
  Widget spacerAfter() => Container(height: 40);
}
