import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sap_avicola/utils/config/theme.dart';
import 'package:sap_avicola/utils/general/variables.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.child,
    this.color,
    this.border,
    this.padding = const EdgeInsets.symmetric(
      vertical: Vars.gapLarge,
      horizontal: Vars.gapMedium,
    ),
    this.margin,
    this.boxShadow = const [Vars.boxShadow1],
    this.borderRadius = const BorderRadius.all(Radius.circular(Vars.radius8)),
    this.onTap,
    this.constraints,
    this.width = double.maxFinite,
    this.height,
  });
  final Widget child;
  final Color? color;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? boxShadow;
  final BorderRadius borderRadius;
  final void Function()? onTap;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        constraints: constraints,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
          color: color ?? theme.cardColor,
          boxShadow: boxShadow,
        ),
        child: child,
      ),
    );
  }
}

class CardWidgetV2 extends StatelessWidget {
  const CardWidgetV2({
    super.key,
    this.color,
    this.onTap,
    this.constraints,
    this.height,
    this.width,
    this.padding = const EdgeInsets.all(Vars.gapMedium),
    this.margin = const EdgeInsets.all(0),
    this.border,
    this.clipBehavior = Clip.none,
    this.boxShadow = const [Vars.boxShadow1],
    this.child,
  });

  final Color? color;
  final void Function()? onTap;
  final EdgeInsets? padding;
  final EdgeInsetsGeometry? margin;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;
  final Clip clipBehavior;
  final BoxBorder? border;
  final List<BoxShadow> boxShadow;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final colores = ThemeApp.colors(context), theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        clipBehavior: clipBehavior,
        constraints: constraints,
        decoration: BoxDecoration(
          color: color ?? theme.cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(Vars.radius8)),
          boxShadow: boxShadow,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(Vars.radius8)),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              border: border ??
                  Border(
                      bottom: BorderSide(
                    width: 4.sp,
                    color: colores.primaryDarken,
                  )),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
