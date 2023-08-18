import 'package:flutter/material.dart';

import '../../../service/models/content.dart';

Widget getNumberField(ContentType e, {Content? content}) => TextFormField(
    initialValue: content?.data ?? "",
    validator: (value) {
      final res = double.tryParse(value ?? "");

      if (res == null) {
        return "Number is needed";
      }

      return null;
    },
    decoration: InputDecoration(label: Text(e.name)),
    onSaved: (val) {
      if (content != null) {
        content.data = val;
      }
    });
