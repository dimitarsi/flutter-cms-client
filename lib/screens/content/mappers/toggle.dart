import 'package:flutter/material.dart';
import 'package:plenty_cms/service/models/content.dart';

Widget getToggleField(ContentType contentType, {dynamic data}) {
  return SwitchListTile(
    value: false, // data[contentType.slug] ?? contentType.getToggleDefault(),
    onChanged: (val) => {data = val},
    title: Text(contentType.name ?? "[Unknown contentType]"),
  );
}
