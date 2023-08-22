import 'package:flutter/material.dart';
import 'package:plenty_cms/service/models/content.dart';
import 'package:flutter_rte/flutter_rte.dart';

Widget getRichTextEditor(ContentType contentType, {dynamic data}) {
  return Container(
      height: 120,
      child: HtmlEditor(
        initialValue: "Hello World",
        onChanged: (p0) {
          print(p0);
        },
      ));
}
