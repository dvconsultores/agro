import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sap_avicola/models/lote_incubadora_model.dart';
import 'package:sap_avicola/models/register_option_model.dart';
import 'package:sap_avicola/models/vacuna_model.dart';
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

class BirthCertificatePage extends StatefulWidget {
  const BirthCertificatePage({super.key});

  @override
  State<BirthCertificatePage> createState() => _BirthCertificatePageState();
}

class _BirthCertificatePageState extends State<BirthCertificatePage>
    with ThemesMixin {
  late final loader = AppLoader();
  final apiLiderPollo = ApiLiderPollo();

  final formKey = GlobalKey<FormState>();

  final selectedLoteController = ValueNotifier<int?>(null);
  // final selectedGranjaControllers = ValueNotifier<int?>(null);
  final selectedVacunaControllers = ValueNotifier<int?>(null);

  final fechaNacimientoController = TextEditingController();
  final cantidadNacidaController = TextEditingController();
  final cantidadSanosController = TextEditingController();
  final cantidadDebilesController = TextEditingController();
  final pesoPromedioPollitosController = TextEditingController();

  var batch = <LoteIncubadoraModel>[],
      //farms = <GranjaModel>[],
      vaccinates = <VacunaModel>[];

  Future<void> getData() async {
    try {
      loader.init();

      await Future.wait([getLotes(), /*getGranjas(),*/ getVacunas()]);

      loader.close();
    } catch (e) {
      loader.close();
    }
  }

  Future<void> getLotes() async {
    final lotes =
        await apiLiderPollo.getLotesRecepcionIncubadora(0, "AGENDADO");

    setState(() {
      batch = lotes;
    });
  }

  /* Future<void> getGranjas() async {
    final granjas = await apiLiderPollo.getGranjas();

    setState(() {
      farms = granjas;
    });
  } */

  Future<void> getVacunas() async {
    final vacunas = await apiLiderPollo.getVacunas();

    setState(() {
      vaccinates = vacunas;
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
      "fecha_nacimiento": fechaNacimientoController.text,
      "cant_nacidos": cantidadNacidaController.text,
      "cant_sanos": cantidadSanosController.text,
      "cant_debiles": cantidadDebilesController.text,
      "peso_prom": pesoPromedioPollitosController.text.replaceAll(',', '.'),
      "vacuna_id": selectedVacunaControllers.value,
      // "granja_asignacion_id": selectedGranjaControllers.value,
    };

    await apiLiderPollo.setNacimientoIncubadora(data);
  }

  Future<void> registerHandler() async {
    if (!formKey.currentState!.validate()) return;

    final accepts = await Modal.showAlertToContinue(
      context,
      icon: Image.asset("assets/icons/edit_square.svg", height: 25),
      titleText: "¿Deseas registrar\n el Nacimiento?",
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
            titleText: "¡Registro exitoso!",
            descText: "Se ha registrado el nacimiento con éxito",
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
                      page: const BirthCertificatePage());
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
        titleText: RegisterSectionOption.incubator.title,
        subTitleText: RegisterOption.birthCertificate.title,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: Vars.gapLow),
          child: Column(children: [
            DatePickerField(
              controller: fechaNacimientoController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              firstDate: DateTime.now().subtract(const Duration(days: 150)),
              lastDate: DateTime.now(),
              labelText: "Fecha de Nacimiento",
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
              dropdownMaxChildSize: .7,
              dropdownInitialChildSize: .7,
              dropdownTitleText: "Lote",
              dropdownSearchLabelText: "Lote",
              dropdownSearchHintText: "Buscar Lote",
              dropdownSearchFunction: (index, item, search) => batch[index]
                  .lote
                  .toUpperCase()
                  .contains(search.toUpperCase()),
            ),
            Gap(16.sp).column,
            InputField(
              controller: cantidadNacidaController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Cantidad Nacida",
              hintText: "0",
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            Gap(16.sp).column,
            InputField(
              controller: cantidadSanosController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Cantidad Sanos",
              hintText: "0",
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            Gap(16.sp).column,
            InputField(
              controller: cantidadDebilesController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Cantidad Débiles",
              hintText: "0",
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            Gap(16.sp).column,
            InputField(
              controller: pesoPromedioPollitosController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Peso Prom. Pollitos",
              hintText: "0",
              numeric: true,
            ),
            Gap(16.sp).column,
            BottomSelectField(
              controller: selectedVacunaControllers,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Vacuna",
              hintText: "Seleccionar Vacuna",
              items: vaccinates
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
              dropdownTitleText: "Vacuna Aplicada",
              dropdownSearchLabelText: "Vacuna Aplicada",
              dropdownSearchHintText: "Buscar Vacuna",
              dropdownSearchFunction: (index, item, search) => vaccinates[index]
                  .name
                  .toUpperCase()
                  .contains(search.toUpperCase()),
            ),
            /*Gap(16.sp).column,
            BottomSelectField(
              controller: selectedGranjaControllers,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Asignación a Granja",
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
              dropdownTitleText: "Asignación a Granja",
              dropdownSearchLabelText: "Asignación a Granja",
              dropdownSearchHintText: "Buscar Granja",
              dropdownSearchFunction: (index, item, search) =>
                  farms[index].name.toUpperCase().contains(search.toUpperCase()),
            ),*/
            const Gap(Vars.gapMax * 3).column,
          ]),
        ),
      ),
      bottomWidget: Button(
        margin: Vars.paddingScaffold,
        text: "Registrar Nacimiento",
        onPressed: registerHandler,
      ),
    );
  }
}
