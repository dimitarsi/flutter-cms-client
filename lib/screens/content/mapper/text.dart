import 'package:flutter/material.dart';

import '../../../service/models/content.dart';

Widget getTextField(ContentType e, {Content? content}) => TextFormField(
      decoration: InputDecoration(hintText: e.name),
      initialValue: content?.data ?? "",
      onSaved: (val) {
        if (content != null) {
          content.data = val;
        }
      },
    );
