import 'package:flutter/material.dart';
import 'package:responsive_mixin_layout/responsive_mixin_layout.dart';
import 'package:sap_avicola/models/rol_user_model.dart';
import 'package:sap_avicola/pages/kpis_pages/kpis_breeding_phase_page.dart';
import 'package:sap_avicola/pages/kpis_pages/kpis_fattening_page.dart';
import 'package:sap_avicola/pages/kpis_pages/kpis_incubator_page.dart';
import 'package:sap_avicola/pages/kpis_pages/kpis_production_phase_page.dart';
import 'package:sap_avicola/pages/register_pages/baby_chicks_exit_page.dart';
import 'package:sap_avicola/pages/register_pages/bird_mortality_page.dart';
import 'package:sap_avicola/pages/register_pages/birds_exit_page.dart';
import 'package:sap_avicola/pages/register_pages/birth_certificate_page.dart';
import 'package:sap_avicola/pages/register_pages/breed_birds_distribution_page.dart';
import 'package:sap_avicola/pages/register_pages/classify_breeding_eggs_page.dart';
import 'package:sap_avicola/pages/register_pages/eggs_collection_page.dart';
import 'package:sap_avicola/pages/register_pages/eggs_exit_page.dart';
import 'package:sap_avicola/pages/register_pages/eggs_reception_page.dart';
import 'package:sap_avicola/pages/register_pages/farm_inspection_page.dart';
import 'package:sap_avicola/pages/register_pages/fattening_birds_distribution_page.dart';
import 'package:sap_avicola/pages/register_pages/food_registration_page.dart';
import 'package:sap_avicola/pages/register_pages/incubator_inspection_page.dart';
import 'package:sap_avicola/pages/register_pages/incubator_page.dart';
import 'package:sap_avicola/pages/register_pages/production_birds_distribution_page.dart';
import 'package:sap_avicola/pages/register_pages/transport_inspection_eggs_page.dart';
import 'package:sap_avicola/pages/register_pages/transport_inspection_page.dart';
import 'package:sap_avicola/pages/register_pages/vaccinations_placed_page.dart';
import 'package:sap_avicola/pages/register_pages/weighing_birds_page.dart';
import 'package:sap_avicola/utils/config/router_config.dart';
import 'package:sap_avicola/utils/general/context_utility.dart';
import 'package:sap_avicola/utils/helper_widgets/sap_icon_data.dart';
import 'package:sap_avicola/widgets/item_list_widget.dart';
import 'package:sap_avicola/widgets/sheets/bottom_sheet_card.dart';

enum RegisterSectionOption {
  breedingPhase(
    title: "Reproductora Etapa Cría",
    color: Color(0xffa68a5b),
    options: [
      RegisterOption.farmInspection,
      RegisterOption.birdsDistribution,
      RegisterOption.breedingProcess,
      RegisterOption.birdExit,
      RegisterOption.transportInspection,
    ],
  ),
  reproductiveProductionPhase(
    title: "Reproductora Etapa Producción",
    color: Color(0xffc87b00),
    options: [
      RegisterOption.farmInspection,
      RegisterOption.birdsDistribution,
      RegisterOption.productionProcess,
      RegisterOption.birdExit,
      RegisterOption.transportInspection,
      RegisterOption.eggsExit,
      RegisterOption.transportInspectionEgg
    ],
  ),
  incubator(
    title: "Incubadora",
    color: Color(0xffda6c6c),
    options: [
      RegisterOption.eggsReception,
      RegisterOption.sortEggs,
      RegisterOption.incubatorInspect,
      RegisterOption.incubator,
      RegisterOption.birthCertificate,
      RegisterOption.babyChicksExit
    ],
  ),
  reproductiveFatteningPhase(
    title: "Reproductora Fase Engorde",
    color: Color(0xff3278be),
    options: [
      RegisterOption.farmInspection,
      RegisterOption.birdsDistribution,
      RegisterOption.fatteningProcess,
      RegisterOption.birdExit,
      RegisterOption.transportInspection,
    ],
  );

  const RegisterSectionOption({
    required this.title,
    required this.color,
    required this.options,
  });
  final String title;
  final Color color;
  final List<RegisterOption> options;
}

enum RegisterOption {
  eggsReception(
    icon: Icons.egg_outlined,
    title: "Recepción de Huevos",
    children: [],
  ),
  sortEggs(
    icon: "assets/icons/eggs.png",
    title: "Clasificar Huevos",
    children: [],
  ),
  incubatorInspect(
    icon: "assets/icons/incubator.png",
    title: "Inspección de Incubadoras",
    children: [],
  ),
  incubator(
    icon: "assets/icons/incubator_egg.png",
    title: "Incubación",
    children: [],
  ),
  birthCertificate(
    icon: "assets/icons/edit_square.png",
    title: "Registro de Nacimiento",
    children: [],
  ),
  babyChicksExit(
    icon: "assets/icons/baby_chick.png",
    title: "Salida de Pollitos BB",
    children: [],
  ),
  farmInspection(
    icon: Icons.house_siding_rounded,
    title: "Inspección de Granjas",
    children: [],
  ),
  birdsDistribution(
    icon: SapIconData(0xe0b3),
    title: "Distribución de Aves",
    children: [],
  ),
  breedingProcess(
    icon: SapIconData(0xe138),
    title: "Proceso de Cría",
    children: [
      "Registro de Alimento",
      "Pesaje de Aves",
      "Mortalidad de Aves",
      "Vacunas Colocadas"
    ],
  ),
  productionProcess(
    icon: Icons.agriculture_outlined,
    title: "Proceso de Producción",
    children: [
      "Registro de Alimento",
      "Pesaje de Aves",
      "Mortalidad de Aves",
      "Vacunas Colocadas",
      "Recolección de Huevos"
    ],
  ),
  birdExit(
    icon: "assets/icons/hen.png",
    title: "Salida de Aves",
    children: [],
  ),
  eggsExit(
    icon: Icons.egg_outlined,
    title: "Salida de Huevos",
    children: [],
  ),
  transportInspection(
    icon: "assets/icons/pallet.png",
    title: "Inspección de Transporte",
    children: [],
  ),
  transportInspectionEgg(
    icon: "assets/icons/pallet.png",
    title: "Inspección Transporte de Huevos",
    children: [],
  ),
  fatteningProcess(
    icon: "assets/icons/atr.png",
    title: "Proceso de Engorde",
    children: [
      "Registro de Alimento",
      "Pesaje de Aves",
      "Mortalidad de Aves",
      "Vacunas Colocadas"
    ],
  );

  const RegisterOption({
    required this.title,
    required this.icon,
    required this.children,
  });
  final String title;
  final dynamic icon;
  final List<String> children;

  static void onTapItemRegister({
    required RegisterSectionOption section,
    required RegisterOption option,
    required List<RolUserProcessModel> processActive,
  }) {
    final context = ContextUtility.context!;

    return switch (option) {
      RegisterOption.farmInspection => Nav.push(
          context,
          page: FarmInspectionPage(section: section),
        ),
      RegisterOption.birdsDistribution => Nav.push(
          context,
          page: section == RegisterSectionOption.breedingPhase
              ? const BreedBirdsDistributionPage()
              : section == RegisterSectionOption.reproductiveProductionPhase
                  ? const ProductionBirdsDistributionPage()
                  : const FatteningBirdsDistributionPage(),
        ),
      RegisterOption.breedingProcess => _showModal(
          context,
          option: option,
          section: section,
          renderWidget: (index) => [
            FoodRegistrationPage(optionIndex: index, option: option),
            WeighingBirdsPage(optionIndex: index, option: option),
            BirdMortalityPage(optionIndex: index, option: option),
            VaccinationsPlacedPage(optionIndex: index, option: option),
          ][index],
          processActive: processActive,
        ),
      RegisterOption.productionProcess => _showModal(
          context,
          option: option,
          section: section,
          renderWidget: (index) => [
            FoodRegistrationPage(optionIndex: index, option: option),
            WeighingBirdsPage(optionIndex: index, option: option),
            BirdMortalityPage(optionIndex: index, option: option),
            VaccinationsPlacedPage(optionIndex: index, option: option),
            EggsCollecionPage(optionIndex: index),
          ][index],
          processActive: processActive,
        ),
      RegisterOption.birdExit => Nav.push(
          context,
          page: BirdsExitPage(section: section),
        ),
      RegisterOption.transportInspection => Nav.push(
          context,
          page: TransportInspectionPage(section: section),
        ),
      RegisterOption.eggsReception => Nav.push(
          context,
          page: const EggsReceptionPage(),
        ),
      RegisterOption.sortEggs => Nav.push(
          context,
          page: const ClassifyBreedingEggsPage(),
        ),
      RegisterOption.incubatorInspect => Nav.push(
          context,
          page: const IncubatorInspectionPage(),
        ),
      RegisterOption.incubator => Nav.push(
          context,
          page: const IncubatorPage(),
        ),
      RegisterOption.birthCertificate => Nav.push(
          context,
          page: const BirthCertificatePage(),
        ),
      RegisterOption.babyChicksExit => Nav.push(
          context,
          page: const BabyChicksExitPage(),
        ),
      RegisterOption.eggsExit => Nav.push(
          context,
          page: EggsExitPage(section: section),
        ),
      RegisterOption.transportInspectionEgg => Nav.push(
          context,
          page: const TransportInspectionEggsPage(),
        ),
      RegisterOption.fatteningProcess => _showModal(
          context,
          option: option,
          section: section,
          renderWidget: (index) => [
            FoodRegistrationPage(optionIndex: index, option: option),
            WeighingBirdsPage(optionIndex: index, option: option),
            BirdMortalityPage(optionIndex: index, option: option),
            VaccinationsPlacedPage(optionIndex: index, option: option),
          ][index],
          processActive: processActive,
        ),
    };
  }

  static void onTapItemKpis({required RegisterSectionOption section}) {
    final context = ContextUtility.context!;

    return switch (section) {
      RegisterSectionOption.breedingPhase => (() {
          Nav.push(context, page: const KpisBreedingPhasePage());
        })(),
      RegisterSectionOption.reproductiveProductionPhase => (() {
          Nav.push(context, page: const KpisProductionPhasePage());
        })(),
      RegisterSectionOption.incubator => (() {
          Nav.push(context, page: const KpisIncubatorPhasePage());
        })(),
      RegisterSectionOption.reproductiveFatteningPhase => (() {
          Nav.push(context, page: const KpisFatteningPage());
        })(),
    };
  }
}

void _showModal(
  BuildContext context, {
  required RegisterSectionOption section,
  required RegisterOption option,
  required Widget Function(int index) renderWidget,
  required List<RolUserProcessModel> processActive,
}) {
  final childSize = option.children.length < 3
      ? context.width.isXmobile
          ? .45
          : .35
      : context.width.isXmobile
          ? .65
          : .55;

  BottomSheetList.showModal(
    context,
    maxChildSize: childSize,
    initialChildSize: childSize,
    draggableFrameBgColor: section.color,
    titleText: option.title,
    items: processActive
        .map((item) => DropdownMenuItem(
              value: item.index,
              child: ItemList(name: item.title),
            ))
        .toList(),
    /*items: option.children
        .mapIndexed((i, e) => DropdownMenuItem(
              value: i,
              child: ItemList(name: e),
              ))
        .toList(),*/
    onTap: (item) {
      if (item.value == null) return;

      Nav.push(
        context,
        hideBottomNavigationBar: true,
        page: renderWidget(item.value!),
      );
    },
  );
}
