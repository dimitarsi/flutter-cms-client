import 'package:flutter/material.dart';
import 'package:plenty_cms/screens/content/mapper/files.dart';
import '../../service/models/content.dart';
import 'mapper/number.dart';
import 'mapper/text.dart';

typedef ContentTypeResolver = Widget Function(ContentType e,
    {Content? content});

final filedTypeMap = <String, ContentTypeResolver>{
  "text": getTextField,
  "composite": (ContentType e, {Content? content}) => Text(e.name),
  "root": (ContentType e, {Content? content}) => Text(e.name),
  "date": (ContentType e, {Content? content}) => SizedBox.shrink(),
  "number": getNumberField,
  "reference": (ContentType e, {Content? content}) => SizedBox.shrink(),
  "media": (ContentType e, {Content? content}) =>
      getFilesFiled(e, content: content),
  "other": (ContentType e, {Content? content}) =>
      Text("Unsupported type - ${e.type}")
};

class ContentTypeInputField extends StatelessWidget {
  ContentTypeInputField(
      {super.key, required this.contentType, required this.content});

  final ContentType contentType;
  final Content content;

  @override
  Widget build(BuildContext context) {
    // if (contentType.type != "root" && contentType.type != "composite") {
    //   return TextFormField(
    //     decoration: InputDecoration(hintText: contentType.name),
    //   );
    // }
    ContentTypeResolver? resolver = filedTypeMap.keys.contains(contentType.type)
        ? filedTypeMap[contentType.type]
        : filedTypeMap['other'];

    final contentTypeChildren = (contentType.children ?? []).toSet();
    late Widget field;

    if (resolver == null) {
      return const SizedBox.shrink();
    } else {
      field = resolver(contentType, content: content);
    }

    final childFields = [];

    for (var i = 0; i < contentTypeChildren.length; i++) {
      final e = contentTypeChildren.elementAt(i);

      if (content.data[e.slug] == null) {
        content.data[e.slug] = Content(name: e.name, slug: e.slug, data: null);
      }

      //TODO: repeated needs to be implemented
      if (_isRepeated(e)) {
        final list = <Content>[];
        content.data[e.slug] = list;
        list.add(Content(name: e.name, slug: e.slug, data: null));
      }

      try {
        content.data[e.slug] = Content.fromJson(content.data[e.slug]);
      } catch (_e) {
        print("Unable to convert ${e.slug} to Content");
        print(_e);
      }

      childFields.add(ContentTypeInputField(
        contentType: e,
        content: content.data[e.slug],
      ));
    }

    return Column(
      children: [field, ...childFields],
    );
  }

  bool _isRepeated(ContentType _contentType) {
    return false;
  }
}
