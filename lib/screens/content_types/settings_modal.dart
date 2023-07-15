import 'package:flutter/material.dart';
import 'package:plenty_cms/service/models/field_type.dart';

import '../../service/models/content.dart';

class FieldSettingsModal extends StatefulWidget {
  FieldSettingsModal(
      {super.key,
      required this.element,
      required this.onSelected,
      required this.contentTypes});

  final Content element;
  final VoidCallback? onSelected;
  List<ContentType> contentTypes = [];

  @override
  State<FieldSettingsModal> createState() => _FieldSettingsState();

  List<DropdownMenuEntry<String>> get items {
    return contentTypes.map((e) {
      return DropdownMenuEntry<String>(
        value: e.slug,
        label: e.name!,
      );
    }).toList();
  }
}

class _FieldSettingsState extends State<FieldSettingsModal> {
  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headlineSmall;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "Settings",
            style: titleStyle,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ContentTypeWidthsDropdown(
              element: widget.element,
              onSelected: widget.onSelected,
            ),
            const SizedBox(
              width: 20,
              height: 20,
            ),
            _defaultValue(),
            _dateSettigns(),
            _refSettings()
          ],
        ),
      ],
    );
  }

  Widget _defaultValue() {
    if ([FieldType.text, FieldType.number].contains(widget.element.type) ==
        false) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: 100,
      child: TextField(
          decoration: const InputDecoration(labelText: "Default Value"),
          keyboardType: widget.element.type == FieldType.number
              ? TextInputType.number
              : TextInputType.text),
    );
  }

  Widget _dateSettigns() {
    if (widget.element.type != FieldType.date) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        const Text("Set current date as default:"),
        Switch(value: true, onChanged: (v) {})
      ],
    );
  }

  Widget _refSettings() {
    if (widget.element.type != FieldType.ref) {
      return const SizedBox.shrink();
    }

    // List<Widget> minMaxFields = [
    //   const SizedBox(
    //     width: 50,
    //     child: TextField(
    //         keyboardType:
    //             TextInputType.numberWithOptions(signed: false, decimal: false),
    //         decoration: InputDecoration(
    //           label: Text("Min count"),
    //         )),
    //   ),
    //   const SizedBox(
    //     width: 50,
    //     child: TextField(
    //         keyboardType:
    //             TextInputType.numberWithOptions(signed: false, decimal: false),
    //         decoration: InputDecoration(label: Text("Max count"))),
    //   ),
    // ];

    return DropdownMenu<String>(
      label: Text("References"),
      initialSelection: widget.element.data?['refType'] ?? '',
      dropdownMenuEntries: widget.items,
      onSelected: (String? value) {
        // referenceListValue = value.toString();
        widget.element.data ??= {};
        widget.element.data!['refType'] = value ?? '';
        widget.onSelected?.call();
      },
    );
  }
}

class ContentTypeWidthsDropdown extends StatelessWidget {
  ContentTypeWidthsDropdown(
      {super.key, required this.element, required this.onSelected});

  final Content element;
  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: DropdownMenu(
        label: const Text("Width"),
        initialSelection: "100",
        onSelected: (value) {
          onSelected?.call();
        },
        dropdownMenuEntries: const [
          DropdownMenuEntry(label: "100%", value: "100"),
          DropdownMenuEntry(label: "66%", value: "66"),
          DropdownMenuEntry(label: "50%", value: "50"),
          DropdownMenuEntry(label: "33%", value: "33"),
        ],
      ),
    );
  }
}
