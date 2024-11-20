import 'package:double_back_to_exit/double_back_to_exit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sap_avicola/utils/config/theme.dart';
import 'package:sap_avicola/utils/general/variables.dart';
import 'package:sap_avicola/utils/helper_widgets/will_pop_custom.dart';
import 'package:sap_avicola/widgets/circle_light__blurred_widget.dart';

// * Custom background styled
class _BackgroundStyled extends StatelessWidget {
  const _BackgroundStyled({
    required this.child,
    this.color,
    this.gradient,
    this.decorationImage,
    this.padding,
    required this.scrollable,
    this.paintedScaffold = true,
    this.backgroundStack,
    this.foregroundStack,
  });
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Gradient? gradient;
  final DecorationImage? decorationImage;
  final bool scrollable;
  final bool paintedScaffold;
  final List<Positioned>? backgroundStack;
  final List<Positioned>? foregroundStack;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).scaffoldBackgroundColor;

    final body = Padding(
      padding: padding ?? Vars.paddingScaffold,
      child: child,
    );

    return SafeArea(
      child: Stack(fit: StackFit.expand, children: [
        Positioned.fill(
            child: Container(
                decoration: BoxDecoration(
          color: c,
          gradient: gradient,
          image: decorationImage,
        ))),
        if (paintedScaffold) ...[
          const Positioned(
            bottom: -140,
            left: -140,
            width: 211,
            height: 211,
            child: CircleLightBlurredWidget(),
          ),
          Positioned(
            top: -140,
            right: -140,
            width: 211,
            height: 211,
            child: CircleLightBlurredWidget(
              color: ThemeApp.colors(context).tertiary,
            ),
          )
        ],
        if (backgroundStack != null) ...backgroundStack!,
        scrollable ? SingleChildScrollView(child: body) : body,
        if (foregroundStack != null) ...foregroundStack!,
      ]),
    );
  }
}

/// ? Custom Application scaffold
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.drawer,
    this.appBar,
    this.bottomWidget,
    this.floatingActionButton,
    this.padding,
    this.color,
    this.gradient,
    this.decorationImage,
    this.scrollable = false,
    this.paintedScaffold = true,
    this.doubleBackToExit = false,
    this.goHomeOnBack = false,
    this.onPop,
    this.backgroundStack,
    this.foregroundStack,
  });
  final Widget? drawer;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomWidget;
  final Widget? floatingActionButton;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Gradient? gradient;
  final DecorationImage? decorationImage;
  final bool scrollable;
  final bool paintedScaffold;
  final bool doubleBackToExit;
  final bool goHomeOnBack;
  final VoidCallback? onPop;
  final List<Positioned>? backgroundStack;
  final List<Positioned>? foregroundStack;

  @override
  Widget build(BuildContext context) {
    return DoubleBackToExit(
      enabled: doubleBackToExit,
      snackBarMessage: "Presionar de nuevo para salir",
      child: WillPopCustom(
        enabled: !doubleBackToExit,
        onWillPop: () {
          if (onPop != null) {
            onPop!();
          } else if (goHomeOnBack) {
            context.goNamed("home");
          } else if (context.canPop()) {
            context.pop();
          } else {
            return true;
          }

          return false;
        },
        child: Scaffold(
          drawer: drawer,
          appBar: appBar,
          body: _BackgroundStyled(
            padding: padding,
            color: color,
            gradient: gradient,
            decorationImage: decorationImage,
            paintedScaffold: paintedScaffold,
            scrollable: scrollable,
            backgroundStack: backgroundStack,
            foregroundStack: foregroundStack,
            child: body,
          ),
          bottomSheet: bottomWidget,
          floatingActionButton: floatingActionButton,
        ),
      ),
    );
  }
}
