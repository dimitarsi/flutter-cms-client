import 'package:flutter/material.dart';
import 'package:plenty_cms/service/models/field_type.dart';

import '../../../service/models/content.dart';

var dropdownOptions = [
  DropdownMenuEntry(
    value: FieldType.text,
    label: "Text",
  ),
  DropdownMenuEntry(
    value: FieldType.number,
    label: "Number",
  ),
  DropdownMenuEntry(
    value: FieldType.date,
    label: "Date",
  ),
  DropdownMenuEntry(
    value: FieldType.files,
    label: "Files",
  ),
  DropdownMenuEntry(
    value: FieldType.list,
    label: "List",
  ),
  DropdownMenuEntry(
    value: FieldType.ref,
    label: "Reference",
  ),
  DropdownMenuEntry(
    value: FieldType.component,
    label: "Component",
  ),
];

@Deprecated("Replaced in favor of having a settings modal with buttons list")
class ContentTypeDropdown extends StatelessWidget {
  ContentTypeDropdown(
      {super.key, required this.element, required this.onSelected});

  final ContentType element;
  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      label: const Text("Field Type"),
      initialSelection: element.type,
      dropdownMenuEntries: dropdownOptions,
      onSelected: (value) {
        element.type = value.toString();
        onSelected?.call();
      },
    );
  }
}
