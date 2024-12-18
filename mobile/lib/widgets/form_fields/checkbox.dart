import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sap_avicola/utils/config/theme.dart';
import 'package:sap_avicola/utils/general/variables.dart';
import 'package:sap_avicola/widgets/defaults/error_text.dart';

// TODO checkout troubles in logic here
class CheckboxField extends StatefulWidget {
  const CheckboxField({
    super.key,
    this.restorationId,
    this.onSaved,
    this.validator,
    this.autovalidateMode,
    this.controller,
    this.initialValue,
    this.disabled = false,
    this.onChanged,
    this.splashRadius = 16,
    this.size,
    this.label,
    this.labelText,
    this.textStyle,
    this.errorText,
    this.errorStyle,
    this.errorWidth,
    this.padding = const EdgeInsets.symmetric(
      horizontal: Vars.gapMedium,
      vertical: Vars.gapMedium,
    ),
    this.gap = Vars.gapMedium,
    this.expanded = false,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.borderRadius = Vars.radius40,
  });
  final String? restorationId;
  final void Function(bool? value)? onSaved;
  final String? Function(bool? value)? validator;
  final AutovalidateMode? autovalidateMode;
  final ValueNotifier<bool>? controller;
  final void Function(bool? value)? onChanged;
  final bool? initialValue;
  final bool disabled;
  final double splashRadius;
  final double? size;
  final Widget? label;
  final String? labelText;
  final TextStyle? textStyle;
  final String? errorText;
  final TextStyle? errorStyle;
  final double? errorWidth;
  final EdgeInsetsGeometry padding;
  final double gap;
  final bool expanded;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final double borderRadius;

  @override
  State<CheckboxField> createState() => _CheckboxFieldState();
}

class _CheckboxFieldState extends State<CheckboxField> {
  FormFieldState<bool>? formState;

  bool getValue(FormFieldState<bool> state) => state.value ?? false;

  void onPressed() {
    formState!.didChange(!getValue(formState!));
    setState(() {});

    if (widget.onChanged != null) widget.onChanged!(getValue(formState!));
  }

  void onListen() {
    if (getValue(formState!) == widget.controller!.value) return;

    formState!.didChange(widget.controller!.value);
  }

  @override
  void initState() {
    widget.controller?.addListener(onListen);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller?.removeListener(onListen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      restorationId: widget.restorationId,
      onSaved: widget.onSaved,
      initialValue: widget.initialValue,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      enabled: !widget.disabled,
      builder: (state) {
        // set values
        formState ??= state;

        widget.controller?.value = getValue(state);

        final labelWidget = widget.label ?? Text(widget.labelText ?? '');

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // field
          TextButton(
            onPressed: onPressed,
            style: ButtonStyle(
              padding: MaterialStatePropertyAll(widget.padding),
              textStyle: MaterialStatePropertyAll(
                  widget.textStyle ?? const TextStyle(fontSize: 12)),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.borderRadius)),
              )),
              overlayColor: MaterialStatePropertyAll(
                  ThemeApp.colors(context).secondary.withOpacity(.3)),
              foregroundColor: MaterialStatePropertyAll(
                  widget.textStyle?.color ?? ThemeApp.colors(context).text),
            ),
            child: Row(
                crossAxisAlignment: widget.crossAxisAlignment,
                mainAxisAlignment: widget.mainAxisAlignment,
                children: [
                  SizedBox(
                    width: widget.size != null ? widget.size! * 2 : null,
                    height: widget.size != null ? widget.size! * 2 : null,
                    child: Material(
                        elevation: 7,
                        shadowColor: ThemeApp.colors(context).secondary,
                        shape: const CircleBorder(),
                        child: Checkbox(
                          value: getValue(state),
                          onChanged: null,
                          side: BorderSide.none,
                          splashRadius: widget.splashRadius,
                          fillColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                          checkColor: ThemeApp.colors(context).secondary,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        )),
                  ),
                  if (widget.label != null || widget.labelText != null) ...[
                    Gap(widget.gap).row,
                    widget.expanded
                        ? Expanded(child: labelWidget)
                        : labelWidget,
                  ]
                ]),
          ),

          // error text
          if (state.hasError && (widget.errorText?.isNotEmpty ?? true))
            ErrorText(
              widget.errorText ?? state.errorText ?? '',
              style: widget.errorStyle ??
                  Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
            )
        ]);
      },
    );
  }
}

/// version without formState
class CheckboxFieldV2 extends StatefulWidget {
  const CheckboxFieldV2({
    super.key,
    this.restorationId,
    this.onSaved,
    this.validator,
    this.autovalidateMode,
    this.controller,
    this.initialValue,
    this.disabled = false,
    this.onChanged,
    this.splashRadius = 16,
    this.size,
    this.label,
    this.labelText,
    this.textStyle,
    this.errorText,
    this.errorStyle,
    this.errorWidth,
    this.padding = const EdgeInsets.symmetric(
      horizontal: Vars.gapMedium,
      vertical: Vars.gapMedium,
    ),
    this.gap = Vars.gapMedium,
    this.expanded = false,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.borderRadius = Vars.radius8,
  });
  final String? restorationId;
  final void Function(bool? value)? onSaved;
  final String? Function(bool? value)? validator;
  final AutovalidateMode? autovalidateMode;
  final ValueNotifier<bool>? controller;
  final void Function(bool? value)? onChanged;
  final bool? initialValue;
  final bool disabled;
  final double splashRadius;
  final double? size;
  final Widget? label;
  final String? labelText;
  final TextStyle? textStyle;
  final String? errorText;
  final TextStyle? errorStyle;
  final double? errorWidth;
  final EdgeInsetsGeometry padding;
  final double gap;
  final bool expanded;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final double borderRadius;

  @override
  State<CheckboxFieldV2> createState() => _CheckboxFieldV2State();
}

class _CheckboxFieldV2State extends State<CheckboxFieldV2> {
  FormFieldState<bool>? formState;

  bool get getValue => widget.controller?.value ?? false;

  void onPressed() {
    widget.controller?.value = !getValue;
    setState(() {});

    if (widget.onChanged != null) widget.onChanged!(getValue);
  }

  @override
  Widget build(BuildContext context) {
    final labelWidget = widget.label ?? Text(widget.labelText ?? '');

    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStatePropertyAll(widget.padding),
        textStyle: MaterialStatePropertyAll(
          widget.textStyle ?? TextStyle(fontSize: 12.sp),
        ),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
        )),
        overlayColor: MaterialStatePropertyAll(
            ThemeApp.colors(context).label.withOpacity(.3)),
        foregroundColor: MaterialStatePropertyAll(
            widget.textStyle?.color ?? ThemeApp.colors(context).text),
      ),
      child: Row(
          crossAxisAlignment: widget.crossAxisAlignment,
          mainAxisAlignment: widget.mainAxisAlignment,
          children: [
            Container(
              width: widget.size != null ? widget.size! * 2 : 25,
              height: widget.size != null ? widget.size! * 2 : 25,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: ThemeApp.colors(context).primary,
                ),
                borderRadius:
                    const BorderRadius.all(Radius.circular(Vars.radius4)),
              ),
              child: Checkbox(
                value: getValue,
                onChanged: null,
                side: const BorderSide(color: Colors.transparent),
                splashRadius: widget.splashRadius,
                fillColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).inputDecorationTheme.fillColor!),
                activeColor: ThemeApp.colors(context).primary,
                checkColor: ThemeApp.colors(context).primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
            if (widget.label != null || widget.labelText != null) ...[
              Gap(widget.gap).row,
              widget.expanded ? Expanded(child: labelWidget) : labelWidget,
            ]
          ]),
    );
  }
}
