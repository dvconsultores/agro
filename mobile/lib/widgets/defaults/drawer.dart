import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sap_avicola/widgets/defaults/button.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // * Go to router page or normal push
    void goToRouterPage(dynamic page) {
      Navigator.pop(context);

      if (page is String) return context.goNamed(page);

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => page),
      );
    }

    final items = <String, dynamic>{};

    return Drawer(
        child: Column(
      children: [
        for (final element in items.entries) ...[
          Button(
            text: element.key,
            onPressed: () => goToRouterPage(element.value),
          ),
        ],
      ],
    ));
  }
}
