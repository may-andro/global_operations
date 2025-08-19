import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class DSDigitTextFieldWidget extends StatefulWidget {
  const DSDigitTextFieldWidget({
    super.key,
    this.focusNode,
    required this.controller,
    required this.length,
    this.onCompleted,
    this.autoDisposeController = true,
    this.errorTextSpace = 16,
    this.errorMessage,
  });

  final TextEditingController controller;
  final int length;
  final FocusNode? focusNode;
  final ValueChanged<String>? onCompleted;
  final bool autoDisposeController;
  final double errorTextSpace;
  final String? errorMessage;

  @override
  State<DSDigitTextFieldWidget> createState() => _DSDigitTextFieldWidgetState();
}

class _DSDigitTextFieldWidgetState extends State<DSDigitTextFieldWidget> {
  final FocusNode _privateFocusNode = FocusNode();
  String? errorMessage;

  FocusNode get _focusNode => widget.focusNode ?? _privateFocusNode;

  @override
  void initState() {
    super.initState();
    errorMessage = widget.errorMessage;
  }

  @override
  void didUpdateWidget(DSDigitTextFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorMessage != oldWidget.errorMessage) {
      errorMessage = widget.errorMessage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      focusNode: _focusNode,
      controller: widget.controller,
      appContext: context,
      backgroundColor: Colors.transparent,
      textStyle: context.typography.bodyMedium.textStyle,
      length: widget.length,
      onChanged: (text) {
        setState(() {
          errorMessage = null;
        });
      },
      onCompleted: widget.onCompleted,
      keyboardAppearance: Theme.of(context).brightness,
      keyboardType: TextInputType.number,
      animationType: AnimationType.fade,
      enableActiveFill: true,
      cursorColor: context.colorPalette.brand.prominent.color,
      autoDisposeControllers: widget.autoDisposeController,
      autoFocus: true,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        activeColor: context.colorPalette.neutral.grey3.color,
        activeFillColor: context.colorPalette.neutral.grey3.color,
        inactiveColor: context.colorPalette.neutral.grey2.color,
        inactiveFillColor: context.colorPalette.neutral.grey2.color,
        selectedColor: context.colorPalette.neutral.grey3.color,
        selectedFillColor: context.colorPalette.neutral.grey3.color,
        fieldHeight: context.fieldHeight,
        fieldWidth: context.fieldWidth,
        borderRadius: BorderRadius.circular(context.dimen.radiusLevel1.value),
      ),
      errorTextSpace: widget.errorTextSpace,

      validator: (input) {
        if (input == null || input.isEmpty) {
          return 'Code can not be empty';
        }
        if (input.length < widget.length) {
          return 'Code must be ${widget.length} digits long';
        }

        if (errorMessage case final String errorMessage) {
          return errorMessage;
        }

        return null;
      },
    );
  }
}

extension on BuildContext {
  double get fieldHeight {
    switch (deviceWidth) {
      case DSDeviceWidthResolution.xs:
        return space(factor: 7);
      case DSDeviceWidthResolution.s:
        return space(factor: 6);
      case DSDeviceWidthResolution.m:
        return space(factor: 3);
      case DSDeviceWidthResolution.l:
        return space(factor: 3);
      case DSDeviceWidthResolution.xl:
        return space(factor: 3);
    }
  }

  double get fieldWidth {
    switch (deviceWidth) {
      case DSDeviceWidthResolution.xs:
        return space(factor: 6);
      case DSDeviceWidthResolution.s:
        return space(factor: 5);
      case DSDeviceWidthResolution.m:
        return space(factor: 3);
      case DSDeviceWidthResolution.l:
        return space(factor: 3);
      case DSDeviceWidthResolution.xl:
        return space(factor: 3);
    }
  }
}
