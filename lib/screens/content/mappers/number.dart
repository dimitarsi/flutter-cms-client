import 'package:flutter/material.dart';

import '../../../service/models/content.dart';

Widget getNumberField(ContentType e, {dynamic data}) => TextFormField(
    initialValue: "",
    validator: (value) {
      final res = double.tryParse(value ?? "");

      if (res == null) {
        return "Number is needed";
      }

      return null;
    },
    decoration: InputDecoration(label: Text(e.name)),
    onSaved: (val) {
      data[e.slug] = val;
    });
