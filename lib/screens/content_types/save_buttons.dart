import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app_router.dart';
import '../../service/models/content.dart';

ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15));

class SaveButtons extends StatelessWidget {
  const SaveButtons({
    super.key,
    this.onSubmit,
    required this.contentType,
  });

  final ContentType? contentType;

  final void Function()? onSubmit;

  @override
  Widget build(BuildContext context) {
    if (contentType == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: SizedBox(
        width: 450,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: () {
                  if (GoRouter.of(context).canPop()) {
                    GoRouter.of(context).pop();
                  } else {
                    context.go(AppRouter.contentTypeListPath);
                  }
                },
                child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                print("OnSubmit - ${contentType.hashCode}");
                onSubmit?.call();
              },
              style: buttonStyle,
              child: Text("Update"),
            )
          ],
        ),
      ),
    );
  }
}
