import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
    this.fallbackRouteName = 'dashboard',
    this.onPressed,
  });

  final String fallbackRouteName;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: const Icon(Icons.arrow_back),
      onPressed: onPressed ?? () => _navigateBack(context),
    );
  }

  void _navigateBack(BuildContext context) {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.maybePop();
      return;
    }

    try {
      context.goNamed(fallbackRouteName);
    } on Object {
      // Some isolated widget tests mount screens without a GoRouter.
    }
  }
}
