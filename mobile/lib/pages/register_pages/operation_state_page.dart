import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sap_avicola/painters/circle_painter.dart';
import 'package:sap_avicola/utils/config/theme.dart';
import 'package:sap_avicola/utils/extensions/type_extensions.dart';
import 'package:sap_avicola/utils/general/variables.dart';
import 'package:sap_avicola/widgets/circle_light__blurred_widget.dart';
import 'package:sap_avicola/widgets/defaults/scaffold.dart';

enum OperationStateType {
  success,
  cancel;
}

class OperationStatePage extends StatefulWidget {
  const OperationStatePage({
    super.key,
    required this.operationState,
    this.icon,
    this.title,
    this.titleText,
    this.titleStyle,
    this.desc,
    this.descText,
    this.descStyle,
    this.actions,
    this.actionsDirection = Axis.vertical,
    this.onPop,
  });
  final OperationStateType operationState;
  final Widget? icon;
  final Widget? title;
  final String? titleText;
  final TextStyle? titleStyle;
  final Widget? desc;
  final String? descText;
  final TextStyle? descStyle;
  final List<Widget> Function(BuildContext context)? actions;
  final Axis actionsDirection;
  final VoidCallback? onPop;

  @override
  State<OperationStatePage> createState() => _OperationStatePageState();
}

class _OperationStatePageState extends State<OperationStatePage>
    with TickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Durations.long4,
      lowerBound: 0,
      upperBound: 1,
    )
      ..drive(CurveTween(curve: Curves.elasticInOut))
      ..forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ThemeApp.colors(context), theme = Theme.of(context);

    Map<String, dynamic> defaultValues = switch (widget.operationState) {
      OperationStateType.success => {
          "icon": SvgPicture.asset("assets/operation_state/check_circle.svg"),
          "title": "¡Guardado con éxito!",
          "desc": "El registro fue guardado con éxito",
          "color": colors.warning,
        },
      OperationStateType.cancel => {
          "icon": SvgPicture.asset("assets/operation_state/cancel.svg"),
          "title": "¡Falló el guardado!",
          "desc": "El registro no se pudo guardar correctamente",
          "color": colors.error,
        },
    };

    final iconWidget = widget.icon ?? defaultValues['icon'] as Widget,
        titleWidget = widget.title ??
            Text(
              widget.titleText ?? defaultValues['title'] as String,
              style: widget.titleStyle ??
                  TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: defaultValues['color'],
                  ),
            ),
        descWidget = widget.desc ??
            Text(
              widget.descText ?? defaultValues['desc'] as String,
              style: widget.descStyle ?? const TextStyle(fontSize: 14),
            ),
        renderActions =
            widget.actions != null ? widget.actions!(context) : null;

    return Theme(
      data: theme.copyWith(
        textTheme: theme.textTheme.copyWith(
          bodyMedium: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
      ),
      child: AppScaffold(
        onPop: widget.onPop,
        paintedScaffold: false,
        color: const Color(0xFF000042),
        // decorators
        backgroundStack: [
          const Positioned(
              top: -20,
              left: -30,
              width: 211,
              height: 211,
              child: CircleLightBlurredWidget(blur: 110)),
          Positioned(
              top: -20,
              right: -30,
              width: 211,
              height: 211,
              child: CircleLightBlurredWidget(
                blur: 110,
                color: colors.warning.withOpacity(.66),
              ))
        ],

        // body
        body: Column(children: [
          const Gap(Vars.gapMax * 2.3).column,
          AnimatedBuilder(
            animation: animationController,
            child: iconWidget,
            builder: (context, child) {
              const maxSize = 184.09, minSize = 97;

              final topCircle =
                      Tween<double>(begin: minSize / 2, end: maxSize / 2)
                          .animate(animationController),
                  middleCircle = Tween<double>(begin: minSize / 2, end: 149 / 2)
                      .animate(animationController);

              final angle =
                  Tween<double>(begin: -2, end: 0).animate(animationController);

              return SizedBox(
                width: maxSize,
                height: maxSize,
                child: Stack(alignment: Alignment.center, children: [
                  Positioned(
                    child: CustomPaint(
                      painter: CirclePainter(size: topCircle.value),
                    ),
                  ),
                  Positioned(
                    child: CustomPaint(
                      painter: CirclePainter(size: middleCircle.value),
                    ),
                  ),
                  const Positioned(
                    child: CustomPaint(
                      painter: CirclePainter(size: 97 / 2),
                    ),
                  ),
                  if (widget.operationState == OperationStateType.success)
                    Positioned(
                      child: Opacity(
                        opacity: animationController.value,
                        child: SvgPicture.asset(
                            "assets/operation_state/shiny_stars.svg"),
                      ),
                    ),
                  Transform.translate(
                      offset: Offset(
                        -40 * animationController.value.clampInverted(0, 1),
                        -60 * animationController.value.clampInverted(0, 1),
                      ),
                      child: Transform.scale(
                          scale: animationController.value,
                          child: Transform.rotate(
                            angle: angle.value,
                            child: child!,
                          ))),
                ]),
              );
            },
          ),
          const Gap(Vars.gapXLarge).column,
          titleWidget,
          const Gap(Vars.gapXLarge).column,
          descWidget,
        ]),
        bottomWidget: renderActions != null
            ? Padding(
                padding: Vars.paddingScaffold
                    .add(const EdgeInsets.only(bottom: Vars.gapXLarge)),
                child: switch (widget.actionsDirection) {
                  Axis.horizontal =>
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      for (var i = 0; i < renderActions.length; i++) ...[
                        renderActions[i],
                        if (i != renderActions.length - 1)
                          const Gap(Vars.gapXLarge).row,
                      ],
                    ]),
                  Axis.vertical =>
                    Column(mainAxisSize: MainAxisSize.min, children: [
                      for (var i = 0; i < renderActions.length; i++) ...[
                        renderActions[i],
                        if (i != renderActions.length - 1)
                          const Gap(Vars.gapXLarge).column,
                      ],
                    ]),
                },
              )
            : null,
      ),
    );
  }
}
