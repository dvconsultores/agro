import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sap_avicola/models/granja_model.dart';
import 'package:sap_avicola/models/incubadora_model.dart';
import 'package:sap_avicola/models/lote_huevos_recepcion_model.dart';
import 'package:sap_avicola/models/register_option_model.dart';
import 'package:sap_avicola/models/transporte_model.dart';
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
import 'package:sap_avicola/widgets/loaders/loader.dart';

class EggsExitPage extends StatefulWidget {
  const EggsExitPage({super.key, required this.section});
  final RegisterSectionOption section;

  @override
  State<EggsExitPage> createState() => _EggsExitPageState();
}

class _EggsExitPageState extends State<EggsExitPage> with ThemesMixin {
  late final loader = AppLoader();
  final apiLiderPollo = ApiLiderPollo();

  final formKey = GlobalKey<FormState>();

  final selectedGranjaController = ValueNotifier<int?>(null);
  final selectedTransporteController = ValueNotifier<int?>(null);
  final selectedLoteController = ValueNotifier<int?>(null);

  final fechaSalidaController = TextEditingController();
  final cantHuevosController = TextEditingController();
  final pesoPromedioController = TextEditingController();
  final placaTransporteController = TextEditingController();

  String huevosDisponibles = "0";

  var farms = <GranjaModel>[],
      batch = <LoteHuevosRecepcionModel>[],
      incubadoraList = <IncubadoraModel>[],
      transport = <TransporteModel>[];

  Future<void> getData() async {
    try {
      loader.init();
      await Future.wait([getGranjas(), getTransportes()]);

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

  Future<void> getTransportes() async {
    final transportes = await apiLiderPollo.getTransportes();

    setState(() {
      transport = transportes;
    });
  }

  Future<void> getLote(granjaId) async {
    try {
      loader.init();

      huevosDisponibles = "0";
      selectedLoteController.value = null;

      if (granjaId == null) {
        loader.close();
        return;
      }
      final lote = await apiLiderPollo.getLotesHuevosRecepcion(granjaId);

      loader.close();

      setState(() {
        batch = lote;
      });
    } catch (e) {
      loader.close();
    }
  }

  changeLote(int? value) {
    if (selectedLoteController.value == null) return;
    if (value == null) return;

    final lote = batch.firstWhere((element) => element.id == value);

    setState(() {
      huevosDisponibles = lote.cantidadHuevos;
      cantHuevosController.text = lote.cantidadHuevos;
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
      "recepcion_id": selectedLoteController.value,
      "fecha_salida": fechaSalidaController.text,
      "cant_huevos": cantHuevosController.text,
      "peso_prom_salida": pesoPromedioController.text,
      "transporte_id": selectedTransporteController.value,
      "placa_transporte": placaTransporteController.text,
    };

    await apiLiderPollo.setSalidaHuevosProduccion(data);
  }

  Future<void> declareHandler() async {
    if (!formKey.currentState!.validate()) return;

    final accepts = await Modal.showAlertToContinue(
      context,
      icon: Image.asset(RegisterOption.birdExit.icon, height: 25),
      titleText: "¿Deseas declarar la salida de huevos?",
      textCancelBtn: "No, cancelar",
      textConfirmBtn: "Si, declarar",
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
            titleText: "¡Declarado con éxito!",
            descText: "La salida de los huevos fue declarada con éxito",
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
                      page: EggsExitPage(section: widget.section));
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
        subTitleText: RegisterOption.eggsExit.title,
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
              labelText: "Granja Salida",
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
              dropdownTitleText: "Granjas",
              dropdownSearchLabelText: "Granja",
              dropdownSearchHintText: "Buscar Granja",
              dropdownSearchFunction: (index, item, search) => farms[index]
                  .name
                  .toUpperCase()
                  .contains(search.toUpperCase()),
            ),
            Gap(16.sp).column,
            DatePickerField(
              controller: fechaSalidaController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              firstDate: DateTime.now().subtract(const Duration(days: 150)),
              lastDate: DateTime.now(),
              labelText: "Fecha Salida",
              hintText: DateTime.now().formatTime(pattern: "dd/MM/yyyy"),
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
                changeLote(value);
              },
              dropdownMaxChildSize: .7,
              dropdownInitialChildSize: .7,
              dropdownTitleText: "Lote",
              dropdownSearchLabelText: "Lote",
              dropdownSearchHintText: "Buscar lote",
              dropdownSearchFunction: (index, item, search) => batch[index]
                  .lote
                  .toUpperCase()
                  .contains(search.toUpperCase()),
            ),
            Text("Huevos disponibles: $huevosDisponibles"),
            Gap(16.sp).column,
            InputField(
              controller: cantHuevosController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Cant. huevos",
              hintText: "0",
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            if (widget.section.name ==
                RegisterSectionOption.reproductiveFatteningPhase.name) ...[
              Gap(16.sp).column,
              InputField(
                controller: pesoPromedioController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => ValidatorField.evaluate(
                    value, (instance) => [instance.required]),
                labelText: "Peso Prom. del Ave al Salir de Granja",
                hintText: "0.0",
                keyboardType:
                    const TextInputType.numberWithOptions(signed: true),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
            Gap(16.sp).column,
            BottomSelectField(
              controller: selectedTransporteController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Transporte",
              hintText: "Seleccionar Transporte",
              items: transport
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
              dropdownTitleText: "Transporte",
              dropdownSearchLabelText: "Transporte",
              dropdownSearchHintText: "Buscar Transporte",
              dropdownSearchFunction: (index, item, search) => transport[index]
                  .name
                  .toUpperCase()
                  .contains(search.toUpperCase()),
            ),
            Gap(16.sp).column,
            InputField(
              controller: placaTransporteController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Placa del Transporte",
              hintText: "XYT-987",
            ),
            const Gap(Vars.gapMax * 3).column,
          ]),
        ),
      ),
      bottomWidget: Button(
        margin: Vars.paddingScaffold,
        text: "Declarar Salida",
        onPressed: declareHandler,
      ),
    );
  }
}
