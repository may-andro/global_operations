import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorPalette.brand.prominent.color,
      body: Center(
        child: DSLoadingWidget(
          size: context.space(factor: 5),
          color: context.colorPalette.neutral.white,
        ),
      ),
    );
  }
}
