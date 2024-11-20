import 'package:flex_list/flex_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:sap_avicola/models/kpis_statistics_model.dart';
import 'package:sap_avicola/models/register_option_model.dart';
import 'package:sap_avicola/models/semana_model.dart';
import 'package:sap_avicola/repositories/api_lider_pollo.dart';
import 'package:sap_avicola/utils/general/variables.dart';
import 'package:sap_avicola/utils/mixins/general_mixins.dart';
import 'package:sap_avicola/widgets/defaults/app_bar.dart';
import 'package:sap_avicola/widgets/defaults/scaffold.dart';
import 'package:sap_avicola/widgets/form_fields/bottom_select_field.dart';
import 'package:sap_avicola/widgets/loaders/loader.dart';
import 'package:sap_avicola/widgets/sheets/card_widget.dart';
import 'package:sap_avicola/widgets/simple_pie_graph.dart';

class KpisIncubatorPhasePage extends StatefulWidget {
  const KpisIncubatorPhasePage({super.key});

  @override
  State<KpisIncubatorPhasePage> createState() =>
      _KpieProductionPhasePageState();
}

class _KpieProductionPhasePageState extends State<KpisIncubatorPhasePage>
    with ThemesMixin {
  final week = ValueNotifier<String?>(null);

  late final loader = AppLoader();
  final apiLiderPollo = ApiLiderPollo();

  final selectedSemanasController = ValueNotifier<int?>(null);

  var weeks = <SemanaModel>[], statatistics = <KpisStatisticModel>[];

  Future<void> getData() async {
    try {
      loader.init();
      await Future.wait([getSemanas()]);
      loader.close();
    } catch (e) {
      loader.close();
    }
  }

  Future<void> getSemanas() async {
    final semanas = await apiLiderPollo.getSemanasIncubadora();

    setState(() {
      weeks = semanas;
    });
  }

  Future<void> getKpisIncubadora(int? semanaNum) async {
    if (selectedSemanasController.value == null) return;
    if (semanaNum == null) return;

    setState(() {
      statatistics = [];
    });

    loader.init();

    try {
      final kpis = await apiLiderPollo.getKpisIncubadora(semanaNum);

      loader.close();

      setState(() {
        statatistics = kpis;
      });
    } catch (e) {
      loader.close();
    }
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      getData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*var statatistics = [
      KpisStatisticModel(
        name: "Tasa Eclosión",
        desc: "Bueno",
        percent: 80,
        color: colors.secondaryLighten,
      ),
      KpisStatisticModel(
        name: "Tasa Fecundidad",
        desc: "Regular",
        percent: 60,
        color: colors.tertiary,
      ),
      KpisStatisticModel(
        name: "Tasa Pollitos Sanos",
        desc: "Bueno",
        percent: 75,
        color: colors.accentVariant,
      ),
      KpisStatisticModel(
        name: "Índice Rotura de Huevos",
        desc: "Excelente",
        percent: 100,
        color: colors.tertiaryDarken,
      ),
      KpisStatisticModel(
        name: "Peso Promedio Pollitos",
        desc: "98 gr",
        percent: 100,
        color: colors.tertiaryDarken,
      ),
      KpisStatisticModel(
        name: "Tasa Mortalidad en Incubadora",
        desc: "Excelente",
        percent: 2.6,
        color: colors.tertiaryDarken,
      ),
    ];*/

    return AppScaffold(
      scrollable: true,
      appBar: CustomAppBar(
        titleText: RegisterSectionOption.incubator.title,
        subTitleText: "Indicadores",
      ),
      body: Column(children: [
        const Gap(Vars.gapLow).column,
        BottomSelectField(
          controller: selectedSemanasController,
          labelText: "Semanas",
          hintText: "Seleccionar Semana",
          items: weeks
              .map((item) => DropdownMenuItem(
                    value: item.weekNumber,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(item.weekDes),
                    ),
                  ))
              .toList(),
          dropdownMaxChildSize: .7,
          dropdownInitialChildSize: .7,
          dropdownTitleText: "Semanas",
          dropdownSearchLabelText: "Semanas",
          dropdownSearchHintText: "Buscar Semana",
          dropdownSearchFunction: (index, item, search) =>
              weeks[index].weekDes.toUpperCase().contains(search.toUpperCase()),
          onChanged: (value) => setState(() {
            getKpisIncubadora(value);
          }),
        ),
        if (statatistics.isNotEmpty) ...[
          const Gap(Vars.gapXLarge).column,
          const Divider(),
          const Gap(Vars.gapXLarge).column,
          FlexList(
              horizontalSpacing: Vars.gapLarge,
              verticalSpacing: Vars.gapLarge,
              children: statatistics
                  .map((e) => CardWidget(
                      width: 175,
                      height: 90,
                      child: Row(children: [
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  e.name,
                                  maxLines: 2,
                                  style: theme.textTheme.bodyLarge,
                                ),
                                const Gap(Vars.gapLow).column,
                                Text(
                                  e.desc,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ]),
                        ),
                        const Gap(Vars.gapXLarge).row,
                        if (e.percent != null)
                          SimplePieGraph(
                            value: e.percent!,
                            size: 96,
                            sizeFactor: 0.2,
                            color: e.color,
                          )
                      ])))
                  .toList()),
        ],
        const Gap(Vars.gapMax * 3).column,
      ]),
    );
  }
}
