import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension ContextExtension on BuildContext {
  void safePop() {
    if (GoRouter.of(this).canPop()) {
      GoRouter.of(this).pop();
    }
  }
}
