import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  void safePop() {
    if (Navigator.canPop(this)) {
      Navigator.pop(this);
    }
  }
}
