import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sap_avicola/utils/config/theme.dart';
import 'package:sap_avicola/utils/extensions/type_extensions.dart';
import 'package:sap_avicola/utils/general/context_utility.dart';
import 'package:sap_avicola/utils/general/custom_focus_node.dart';
import 'package:sap_avicola/utils/general/variables.dart';
import 'package:sap_avicola/widgets/defaults/error_text.dart';
import 'package:sap_avicola/widgets/sheets/bottom_sheet_card.dart';

class BottomSelectField<T> extends StatefulWidget {
  const BottomSelectField({
    super.key,
    this.restorationId,
    this.onSaved,
    this.validator,
    this.autovalidateMode,
    this.onChanged,
    required this.items,
    this.controller,
    this.initialValue,
    this.width = double.maxFinite,
    this.height,
    this.decoration,
    this.leading,
    this.trailing,
    this.disabled = false,
    this.loading = false,
    this.loaderHeight = 20,
    this.emptyDataMessage,
    this.hideTrailing = false,
    this.hintText,
    this.textAlignHint,
    this.hintStyle,
    this.errorText,
    this.errorStyle,
    this.borderRadius = const BorderRadius.all(Radius.circular(Vars.radius10)),
    this.border,
    this.borderDisabled,
    this.borderFocused,
    this.bgColor,
    this.boxShadow,
    this.gap = 5,
    this.padding = const EdgeInsets.symmetric(
      horizontal: Vars.gapMedium,
      vertical: Vars.gapMedium,
    ),
    this.dense = false,
    this.dropdownInitialChildSize = .45,
    this.dropdownMaxChildSize = .45,
    this.dropdownMinChildSize = .2,
    this.dropdownScrollable = true,
    this.dropdownTitle,
    this.dropdownTitleText,
    this.dropdownTitleStyle,
    this.dropdownBottomWidget,
    this.focusNode,
    this.labelText,
    this.labelStyle,
    this.floatingLabelStyle,
    this.floatingLabelBehavior = FloatingLabelBehavior.always,
    this.dropdownSearchFunction,
    this.dropdownSearchLabelText,
    this.dropdownSearchHintText,
  });
  final String? restorationId;
  final void Function(T? value)? onSaved;
  final String? Function(T? value)? validator;
  final AutovalidateMode? autovalidateMode;
  final Function(T? value)? onChanged;
  final List<DropdownMenuItem<T>> items;
  final ValueNotifier<T?>? controller;
  final T? initialValue;
  final double width;
  final double? height;
  final BoxDecoration? decoration;
  final Widget? leading;
  final Widget? trailing;
  final bool disabled;
  final bool loading;
  final String? emptyDataMessage;
  final bool hideTrailing;
  final String? hintText;
  final TextAlign? textAlignHint;
  final TextStyle? hintStyle;
  final String? errorText;
  final TextStyle? errorStyle;
  final BorderRadiusGeometry borderRadius;
  final BorderSide? border;
  final BorderSide? borderDisabled;
  final BorderSide? borderFocused;
  final Color? bgColor;
  final List<BoxShadow>? boxShadow;
  final double gap;
  final EdgeInsetsGeometry padding;
  final double loaderHeight;
  final bool dense;
  final double dropdownInitialChildSize;
  final double dropdownMaxChildSize;
  final double dropdownMinChildSize;
  final bool dropdownScrollable;
  final Widget? dropdownTitle;
  final String? dropdownTitleText;
  final TextStyle? dropdownTitleStyle;
  final Widget? dropdownBottomWidget;
  final CustomFocusNode? focusNode;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextStyle? floatingLabelStyle;
  final FloatingLabelBehavior floatingLabelBehavior;
  final bool Function(int index, DropdownMenuItem<T>, String)?
      dropdownSearchFunction;
  final String? dropdownSearchLabelText;
  final String? dropdownSearchHintText;

  @override
  State<BottomSelectField<T>> createState() => _BottomSelectFieldState<T>();
}

class _BottomSelectFieldState<T> extends State<BottomSelectField<T>>
    with SingleTickerProviderStateMixin {
  FormFieldState<T>? formState;

  late final AnimationController labelAnimationController;

  final localController = ValueNotifier<T?>(null);
  ValueNotifier<T?> get getController => widget.controller ?? localController;

  final _focusNode = CustomFocusNode();
  CustomFocusNode get focusNode => widget.focusNode ?? _focusNode;
  bool get isFocused => focusNode.value;

  void onListenController() {
    if (formState!.value == getController.value) return;

    formState!.didChange(getController.value);

    if (widget.floatingLabelBehavior == FloatingLabelBehavior.auto) {
      getController.value != null
          ? labelAnimationController.forward()
          : labelAnimationController.reverse();
    }

    if (widget.onChanged != null) widget.onChanged!(formState!.value);
  }

  Future<void> onListenFocusNode() async {
    setState(() {});

    if (!isFocused) return;

    final canAnimateLabel =
        widget.floatingLabelBehavior == FloatingLabelBehavior.auto &&
            getController.value == null;

    if (canAnimateLabel) labelAnimationController.forward();

    final item = await BottomSheetList.showModal<T>(
      ContextUtility.context!,
      items: widget.items,
      title: widget.dropdownTitle,
      titleText: widget.dropdownTitleText,
      titleStyle: widget.dropdownTitleStyle,
      emptyDataText: widget.emptyDataMessage,
      initialChildSize: widget.dropdownInitialChildSize,
      maxChildSize: widget.dropdownMaxChildSize,
      minChildSize: widget.dropdownMinChildSize,
      scrollable: widget.dropdownScrollable,
      bottomWidget: widget.dropdownBottomWidget,
      searchFunction: widget.dropdownSearchFunction,
      searchLabelText: widget.dropdownSearchLabelText,
      searchHintText: widget.dropdownSearchHintText,
      draggableFrameBgColor: Colors.transparent,
      draggableFrameColor: ThemeApp.colors(context).label,
    );

    if (canAnimateLabel) labelAnimationController.reverse();

    getController.value = item?.value ?? formState!.value;
    focusNode.unfocus();
  }

  @override
  void initState() {
    getController.addListener(onListenController);
    focusNode.addListener(onListenFocusNode);
    labelAnimationController = AnimationController(
      vsync: this,
      duration: Durations.short3,
      value:
          widget.floatingLabelBehavior == FloatingLabelBehavior.always ? 1 : 0,
    );
    super.initState();
  }

  @override
  void dispose() {
    getController.removeListener(onListenController);
    localController.dispose();
    focusNode.removeListener(onListenFocusNode);
    labelAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FormField<T>(
      restorationId: widget.restorationId,
      onSaved: widget.onSaved,
      initialValue: widget.initialValue,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      enabled: !widget.disabled,
      builder: (state) {
        // set values
        formState ??= state;
        widget.controller?.value = state.value;

        final bgColor = widget.bgColor ?? theme.inputDecorationTheme.fillColor!,
            height = widget.height ??
                (widget.dense ? Vars.minInputHeight : Vars.maxInputHeight);

        return SizedBox(
          width: widget.width,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // field
            GestureDetector(
              onTap: () {
                if (widget.loading) return;
                focusNode.focus();
              },
              child: Container(
                  width: widget.width,
                  height: height,
                  padding: widget.padding,
                  decoration: widget.decoration ??
                      BoxDecoration(
                          borderRadius: widget.borderRadius,
                          color: bgColor,
                          boxShadow: widget.boxShadow ?? [Vars.boxShadow1],
                          border: Border.fromBorderSide(
                            widget.disabled
                                ? widget.borderDisabled ?? BorderSide.none
                                : isFocused
                                    ? widget.borderFocused ?? BorderSide.none
                                    : widget.border ?? BorderSide.none,
                          )),
                  child: Row(children: [
                    if (widget.leading != null) ...[
                      widget.leading!,
                      Gap(widget.gap).row,
                    ],
                    _ContentWidget(
                      items: widget.items,
                      labelAnimationController: labelAnimationController,
                      bgColor: bgColor,
                      state: state,
                      textAlignHint: widget.textAlignHint,
                      loading: widget.loading,
                      loaderHeight: widget.loaderHeight,
                      labelText: widget.labelText,
                      labelStyle: widget.labelStyle,
                      floatingLabelStyle: widget.floatingLabelStyle,
                      hintText: widget.hintText,
                      hintStyle: widget.hintStyle,
                    ),
                    if (!widget.hideTrailing) ...[
                      Gap(widget.gap).row,
                      widget.trailing ??
                          (isFocused
                              ? const Icon(Icons.keyboard_arrow_up_rounded)
                              : const Icon(Icons.keyboard_arrow_down_rounded))
                    ]
                  ])),
            ),

            // error text
            if (state.hasError && (widget.errorText?.isNotEmpty ?? true))
              ErrorText(
                widget.errorText ?? state.errorText ?? '',
                style: widget.errorStyle ??
                    theme.textTheme.labelMedium
                        ?.copyWith(color: theme.colorScheme.error),
              )
          ]),
        );
      },
    );
  }
}

class _ContentWidget<T> extends StatelessWidget {
  const _ContentWidget({
    this.loading = false,
    this.loaderHeight = 20,
    required this.items,
    required this.labelAnimationController,
    required this.bgColor,
    this.hintText,
    this.textAlignHint,
    this.hintStyle,
    this.labelText,
    this.labelStyle,
    this.floatingLabelStyle,
    required this.state,
  });
  final bool loading;
  final double loaderHeight;
  final List<DropdownMenuItem<T>> items;
  final AnimationController labelAnimationController;
  final Color bgColor;
  final String? hintText;
  final TextAlign? textAlignHint;
  final TextStyle? hintStyle;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextStyle? floatingLabelStyle;
  final FormFieldState<T> state;

  @override
  Widget build(BuildContext context) {
    final colors = ThemeApp.colors(context);

    final hs = hintStyle ??
            TextStyle(
              color: colors.text.withOpacity(.7),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
        ls = labelStyle ??
            TextStyle(
              color: colors.label,
              fontSize: 15.sp,
            ),
        fls = floatingLabelStyle ?? ls;

    final hintWidget = Text(
      hintText ?? "",
      textAlign: textAlignHint,
      style: hs,
    );

    return Expanded(
      child: LayoutBuilder(
          builder: (context, constraints) => loading
              // loader
              ? LinearProgressIndicator(
                  borderRadius:
                      const BorderRadius.all(Radius.circular(Vars.radius10)),
                  color: colors.primary,
                  minHeight: loaderHeight,
                )
              : Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  alignment: Alignment.centerLeft,
                  children: [
                      // value
                      Align(
                        alignment: Alignment.centerLeft,
                        child: items
                                .singleWhereOrNull(
                                    (element) => element.value == state.value)
                                ?.child ??

                            // hintText
                            hintWidget,
                      ),

                      // labelText
                      if (labelText.hasValue)
                        AnimatedBuilder(
                            animation: labelAnimationController,
                            builder: (context, child) {
                              final scaleAnimation = Tween<double>(
                                    begin: 1,
                                    end: .78,
                                  ).animate(labelAnimationController),
                                  animationY = Tween<double>(
                                    begin: 0,
                                    end: constraints.maxHeight - 2,
                                  ).animate(labelAnimationController),
                                  animationX = Tween<double>(
                                    begin: 0,
                                    end: -constraints.maxWidth * .11,
                                  ).animate(labelAnimationController);

                              final isFloating =
                                  labelAnimationController.isCompleted ||
                                      labelAnimationController.isAnimating;

                              return Positioned(
                                  top: -animationY.value,
                                  left: animationX.value,
                                  width:
                                      isFloating ? null : constraints.maxWidth,
                                  child: Transform.scale(
                                      scale: scaleAnimation.value,
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        color: isFloating ? null : bgColor,
                                        width: constraints.maxWidth,
                                        height: constraints.maxHeight,
                                        child: Text(
                                          labelText!,
                                          overflow: TextOverflow.ellipsis,
                                          style: (isFloating ? fls : ls)
                                              .copyWith(
                                                  backgroundColor: bgColor),
                                        ),
                                      )));
                            })
                    ])),
    );
  }
}
