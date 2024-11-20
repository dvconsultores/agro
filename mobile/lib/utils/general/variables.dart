import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sap_avicola/utils/config/theme.dart';
import 'package:sap_avicola/utils/services/local_data/env_service.dart';

/// Used to storage a collection of global constant Vars.
mixin Vars {
  static final isProduction = env.environment == "production";

  // * fetching
  static const requestTiming = 20;

  // * values
  static const maxDecimals = 3;

  // * Sizing
  static const mSize = Size(360, 800);

  static const bottomNavbarHeight = 52;

  static double getBodyHeight(
    BuildContext context, {
    double headerHeight = 0,
    double other = 0,
  }) {
    final media = MediaQuery.of(context);
    return media.size.height - (headerHeight + media.viewPadding.top + other);
  }

  static const double buttonHeight = 46;

  static final paddingScaffold = EdgeInsets.symmetric(
    vertical: 16.sp,
    horizontal: 16.sp,
  );

  static const double gapXLow = 2,
      gapLow = 4,
      gapNormal = 8,
      gapMedium = 10,
      gapLarge = 12,
      gapXLarge = 16,
      gapMax = 20;

  static const double radius50 = 50,
      radius40 = 40,
      radius30 = 30,
      radius20 = 20,
      radius28 = 28,
      radius15 = 15,
      radius12 = 12,
      radius10 = 10,
      radius8 = 8,
      radius4 = 4;

  // gradient
  static LinearGradient getGradient(BuildContext context) => LinearGradient(
          transform: const GradientRotation(-30),
          tileMode: TileMode.mirror,
          colors: [
            ThemeApp.colors(context).tertiary.withOpacity(.2),
            ThemeApp.colors(context).primary.withOpacity(.3),
            ThemeApp.colors(context).tertiary.withOpacity(.2),
          ]);

  // * others
  static const boxShadow1 = BoxShadow(
        color: Color.fromRGBO(0, 0, 0, .25),
        spreadRadius: 0,
        blurRadius: 2,
        offset: Offset(0, 1),
      ),
      boxShadow2 = BoxShadow(
        color: Color.fromRGBO(0, 0, 0, .15),
        spreadRadius: 1,
        blurRadius: 3,
        offset: Offset(0, 1),
      ),
      boxShadow3 = BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.3),
        spreadRadius: 0,
        blurRadius: 4,
        offset: Offset(0, 1),
      ),
      boxShadow4 = BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.22),
        spreadRadius: 0,
        blurRadius: 15,
        offset: Offset(0, 3),
      );

  static const double minInputHeight = 42, maxInputHeight = 50;

  // RegExps
  static final nicknameRegExp = RegExp(r'^[a-zA-ZñÑ0-9_-]{5,12}$'),
      emailRegExp = RegExp(r'^[a-zA-Z\-\_0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+'),
      passwordRegExp = RegExp(
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%&*-.]).{6,}$'),
      phoneRegExp = RegExp(
          r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)');
}
