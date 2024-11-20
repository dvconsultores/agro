import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NavConst {
  @optionalTypeArgs
  static Future<T?> push<T extends Object?>(
    BuildContext context,
    Widget page,
  ) async =>
      await Navigator.push<T>(
        context,
        Platform.isIOS
            ? CupertinoPageRoute(builder: (context) => page)
            : MaterialPageRoute(builder: (context) => page),
      );

  @optionalTypeArgs
  static Future<T?> pushAndRemoveUntil<T extends Object?>(
    BuildContext context,
    Widget page,
    RoutePredicate predicate,
  ) async =>
      await Navigator.pushAndRemoveUntil(
        context,
        Platform.isIOS
            ? CupertinoPageRoute(builder: (context) => page)
            : MaterialPageRoute(builder: (context) => page),
        predicate,
      );

  @optionalTypeArgs
  static Future<T?> pushReplacement<T extends Object?>(
    BuildContext context,
    Widget page,
  ) async =>
      await Navigator.pushReplacement(
        context,
        Platform.isIOS
            ? CupertinoPageRoute(builder: (context) => page)
            : MaterialPageRoute(builder: (context) => page),
      );
}