import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/login/widget/form_card_widget.dart';
import 'package:global_ops/src/feature/authentication/presentation/widget/animated_icon_widget.dart';

class ContentWidget extends StatefulWidget {
  const ContentWidget({super.key});

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formWidget = FormCardWidget(
      key: const ValueKey('login_form_card'),
      formKey: _formKey,
      emailController: _emailController,
      passwordController: _passwordController,
      emailFocusNode: _emailFocusNode,
      passwordFocusNode: _passwordFocusNode,
    );

    if (context.isDesktop) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const DSHorizontalSpacerWidget(5),
          const Expanded(
            child: AnimatedIconWidget(iconAsset: DSSvgAssetImage.iconLogoDark),
          ),
          Expanded(
            flex: 2,
            child: Center(child: SingleChildScrollView(child: formWidget)),
          ),
          const DSHorizontalSpacerWidget(5),
        ],
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DSVerticalSpacerWidget(5),
            const AnimatedIconWidget(iconAsset: DSSvgAssetImage.logoDark),
            const DSVerticalSpacerWidget(5),
            Flexible(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.space(factor: 3),
                  ),
                  child: formWidget,
                ),
              ),
            ),
            const DSVerticalSpacerWidget(5),
          ],
        ),
      ),
    );
  }
}
