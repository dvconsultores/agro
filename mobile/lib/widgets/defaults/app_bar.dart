import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:sap_avicola/utils/config/router_config.dart';
import 'package:sap_avicola/utils/config/theme.dart';
import 'package:sap_avicola/utils/extensions/type_extensions.dart';
import 'package:sap_avicola/utils/general/context_utility.dart';
import 'package:sap_avicola/utils/general/variables.dart';
import 'package:sap_avicola/widgets/circle_light__blurred_widget.dart';
import 'package:sap_avicola/widgets/defaults/tooltip.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    super.key,
    String? titleText,
    String? subTitleText,
    VoidCallback? onPop,
    bool paintedScaffold = true,
    super.centerTitle = true,
  }) : super(
          systemOverlayStyle: ThemeApp.systemUiOverlayStyle,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            iconSize: 28,
            onPressed: onPop ??
                () => router.canPop()
                    ? router.pop()
                    : Navigator.pop(ContextUtility.context!),
          ),
          flexibleSpace: paintedScaffold
              ? Stack(children: [
                  Positioned(
                    bottom: -140,
                    right: -140,
                    width: 211,
                    height: 211,
                    child: CircleLightBlurredWidget(
                      color: ThemeApp.colors(null).tertiary,
                    ),
                  ),
                ])
              : null,
          bottom: PreferredSize(
              preferredSize: const Size(0, 0),
              child: Transform.translate(
                offset: const Offset(0, -5),
                child: Container(
                    margin: Vars.paddingScaffold.copyWith(top: 0, bottom: 0),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: ThemeApp.colors(null).label)),
                    )),
              )),
          toolbarHeight: subTitleText.hasValue ? 66 : 56,
          titleSpacing: 0,
          title: Padding(
            padding: EdgeInsets.only(
              left: Vars.gapLow,
              right: Vars.paddingScaffold.right,
            ),
            child: Column(children: [
              if (titleText.hasValue)
                AppTooltip(
                  message: titleText!,
                  verticalOffset: 15,
                  child: Text(titleText),
                ),
              if (subTitleText.hasValue) ...[
                const Gap(Vars.gapXLow).column,
                Text(subTitleText!,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontFamily: FontFamily.noto("400"),
                    ))
              ],
            ]),
          ),
        );
}
