import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sap_avicola/models/granja_model.dart';
import 'package:sap_avicola/models/lote_salida_model.dart';
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
import 'package:sap_avicola/widgets/form_fields/date_picker_field.dart';
import 'package:sap_avicola/widgets/form_fields/input_field.dart';
import 'package:sap_avicola/widgets/form_fields/time_picker_field.dart';
import 'package:sap_avicola/widgets/loaders/loader.dart';

class TransportInspectionPage extends StatefulWidget {
  const TransportInspectionPage({super.key, required this.section});
  final RegisterSectionOption section;

  @override
  State<TransportInspectionPage> createState() =>
      _TransportInspectionPageState();
}

class _TransportInspectionPageState extends State<TransportInspectionPage>
    with ThemesMixin {
  late final loader = AppLoader();
  final apiLiderPollo = ApiLiderPollo();

  final formKey = GlobalKey<FormState>();

  final selectedGranjaController = ValueNotifier<int?>(null);
  final selectedLoteController = ValueNotifier<int?>(null);

  final cantidadAvesController = TextEditingController();
  final pesoPromedioController = TextEditingController();
  final condicionVehiculoController = TextEditingController();
  final cantidadJaulasController = TextEditingController();
  final fechaSalidaController = TextEditingController();
  final horaSalidaController = TextEditingController();

  var farms = <GranjaModel>[], batch = <LoteSalidaModel>[];

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
    try {
      setState(() {
        cantidadAvesController.text = "";
      });

      loader.init();
      selectedLoteController.value = null;

      if (granjaId == null) {
        loader.close();
        return;
      }
      List<LoteSalidaModel>? lote;

      switch (widget.section) {
        case RegisterSectionOption.breedingPhase:
          lote = await apiLiderPollo.getLotesSalida(granjaId, "CRIA");
          break;
        case RegisterSectionOption.reproductiveProductionPhase:
          lote = await apiLiderPollo.getLotesSalida(granjaId, "PRODUCCION");
          break;
        case RegisterSectionOption.reproductiveFatteningPhase:
          lote = await apiLiderPollo.getLotesSalida(granjaId, "ENGORDE");
          break;
        case RegisterSectionOption():
          lote = null;
          break;
      }

      if (lote == null) {
        loader.close();
        return;
      }

      loader.close();

      setState(() {
        batch = lote!;
      });
    } catch (e) {
      loader.close();
    }
  }

  changeLoteSalida(int? value) {
    if (selectedLoteController.value == null) return;
    if (value == null) return;

    final lote = batch.firstWhere((element) => element.id == value);

    setState(() {
      cantidadAvesController.text = lote.cantidadAves;
    });
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      getData();
    });

    super.initState();
  }

  Future<void> guardar() async {
    final data = {
      "salida_id": selectedLoteController.value,
      "cant_aves_translado": cantidadAvesController.text,
      "peso_prom_salida": pesoPromedioController.text,
      "condicion_vehiculo": condicionVehiculoController.text,
      "num_jaulas": cantidadJaulasController.text,
      "fecha_salida": fechaSalidaController.text,
      "hora_salida": horaSalidaController.text,
    };

    switch (widget.section) {
      case RegisterSectionOption.breedingPhase:
        await apiLiderPollo.setInspeccionTransporteCrias(data);
        break;
      case RegisterSectionOption.reproductiveProductionPhase:
        await apiLiderPollo.setInspeccionTransporteProduccion(data);
        break;
      case RegisterSectionOption.reproductiveFatteningPhase:
        await apiLiderPollo.setInspeccionTransporteEngorde(data);
        break;
      case RegisterSectionOption():
        throw "Error al guardar";
    }
  }

  Future<void> confirmHandler() async {
    if (!formKey.currentState!.validate()) return;

    final accepts = await Modal.showAlertToContinue(
      context,
      icon: Image.asset(RegisterOption.transportInspection.icon, height: 25),
      titleText: "¿Deseas confirmar la inspección?",
      textCancelBtn: "No, cancelar",
      textConfirmBtn: "Si, confirmar",
    );
    if (accepts != true || !context.mounted) return;

    try {
      loader.init();

      await guardar();

      if (!mounted) return;

      loader.close();

      Nav.pushReplacement(context,
          hideBottomNavigationBar: true,
          page: OperationStatePage(
            operationState: OperationStateType.success,
            titleText: "¡Confirmado con éxito!",
            descText:
                "La inspección de transporte ha sido confirmada con éxito",
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
                      page: TransportInspectionPage(section: widget.section));
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

      Modal.showSystemAlert(context,
          icon:
              Icon(Icons.error_outline, color: ThemeApp.colors(context).error),
          titleText: "Error al guardar",
          contentText: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        titleText: widget.section.title,
        subTitleText: RegisterOption.transportInspection.title,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: Vars.gapLow),
          child: Column(children: [
            BottomSelectField(
              controller: selectedGranjaController,
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
                getLote(value);
              },
              dropdownMaxChildSize: .7,
              dropdownInitialChildSize: .7,
              dropdownTitleText: "Granja",
              dropdownSearchLabelText: "Granja",
              dropdownSearchHintText: "Buscar Granja",
              dropdownSearchFunction: (index, item, search) => farms[index]
                  .name
                  .toLowerCase()
                  .contains(search.toLowerCase()),
            ),
            Gap(16.sp).column,
            BottomSelectField(
              controller: selectedLoteController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Lote",
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
              onChanged: (value) {
                // Maneja la selección aquí
                changeLoteSalida(value);
              },
              dropdownMaxChildSize: .7,
              dropdownInitialChildSize: .7,
              dropdownTitleText: "Lote",
              dropdownSearchLabelText: "Lote",
              dropdownSearchHintText: "Buscar lote",
              dropdownSearchFunction: (index, item, search) => batch[index]
                  .lote
                  .toLowerCase()
                  .contains(search.toLowerCase()),
            ),
            Gap(16.sp).column,
            InputField(
              controller: cantidadAvesController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Cant. de Aves a Transladar",
              hintText: "0",
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            Gap(16.sp).column,
            InputField(
              controller: pesoPromedioController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Peso Prom. del ave al Salir",
              hintText: "0",
              numeric: true,
            ),
            Gap(16.sp).column,
            InputField(
              controller: condicionVehiculoController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Condiciones de vehículo",
              hintText: "Condiciones",
              maxLines: 2,
            ),
            Gap(16.sp).column,
            InputField(
              controller: cantidadJaulasController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Número de jaulas",
              hintText: "0",
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            Gap(16.sp).column,
            DatePickerField(
              controller: fechaSalidaController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              firstDate: DateTime.now().subtract(const Duration(days: 150)),
              lastDate: DateTime.now(),
              labelText: "Fecha de Salida",
              hintText: DateTime.now().formatTime(pattern: "dd/MM/yyyy"),
            ),
            Gap(16.sp).column,
            TimePickerField(
              controller: horaSalidaController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              initialTime: TimeOfDay.now(),
              labelText: "Hora de Salida",
              hintText: "10:00 am",
            ),
            const Gap(Vars.gapMax * 3).column,
          ]),
        ),
      ),
      bottomWidget: Button(
        margin: Vars.paddingScaffold,
        text: "Confirmar Inspección",
        onPressed: confirmHandler,
      ),
    );
  }
}