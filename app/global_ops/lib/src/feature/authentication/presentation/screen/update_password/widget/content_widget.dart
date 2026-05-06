import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/update_password/widget/form_card_widget.dart';
import 'package:global_ops/src/feature/authentication/presentation/widget/widget.dart';

class ContentWidget extends StatefulWidget {
  const ContentWidget({super.key});

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  late final TextEditingController _currentPasswordTextController;
  late final TextEditingController _newPasswordTextController;
  late final FocusNode _currentPasswordFocusNode;
  late final FocusNode _newPasswordFocusNode;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _currentPasswordTextController = TextEditingController();
    _newPasswordTextController = TextEditingController();
    _currentPasswordFocusNode = FocusNode();
    _newPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _currentPasswordFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    _currentPasswordTextController.dispose();
    _newPasswordTextController.dispose();
    super.dispose();
  }

  static const _iconWidget = AnimatedIconWidget(icon: Icons.update);

  @override
  Widget build(BuildContext context) {
    final formWidget = FormCardWidget(
      key: const ValueKey('update_password_form_card'),
      formKey: _formKey,
      currentPasswordController: _currentPasswordTextController,
      newPasswordController: _newPasswordTextController,
      currentPasswordFocusNode: _currentPasswordFocusNode,
      newPasswordFocusNode: _newPasswordFocusNode,
    );

    if (context.isDesktop) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const DSHorizontalSpacerWidget(5),
          const Expanded(child: _iconWidget),
          Expanded(
            flex: 2,
            child: Center(child: SingleChildScrollView(child: formWidget)),
          ),
          const DSHorizontalSpacerWidget(5),
        ],
      );
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const DSVerticalSpacerWidget(5),
          _iconWidget,
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
    );
  }
}
