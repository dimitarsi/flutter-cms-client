import 'package:flutter/material.dart';

import '../../../service/models/content.dart';

Widget getTextField(ContentType e, {dynamic data}) {
  return TextFormField(
    decoration: InputDecoration(hintText: e.name),
    initialValue: "",
    onSaved: (String? val) {
      // if (data != null && val != null) {
      //   data.setTextData(val);
      // }
    },
  );
}
