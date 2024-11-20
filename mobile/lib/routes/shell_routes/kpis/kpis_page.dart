import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sap_avicola/models/register_option_model.dart';
import 'package:sap_avicola/utils/general/variables.dart';
import 'package:sap_avicola/widgets/defaults/app_bar.dart';
import 'package:sap_avicola/widgets/defaults/scaffold.dart';
import 'package:sap_avicola/widgets/sheets/card_widget.dart';

class KpisPage extends StatelessWidget {
  const KpisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      goHomeOnBack: true,
      padding: const EdgeInsets.all(0),
      appBar: CustomAppBar(
        titleText: "KPIs - Indicadores",
        subTitleText: "Selecciona",
        onPop: () => context.goNamed("home"),
      ),
      body: ListView.separated(
        padding: Vars.paddingScaffold,
        itemCount: RegisterSectionOption.values.length,
        separatorBuilder: (context, index) => Gap(18.sp).column,
        itemBuilder: (context, index) {
          final section = RegisterSectionOption.values[index];

          return CardWidgetV2(
            onTap: () => RegisterOption.onTapItemKpis(section: section),
            padding: const EdgeInsets.only(
              top: Vars.gapNormal,
              bottom: Vars.gapNormal,
              left: Vars.gapNormal,
              right: Vars.gapXLarge,
            ),
            border: Border(
                left: BorderSide(
              width: 13.sp,
              color: section.color,
            )),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    section.title,
                    style: theme.textTheme.bodyLarge?.copyWith(fontSize: 14),
                  ),
                  const Icon(Icons.chevron_right),
                ]),
          );
        },
      ),
    );
  }
}
