import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sap_avicola/utils/config/router_config.dart';
import 'package:sap_avicola/utils/helper_widgets/sap_icon_data.dart';
import 'package:sap_avicola/widgets/defaults/bottom_navigation_bar.dart';
import 'package:sap_avicola/widgets/dialogs/modal_widget.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation(
    this.state,
    this.child, {
    super.key,
    this.swipeNavigate = false,
  });
  final GoRouterState state;
  final Widget child;
  final bool swipeNavigate;

  @override
  Widget build(BuildContext context) {
    if (router.indexShellRoute == -1) {
      return const Scaffold(body: SizedBox.shrink());
    }

    final items = {
      "home": const MapEntry("Home", SapIconData(0xe070)),
      "register": const MapEntry("Registro", SapIconData(0xe118)),
      "kpis": const MapEntry("KPIs", SapIconData(0xe120)),
      "config": const MapEntry("Config", SapIconData(0xe0a6)),
    };

    Future<void> logoutHandler() async {
      final accept = await Modal.showAlertToContinue(
        context,
        titleText: "¿Deseas cerrar sesión?",
        textCancelBtn: "No, cancelar",
        textConfirmBtn: "Si, cerrar sesión",
      );
      if (accept != true || !context.mounted) return;

      context.goNamed("login");
    }

    return Scaffold(
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: router.indexShellRoute,
        onTap: (index) => switch (index) {
          4 => logoutHandler(),
          int() => context.goNamed(items.entries.elementAt(index).key),
        },
        items: router.shellRoutes
            .map((element) => items[(element as GoRoute).name]!)
            .toList()
          ..add(const MapEntry("Salir", SapIconData(0xe005))),
      ),

      //? Render pages
      body: GestureDetector(
        onHorizontalDragUpdate: swipeNavigate
            ? (details) {
                // Note: Sensitivity is integer used when you don't want to mess up vertical drag
                int sensitivity = 8;

                // Right Swipe
                if (details.delta.dx > sensitivity) {
                  final index = router.indexShellRoute == 0
                      ? 0
                      : router.indexShellRoute - 1;
                  final previousRoute =
                      router.shellRoutes.elementAtOrNull(index) as GoRoute?;

                  if (previousRoute != null) router.go((previousRoute).path);

                  // Left Swipe
                } else if (details.delta.dx < -sensitivity) {
                  final nextRoute = router.shellRoutes
                      .elementAtOrNull(router.indexShellRoute + 1) as GoRoute?;

                  if (nextRoute != null) router.go((nextRoute).path);
                }
              }
            : null,
        child: child,
      ),
    );
  }
}
