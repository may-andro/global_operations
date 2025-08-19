import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/bloc/bloc.dart';

class CommentTextFieldWidget extends StatefulWidget {
  const CommentTextFieldWidget({
    super.key,
    required this.adPanel,
    required this.index,
  });

  final AdPanelEntity adPanel;
  final int index;

  @override
  State<CommentTextFieldWidget> createState() => _CommentTextFieldWidgetState();
}

class _CommentTextFieldWidgetState extends State<CommentTextFieldWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.adPanel.additionalComments ?? '',
    );
  }

  @override
  void didUpdateWidget(covariant CommentTextFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.adPanel.additionalComments !=
        widget.adPanel.additionalComments) {
      _controller.text = widget.adPanel.additionalComments ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final updated = widget.adPanel.copyWith(additionalComments: value.trim());
    context.read<AdPanelBloc>().add(EditAdPanelEvent(widget.index, updated));
  }

  @override
  Widget build(BuildContext context) {
    return DSTextFieldWidget(
      key: const Key('comment_input_widget'),
      hintText: context.localizations.adPanelCommentHint,
      controller: _controller,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      maxLines: 5,
      textCapitalization: TextCapitalization.sentences,
      onFieldSubmitted: _onChanged,
      onChanged: _onChanged,
    );
  }
}
