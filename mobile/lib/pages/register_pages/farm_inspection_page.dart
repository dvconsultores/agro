import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sap_avicola/models/equipos_model.dart';
import 'package:sap_avicola/models/galpon_model.dart';
import 'package:sap_avicola/models/granja_model.dart';
import 'package:sap_avicola/models/register_option_model.dart';
import 'package:sap_avicola/pages/register_pages/operation_state_page.dart';
import 'package:sap_avicola/repositories/api_lider_pollo.dart';
import 'package:sap_avicola/utils/config/router_config.dart';
import 'package:sap_avicola/utils/config/theme.dart';
import 'package:sap_avicola/utils/extensions/type_extensions.dart';
import 'package:sap_avicola/utils/general/context_utility.dart';
import 'package:sap_avicola/utils/general/variables.dart';
import 'package:sap_avicola/utils/helper_widgets/validator_field.dart';
import 'package:sap_avicola/utils/mixins/general_mixins.dart';
import 'package:sap_avicola/widgets/defaults/app_bar.dart';
import 'package:sap_avicola/widgets/defaults/button.dart';
import 'package:sap_avicola/widgets/defaults/scaffold.dart';
import 'package:sap_avicola/widgets/dialogs/modal_widget.dart';
import 'package:sap_avicola/widgets/form_fields/bottom_select_field.dart';
import 'package:sap_avicola/widgets/form_fields/input_field.dart';
import 'package:sap_avicola/widgets/loaders/loader.dart';
import 'package:sap_avicola/widgets/sheets/card_widget.dart';

class FarmInspectionPage extends StatefulWidget {
  const FarmInspectionPage({super.key, required this.section});
  final RegisterSectionOption section;

  @override
  State<FarmInspectionPage> createState() => _FarmInspectionPageState();
}

class _FarmInspectionPageState extends State<FarmInspectionPage>
    with ThemesMixin {
  late final loader = AppLoader();
  final apiLiderPollo = ApiLiderPollo();
  final formKey = GlobalKey<FormState>();

  final selectedGranjaControllers = ValueNotifier<int?>(null);

  List<TextEditingController> capacidadControllers = [];
  List<TextEditingController> cantidadAvesControllers = [];
  List<ValueNotifier<int?>> selectedGalponControllers = [];

  final condicionCama = TextEditingController();
  final temperaturaGranja = TextEditingController();
  final humedadGranja = TextEditingController();

  List<TextEditingController> cantidadControllers = [];
  List<ValueNotifier<int?>> selectedEquipoControllers = [];

  //List<GranjaModel> ;
  var farms = <GranjaModel>[],
      sheds = <GalponModel>[],
      devices = <EquiposModel>[];

  final availableSheds = TextEditingController(),
      devicesAmount = TextEditingController();

  Future<void> getData() async {
    loader.init();

    await Future.wait([getGranjas()]);

    if (mounted) loader.close();
  }

  Future<void> getGranjas() async {
    final granjas = await apiLiderPollo.getGranjas();

    setState(() {
      farms = granjas;
    });
  }

  Future<void> getDataGranja(granjaId) async {
    try {
      loader.init();

      availableSheds.text = "";
      devicesAmount.text = "";
      selectedGalponControllers = [];
      capacidadControllers = [];
      cantidadAvesControllers = [];
      selectedEquipoControllers = [];
      cantidadControllers = [];

      if (granjaId == null) {
        loader.close();
        return;
      }
      final galpones = await apiLiderPollo.getGalpones(granjaId);
      final equipos = await apiLiderPollo.getEquipos(granjaId);

      loader.close();

      setState(() {
        sheds = galpones;
        devices = equipos;
      });
    } catch (e) {
      loader.close();
    }
  }

  void changeAvailableSheds(String value) {
    final cant = value.isEmpty ? 0 : int.parse(value);
    int shedCount = cant;

    capacidadControllers =
        List.generate(shedCount, (index) => TextEditingController());
    cantidadAvesControllers =
        List.generate(shedCount, (index) => TextEditingController());
    selectedGalponControllers =
        List.generate(shedCount, (index) => ValueNotifier<int?>(null));

    EasyDebounce.debounce(
      "animate",
      Durations.medium4,
      () => setState(() {}),
    );
    // setState(() {});
  }

  void changeCantDevices(String value) {
    final cant = value.isEmpty ? 0 : int.parse(value);
    int devicesCount = cant;

    cantidadControllers =
        List.generate(devicesCount, (index) => TextEditingController());
    selectedEquipoControllers =
        List.generate(devicesCount, (index) => ValueNotifier<int?>(null));

    EasyDebounce.debounce(
      "animate",
      Durations.medium4,
      () => setState(() {}),
    );
  }

  Future<void> setInspeccionGranja() async {
    final galponInspecciones = List.generate(
      selectedGalponControllers.length,
      (index) => {
        'galpon_id': selectedGalponControllers[index].value,
        'cantidad_aves': int.tryParse(cantidadAvesControllers[index].text) ?? 0,
        'capacidad': int.tryParse(capacidadControllers[index].text) ?? 0,
      },
    );

    final equipoInspecciones = List.generate(
      selectedEquipoControllers.length,
      (index) => {
        'equipo_id': selectedEquipoControllers[index].value,
        'cantidad': int.tryParse(cantidadControllers[index].text) ?? 0,
      },
    );

    String etapa;
    switch (widget.section) {
      case RegisterSectionOption.breedingPhase:
        etapa = "CRIA";
        break;
      case RegisterSectionOption.reproductiveProductionPhase:
        etapa = "PRODUCCION";
        break;
      case RegisterSectionOption.reproductiveFatteningPhase:
        etapa = "ENGORDE";
        break;
      case RegisterSectionOption():
        throw "Error al guardar, etapa incorrecta";
    }

    final datafinal = {
      'granja_id': selectedGranjaControllers.value,
      'galpones_disponibles': int.tryParse(availableSheds.text) ?? 0,
      'temperatura': double.tryParse(temperaturaGranja.text) ?? 0.0,
      'humedad': double.tryParse(humedadGranja.text) ?? 0.0,
      'condicion_cama': condicionCama.text,
      'galpon_inspecciones': galponInspecciones,
      'equipo_inspecciones': equipoInspecciones,
      'etapa': etapa,
    };

    await apiLiderPollo.setInspeccionGranja(datafinal);
  }

  Future<void> inspectHandler() async {
    if (!formKey.currentState!.validate()) return;

    final accepts = await Modal.showAlertToContinue(
      context,
      icon: Icon(RegisterOption.farmInspection.icon, size: 25),
      titleText: "¿Deseas confirmar la inspección?",
      textCancelBtn: "No, cancelar",
      textConfirmBtn: "Si, confirmar",
    );

    if (accepts != true || !context.mounted) return;

    try {
      loader.init();

      setInspeccionGranja();

      if (!mounted) return;
      loader.close();

      Nav.pushReplacement(context,
          hideBottomNavigationBar: true,
          page: OperationStatePage(
            operationState: OperationStateType.success,
            titleText: "¡Inspección exitosa!",
            descText: "La inspección ha sido confirmada con éxito",
            actions: (context) => [
              Button(
                text: "Agregar otro registro",
                textExpanded: true,
                leading: const Icon(Icons.add_rounded),
                color: colors.primaryDarken,
                bgColor: Colors.white,
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);

                  Nav.push(ContextUtility.context!,
                      page: FarmInspectionPage(section: widget.section));
                },
              ),
              Button.textVariant(
                text: "Ir al registro de datos",
                color: Colors.white,
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
              ),
            ],
          ));
    } catch (e) {
      if (!mounted) return;
      loader.close();
      // ignore: use_build_context_synchronously
      Modal.showSystemAlert(context,
          icon:
              Icon(Icons.error_outline, color: ThemeApp.colors(context).error),
          titleText: "Error al sincronizar",
          contentText: e.toString());
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
    return AppScaffold(
      appBar: CustomAppBar(
        titleText: widget.section.title,
        subTitleText: RegisterOption.farmInspection.title,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: Vars.gapLow),
          child: Column(children: [
            BottomSelectField(
              controller: selectedGranjaControllers,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Granja",
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
              onChanged: (value) {
                // Maneja la selección aquí
                getDataGranja(value);
              },
              dropdownMaxChildSize: .7,
              dropdownInitialChildSize: .7,
              dropdownTitleText: "Granjas",
              dropdownSearchLabelText: "Granja",
              dropdownSearchHintText: "Buscar Granja",
              dropdownSearchFunction: (index, dynamic item, search) =>
                  farms[index]
                      .name
                      .toLowerCase()
                      .contains(search.toLowerCase()),
            ),
            Gap(16.sp).column,
            InputField(
                controller: availableSheds,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => ValidatorField.evaluate(
                    value, (instance) => [instance.required]),
                labelText: "Nº de Galpones disponibles",
                hintText: "Indique cantidad de galpones",
                keyboardType:
                    const TextInputType.numberWithOptions(signed: true),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) => {
                      changeAvailableSheds(value),
                    }),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: availableSheds.text.isNotEmpty
                  ? EdgeInsets.only(top: 10.sp, bottom: 4.sp)
                  : null,
              itemCount: availableSheds.text.toInt(),
              separatorBuilder: (context, index) =>
                  const Gap(Vars.gapLarge).column,
              itemBuilder: (context, index) => _ShedFields(
                items: sheds,
                capacidadController: capacidadControllers[index],
                cantidadAvesController: cantidadAvesControllers[index],
                selectedGalponController: selectedGalponControllers[index],
              ),
            ),
            Gap(16.sp).column,
            InputField(
              controller: condicionCama,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Condición Cama Concha de Arroz",
              hintText: "Describa la condicion de la cama",
            ),
            Gap(16.sp).column,
            InputField(
                controller: devicesAmount,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => ValidatorField.evaluate(
                    value, (instance) => [instance.required]),
                labelText: "Cantidad de equipos",
                hintText: "Indique cantidad de equipos",
                keyboardType:
                    const TextInputType.numberWithOptions(signed: true),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) => {changeCantDevices(value)}),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: devicesAmount.text.isNotEmpty
                  ? EdgeInsets.only(top: 10.sp, bottom: 4.sp)
                  : null,
              itemCount: devicesAmount.text.toInt(),
              separatorBuilder: (context, index) =>
                  const Gap(Vars.gapLarge).column,
              itemBuilder: (context, index) => _DeviceFields(
                items: devices,
                cantidadController: cantidadControllers[index],
                selectedEquipoController: selectedEquipoControllers[index],
              ),
            ),
            Gap(16.sp).column,
            InputField(
              controller: temperaturaGranja,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Temperatura de la Granja",
              hintText: "indique el valor de la temperatura",
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            Gap(16.sp).column,
            InputField(
              controller: humedadGranja,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Humedad de la Granja",
              hintText: "Indique el valor de la humedad",
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const Gap(Vars.gapMax * 3).column,
          ]),
        ),
      ),
      bottomWidget: Button(
        margin: Vars.paddingScaffold,
        text: "Confirmar Inspección",
        onPressed: inspectHandler,
      ),
    );
  }
}

class _ShedFields extends StatelessWidget {
  const _ShedFields({
    required this.items,
    required this.capacidadController,
    required this.cantidadAvesController,
    required this.selectedGalponController,
  });

  final List<GalponModel> items;
  final TextEditingController capacidadController;
  final TextEditingController cantidadAvesController;
  final ValueNotifier<int?> selectedGalponController;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
        color: const Color(0xFFFBFBFB),
        border: Border.all(color: Theme.of(context).dividerTheme.color!),
        boxShadow: const [],
        child: Column(children: [
          Row(children: [
            Expanded(
              flex: 2,
              child: BottomSelectField(
                controller: selectedGalponController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => ValidatorField.evaluate(
                    value, (instance) => [instance.required]),
                labelText: "Galpón",
                hintText: "Seleccionar Galpón",
                items: items
                    .map((item) => DropdownMenuItem(
                          value: item.id,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(item.galpon),
                          ),
                        ))
                    .toList(),
                dropdownMaxChildSize: .7,
                dropdownInitialChildSize: .7,
                dropdownTitleText: "Galpón",
                dropdownSearchLabelText: "Galpón",
                dropdownSearchHintText: "Seleccionar Galpón",
                dropdownSearchFunction: (index, item, search) => items[index]
                    .galpon
                    .toLowerCase()
                    .contains(search.toLowerCase()),
                /*onChanged: (value) {
                  selectedGalponController.value = value;
                },*/
              ),
            ),
            Gap(8.sp).row,
            Expanded(
              child: InputField(
                controller: capacidadController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => ValidatorField.evaluate(
                    value, (instance) => [instance.required]),
                labelText: "Capacidad",
                hintText: "",
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ]),
          Gap(16.sp).column,
          InputField(
            controller: cantidadAvesController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => ValidatorField.evaluate(
                value, (instance) => [instance.required]),
            labelText: "Cantidad de Aves alojadas",
            hintText: "",
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ]));
  }
}

class _DeviceFields extends StatelessWidget {
  const _DeviceFields({
    required this.items,
    required this.cantidadController,
    required this.selectedEquipoController,
  });
  final List<EquiposModel> items;
  final TextEditingController cantidadController;
  final ValueNotifier<int?> selectedEquipoController;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
        color: const Color(0xFFFBFBFB),
        border: Border.all(color: Theme.of(context).dividerTheme.color!),
        boxShadow: const [],
        child: Column(children: [
          Row(children: [
            Expanded(
              flex: 2,
              child: BottomSelectField(
                controller: selectedEquipoController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => ValidatorField.evaluate(
                    value, (instance) => [instance.required]),
                labelText: "Equipo",
                hintText: "Seleccionar Equipo",
                items: items
                    .map((item) => DropdownMenuItem(
                          value: item.id,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(item.nombre),
                          ),
                        ))
                    .toList(),
                dropdownMaxChildSize: .7,
                dropdownInitialChildSize: .7,
                dropdownTitleText: "Equipo",
                dropdownSearchLabelText: "Equipo",
                dropdownSearchHintText: "Buscar Equipo",
                dropdownSearchFunction: (index, item, search) => items[index]
                    .nombre
                    .toLowerCase()
                    .contains(search.toLowerCase()),
              ),
            ),
            Gap(8.sp).row,
            Expanded(
              child: InputField(
                controller: cantidadController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => ValidatorField.evaluate(
                    value, (instance) => [instance.required]),
                labelText: "Cantidad",
                hintText: "",
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ]),
        ]));
  }
}
