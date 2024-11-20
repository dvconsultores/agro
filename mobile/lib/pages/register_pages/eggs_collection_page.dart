import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sap_avicola/models/galpon_recepcion_model.dart';
import 'package:sap_avicola/models/granja_model.dart';
import 'package:sap_avicola/models/lote_model.dart';
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

class EggsCollecionPage extends StatefulWidget {
  const EggsCollecionPage({super.key, required this.optionIndex});
  final int optionIndex;

  @override
  State<EggsCollecionPage> createState() => _EggsCollecionPageState();
}

class _EggsCollecionPageState extends State<EggsCollecionPage>
    with ThemesMixin {
  late final loader = AppLoader();
  final apiLiderPollo = ApiLiderPollo();

  final formKey = GlobalKey<FormState>();

  final selectedGranjaController = ValueNotifier<int?>(null);
  final selectedGalponController = ValueNotifier<int?>(null);
  final selectedLoteController = ValueNotifier<int?>(null);

  final fechaController = TextEditingController();
  final horaController = TextEditingController();
  final huevosRecolectadosController = TextEditingController();

  var farms = <GranjaModel>[],
      batch = <LoteModel>[],
      sheds = <GalponRecepcionModel>[];

  Future<void> getData() async {
    try {
      loader.init();
      await Future.wait([getGranjas()]);
      if (mounted) loader.close();
    } catch (e) {
      if (mounted) loader.close();
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
      loader.init();

      selectedLoteController.value = null;
      selectedGalponController.value = null;

      if (granjaId == null) {
        loader.close();
        return;
      }
      final lote =
          await apiLiderPollo.getLotesRecepcion(granjaId, "PRODUCCION");

      loader.close();

      setState(() {
        batch = lote;
      });
    } catch (e) {
      loader.close();
    }
  }

  Future<void> getGalpon(recepcionId) async {
    if (selectedLoteController.value == null) return;
    loader.init();

    try {
      if (recepcionId == null) {
        loader.close();
        return;
      }
      final galpones =
          await apiLiderPollo.getGalponesRecepcion(recepcionId, "PRODUCCION");

      loader.close();

      setState(() {
        sheds = galpones;
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

  Future<void> guardar() async {
    final data = {
      "recepcion_id": selectedLoteController.value,
      "galpon_distribucion_id": selectedGalponController.value,
      "fecha_salida": fechaController.text,
      "cant_huevos": huevosRecolectadosController.text,
      "fecha": fechaController.text,
      "hora": horaController.text,
    };

    await apiLiderPollo.setRecoleccionHuevosProduccion(data);
  }

  Future<void> registerHandler() async {
    if (!formKey.currentState!.validate()) return;

    final accepts = await Modal.showAlertToContinue(
      context,
      icon: Icon(RegisterOption.productionProcess.icon, size: 25),
      titleText: "¿Deseas guardar el registro de recolección?",
      textCancelBtn: "No, cancelar",
      textConfirmBtn: "Si, guardar",
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
            descText:
                "El registro de recolección de huevos fue guardado con éxito",
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
                      page: EggsCollecionPage(optionIndex: widget.optionIndex));
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
        titleText:
            RegisterOption.productionProcess.children[widget.optionIndex],
        subTitleText: RegisterOption.productionProcess.title,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: Vars.gapLow),
          child: Column(children: [
            Gap(16.sp).column,
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
            BottomSelectField(
              controller: selectedLoteController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Lote",
              hintText: "Seleccione Lote",
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
                getGalpon(value);
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
            Gap(16.sp).column,
            BottomSelectField(
              controller: selectedGalponController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Galpón",
              hintText: "Seleccione Galpón",
              items: sheds
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
              dropdownSearchHintText: "Buscar Galpón",
              dropdownSearchFunction: (index, item, search) => sheds[index]
                  .galpon
                  .toUpperCase()
                  .contains(search.toUpperCase()),
            ),
            Gap(16.sp).column,
            DatePickerField(
              controller: fechaController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              firstDate: DateTime.now().subtract(const Duration(days: 150)),
              lastDate: DateTime.now(),
              labelText: "Fecha",
              hintText: DateTime.now().formatTime(pattern: 'dd/MM/yyyy'),
            ),
            Gap(16.sp).column,
            TimePickerField(
              controller: horaController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              initialTime: TimeOfDay.now(),
              labelText: "Hora",
              hintText: "10:00 am",
            ),
            Gap(16.sp).column,
            InputField(
              controller: huevosRecolectadosController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Cant. Huevos Recolectados",
              hintText: "0",
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const Gap(Vars.gapMax * 3).column,
          ]),
        ),
      ),
      bottomWidget: Button(
        margin: Vars.paddingScaffold,
        text: "Guardar Registro",
        onPressed: registerHandler,
      ),
    );
  }
}
