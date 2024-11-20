import 'package:flex_list/flex_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sap_avicola/models/granja_model.dart';
import 'package:sap_avicola/models/kpis_statistics_model.dart';
import 'package:sap_avicola/models/lote_model.dart';
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

class KpisFatteningPage extends StatefulWidget {
  const KpisFatteningPage({super.key});

  @override
  State<KpisFatteningPage> createState() => _KpieProductionPhasePageState();
}

class _KpieProductionPhasePageState extends State<KpisFatteningPage>
    with ThemesMixin {
  late final loader = AppLoader();
  final apiLiderPollo = ApiLiderPollo();

  final selectedGranjaController = ValueNotifier<int?>(null);
  final selectedLoteController = ValueNotifier<int?>(null);
  final selectedSemanasController = ValueNotifier<int?>(null);

  var farms = <GranjaModel>[],
      batch = <LoteModel>[],
      weeks = <SemanaModel>[],
      statatistics = <KpisStatisticModel>[];

  Future<void> getData() async {
    try {
      loader.init();
      await Future.wait([getGranjas()]);
      loader.close();
    } catch (e) {
      loader.close();
    }
  }

  Future<void> getGranjas() async {
    final granjas = await apiLiderPollo.getGranjas();

    setState(() {
      farms = granjas;
    });
  }

  Future<void> getLote(granjaId) async {
    if (granjaId == null) return;

    loader.init();
    try {
      selectedLoteController.value = null;
      selectedSemanasController.value = null;

      final lote = await apiLiderPollo.getLotesRecepcion(granjaId, "ENGORDE");

      loader.close();

      setState(() {
        batch = lote;
      });
    } catch (e) {
      loader.close();
    }
  }

  Future<void> getSemanas(recepcionId) async {
    if (selectedLoteController.value == null) return;
    loader.init();

    try {
      selectedSemanasController.value = null;

      if (recepcionId == null) {
        loader.close();
        return;
      }
      final semanas =
          await apiLiderPollo.getSemanasLote(recepcionId, "ENGORDE");

      loader.close();

      setState(() {
        weeks = semanas;
      });
    } catch (e) {
      loader.close();
    }
  }

  Future<void> getKpisLote(int? semanaNum) async {
    if (selectedLoteController.value == null) return;
    if (semanaNum == null) return;

    setState(() {
      statatistics = [];
    });

    loader.init();

    try {
      final kpis = await apiLiderPollo.getKpisLote(
          selectedLoteController.value, semanaNum, "ENGORDE");

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
        name: "ICA",
        desc: "Excelente",
        percent: 39,
        color: colors.primaryDarken,
      ),
      KpisStatisticModel(
        name: "GPD",
        desc: "1,2 kg",
        percent: 100,
        color: colors.tertiary,
      ),
      KpisStatisticModel(
        name: "Mortalidad",
        desc: "Excelente",
        percent: 2.6,
        color: colors.primaryDarken,
      ),
      KpisStatisticModel(
        name: "Tasa de Conversion alimentaria",
        desc: "Excelente",
        percent: 2.6,
        color: colors.primaryDarken,
      ),
    ];*/

    return AppScaffold(
      scrollable: true,
      appBar: CustomAppBar(
        titleText: "Pollo Engorde",
        subTitleText: "Indicadores",
      ),
      body: Column(children: [
        const Gap(Vars.gapLow).column,
        BottomSelectField(
          controller: selectedGranjaController,
          labelText: "Granjas",
          hintText: "Seleccionar Granja",
          items: farms
              .map((item) => DropdownMenuItem(
                    value: item.id,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(item.name),
                    ),
                  ))
              .toList(),
          dropdownMaxChildSize: .7,
          dropdownInitialChildSize: .7,
          dropdownTitleText: "Granjas",
          dropdownSearchLabelText: "Granjas",
          dropdownSearchHintText: "Buscar Granja",
          dropdownSearchFunction: (index, item, search) =>
              farms[index].name.toUpperCase().contains(search.toUpperCase()),
          onChanged: (value) => setState(() {
            getLote(value);
          }),
        ),
        Gap(16.sp).column,
        BottomSelectField(
          controller: selectedLoteController,
          labelText: "Lotes",
          hintText: "Seleccionar Lote",
          items: batch
              .map((item) => DropdownMenuItem(
                    value: item.id,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(item.lote),
                    ),
                  ))
              .toList(),
          dropdownMaxChildSize: .7,
          dropdownInitialChildSize: .7,
          dropdownTitleText: "Lotes",
          dropdownSearchLabelText: "Lotes",
          dropdownSearchHintText: "Buscar Lote",
          dropdownSearchFunction: (index, item, search) =>
              batch[index].lote.toUpperCase().contains(search.toUpperCase()),
          onChanged: (value) => setState(() {
            getSemanas(value);
          }),
        ),
        Gap(16.sp).column,
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
            getKpisLote(value);
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
