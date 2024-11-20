import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sap_avicola/utils/config/theme.dart';
import 'package:sap_avicola/utils/general/variables.dart';
import 'package:sap_avicola/widgets/circle_light__blurred_widget.dart';

class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({
    super.key,
    this.height,
    required this.currentIndex,
    required this.onTap,
    this.selectedItemColor,
    this.selectedIconColor,
    required this.items,
    this.paintedScaffold = true,
  });
  final double? height;
  final int currentIndex;
  final void Function(int index) onTap;
  final Color? selectedItemColor;
  final Color? selectedIconColor;
  final List<MapEntry<String, IconData>> items;
  final bool paintedScaffold;

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar>
    with TickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Durations.medium1)
          ..forward(from: 0);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context),
        theme = Theme.of(context),
        colors = ThemeApp.colors(context);

    final height = widget.height ?? 52.sp;

    return Stack(children: [
      if (widget.paintedScaffold)
        const Positioned(
          bottom: -140,
          left: -140,
          width: 211,
          height: 211,
          child: CircleLightBlurredWidget(),
        ),
      Container(
        width: media.size.width,
        height: height,
        margin: Vars.paddingScaffold.copyWith(
          top: Vars.gapMedium,
          bottom: Vars.gapMax,
        ),
        decoration: BoxDecoration(
          color: theme.bottomNavigationBarTheme.backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(Vars.radius8)),
          boxShadow: const [Vars.boxShadow4],
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: widget.items
                .mapIndexed((i, item) => IconButton(
                      onPressed: () {
                        animationController.forward(from: 0);
                        widget.onTap(i);
                      },
                      visualDensity: VisualDensity.comfortable,
                      highlightColor: Colors.transparent,
                      icon: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedBuilder(
                                  animation: animationController,
                                  child: Icon(
                                    item.value,
                                    size: 20.sp,
                                    color: widget.currentIndex == i
                                        ? colors.primary
                                        : colors.text,
                                  ),
                                  builder: (context, child) {
                                    final animation =
                                        Tween<double>(begin: 0, end: 1.1)
                                            .animate(animationController);

                                    return Stack(children: [
                                      Positioned.fill(
                                        child: Transform.scale(
                                          scale: animation.value,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: widget.currentIndex == i
                                                  ? colors.primary
                                                      .withOpacity(.3)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(Vars.radius4),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      child!,
                                    ]);
                                  }),
                              const Gap(Vars.gapXLow).column,
                              Text(
                                item.key,
                                style: TextStyle(
                                  color: widget.currentIndex == i
                                      ? colors.primary
                                      : colors.text,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ]),
                      ),
                    ))
                .toList()),
      ),
    ]);
  }
}
