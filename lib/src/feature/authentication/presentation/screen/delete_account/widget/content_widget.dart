import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/delete_account/widget/form_card_widget.dart';
import 'package:global_ops/src/feature/authentication/presentation/widget/widget.dart';

class ContentWidget extends StatefulWidget {
  const ContentWidget({super.key});

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget>
    with TickerProviderStateMixin {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;
  late final AnimationController _animationController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const _iconWidget = AnimatedIconWidget(icon: Icons.warning);

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _focusNode = FocusNode();
    _animationController = AnimationController(
      duration: 1500.milliseconds,
      vsync: this,
    );

    // Start animations after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formWidget = FormCardWidget(
      key: const ValueKey('delete_account_form_card'),
      textController: _textController,
      focusNode: _focusNode,
      formKey: _formKey,
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
