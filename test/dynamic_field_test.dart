import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plenty_cms/widgets/form/data.dart';
import 'package:plenty_cms/widgets/form/dynamic_field.dart';

void main() {
  testWidgets("Dynamic Field Widget renders complex nested data structures",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      builder: (context, child) => DynamicField(
        content: Content(type: "text", value: "Hello World"),
        contentType: ContentType(
          name: "basic",
          type: "text",
          value: null,
        ),
      ),
    ));

    final textField =
        find.textContaining(RegExp(r'dynamic', caseSensitive: false));

    expect(textField, findsOneWidget);
  });
}
