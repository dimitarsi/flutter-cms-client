import 'package:flutter/material.dart';

class ModalOverlay extends Positioned {
  ModalOverlay({
    super.key,
    super.left = 0,
    super.top = 0,
    super.right = 0,
    super.bottom = 0,
    super.width,
    super.height,
    required super.child,
  });

  factory ModalOverlay.offsetRight(double offset,
          {required Widget child, double? maxHeight}) =>
      ModalOverlay(
        right: offset,
        bottom: offset,
        top: offset,
        left: null,
        child: Container(
            padding: EdgeInsets.all(20),
            constraints: BoxConstraints(
                maxWidth: 600, maxHeight: maxHeight ?? double.infinity),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: child),
      );
}
