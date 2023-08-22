import 'package:flutter/material.dart';
import 'package:plenty_cms/screens/content/mappers/files.dart';
import 'package:plenty_cms/screens/content/mappers/rich_text.dart';
import 'package:plenty_cms/screens/content/mappers/toggle.dart';
import '../../service/models/content.dart';
import 'mappers/number.dart';
import 'mappers/text.dart';

typedef ContentTypeResolver = Widget Function(ContentType e, {dynamic data});

final filedTypeMap = <String, ContentTypeResolver>{
  "text": getTextField,
  "composite": (ContentType e, {dynamic data}) => Text(e.name),
  "root": (ContentType e, {dynamic data}) => Text(e.name),
  "date": (ContentType e, {dynamic data}) => SizedBox.shrink(),
  "number": getNumberField,
  "toggle": getToggleField,
  "rich-text": getRichTextEditor,
  "reference": (ContentType e, {dynamic data}) => SizedBox.shrink(),
  "media": (ContentType e, {dynamic data}) => getFilesFiled(e, data: data),
};

class ContentTypeInputField {
  ContentTypeInputField({this.contentType, this.content});

  final ContentType? contentType;
  final dynamic content;

  List<Widget> getInputFields() {
    final type = contentType?.type;

    if (type == null) {
      return [];
    }

    ContentTypeResolver? resolver = filedTypeMap[type];

    final List<Widget> fields = [];

    if (resolver == null) {
      return [
        Text("Unknown field type - $type, only: ${filedTypeMap.keys.join(',')}")
      ];
    }

    final field = resolver(contentType!, data: content);
    final contentTypeChildren = (contentType!.children ?? []).asMap();
    final data =
        content != null && content['data'] != null ? content['data'] : null;
    contentTypeChildren.forEach((index, item) {
      final subContentTypeInputFields =
          ContentTypeInputField(contentType: item, content: data);

      fields.addAll(subContentTypeInputFields.getInputFields());
    });

    return [field, ...fields];
  }

  bool _isRepeated(ContentType _contentType) {
    return false;
  }
}
