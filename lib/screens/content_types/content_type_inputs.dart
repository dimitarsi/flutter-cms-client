import 'package:flutter/material.dart';
import 'package:plenty_cms/helpers/slugify.dart';

import '../../service/models/content.dart';

class ContentTypeInputs extends StatelessWidget {
  ContentTypeInputs({super.key, required this.contentType});

  ContentType? contentType;

  @override
  Widget build(BuildContext context) {
    if (contentType == null) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        getInputByType(contentType!),
        ...(contentType!.children ?? [])
            .map((child) => ContentTypeInputs(contentType: child))
            .toList()
      ],
    );
  }

  Widget getInputByType(ContentType contentType) {
    return Container(
      child: TextFormField(
        initialValue: contentType.name,
        onChanged: (value) {
          contentType.slug = slugify(value);
          contentType.name = value;
        },
      ),
    );
  }
}
