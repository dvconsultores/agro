import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sap_avicola/models/lote_incubadora_model.dart';
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

class IncubatorPage extends StatefulWidget {
  const IncubatorPage({super.key});

  @override
  State<IncubatorPage> createState() => _IncubatorPageState();
}

class _IncubatorPageState extends State<IncubatorPage> with ThemesMixin {
  late final loader = AppLoader();
  final apiLiderPollo = ApiLiderPollo();

  final formKey = GlobalKey<FormState>();

  final selectedLoteController = ValueNotifier<int?>(null);

  final fechaIncubacionController = TextEditingController();
  final cantidadHuevosController = TextEditingController();
  final temperaturaController = TextEditingController();
  final fechaInicioIncubacionController = TextEditingController();
  final horaInicioIncubacionController = TextEditingController();

  String cantHuevos = "0";

  var batch = <LoteIncubadoraModel>[];

  Future<void> getData() async {
    try {
      loader.init();

      await Future.wait([getLotes()]);

      loader.close();
    } catch (e) {
      loader.close();
    }
  }

  Future<void> getLotes() async {
    final lotes =
        await apiLiderPollo.getLotesRecepcionIncubadora(0, "CLASIFICADO");

    setState(() {
      batch = lotes;
    });
  }

  changeLote(int? value) {
    if (selectedLoteController.value == null) return;
    if (value == null) return;

    final lote = batch.firstWhere((element) => element.id == value);

    setState(() {
      cantHuevos = lote.cantidad;
      cantidadHuevosController.text = lote.cantidad;
    });
  }

  Future<void> guardar() async {
    final data = {
      "recepcion_id": selectedLoteController.value,
      "fecha_incubacion": fechaIncubacionController.text,
      "cant_huevos": cantidadHuevosController.text,
      "temperatura": temperaturaController.text,
      "fecha_inicio_incubacion": fechaInicioIncubacionController.text,
      "hora_inicio_incubacion": horaInicioIncubacionController.text,
    };

    await apiLiderPollo.setIncubacionIncubadora(data);
  }

  Future<void> incubateHandler() async {
    if (!formKey.currentState!.validate()) return;

    final accepts = await Modal.showAlertToContinue(
      context,
      icon: Image.asset("assets/icons/incubator_egg.svg", height: 25),
      titleText: "¿Deseas enviar\n Incubar?",
      textCancelBtn: "No, cancelar",
      textConfirmBtn: "Si, enviar",
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
            titleText: "¡Envío exitoso!",
            descText: "Se ha enviado a incubar con éxito",
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
                      page: const IncubatorPage());
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
        titleText: RegisterSectionOption.incubator.title,
        subTitleText: RegisterOption.incubator.title,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: Vars.gapLow),
          child: Column(children: [
            DatePickerField(
              controller: fechaIncubacionController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              firstDate: DateTime.now().subtract(const Duration(days: 150)),
              lastDate: DateTime.now(),
              labelText: "Fecha de Incubación",
              hintText: DateTime.now().formatTime(pattern: "dd/MM/yyyy"),
            ),
            Gap(20.sp).column,
            BottomSelectField(
              controller: selectedLoteController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Lote",
              hintText: "Seleccionar Lote",
              items: batch
                  .map(
                      (e) => DropdownMenuItem(value: e.id, child: Text(e.lote)))
                  .toList(),
              onChanged: (value) {
                changeLote(value);
              },
              dropdownMaxChildSize: .7,
              dropdownInitialChildSize: .7,
              dropdownTitleText: "Lote",
              dropdownSearchLabelText: "Lote",
              dropdownSearchHintText: "Buscar Lote",
              dropdownSearchFunction: (index, item, search) => batch[index]
                  .lote
                  .toLowerCase()
                  .contains(search.toLowerCase()),
            ),
            Text("Cantidad de huevos: $cantHuevos"),
            Gap(20.sp).column,
            InputField(
              controller: cantidadHuevosController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Cantidad de Huevos",
              hintText:
                  "0" /*(batch
                          .lastWhereOrNull((element) =>
                              element.id == selectedLoteController.value)
                          ?.cantidad ??
                      0)
                  .toString()*/
              ,
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            Gap(20.sp).column,
            InputField(
              controller: temperaturaController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Temperatura",
              hintText: "0°",
            ),
            Gap(20.sp).column,
            DatePickerField(
              controller: fechaInicioIncubacionController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              firstDate: DateTime.now().subtract(const Duration(days: 150)),
              lastDate: DateTime.now().add(const Duration(days: 30)),
              labelText: "Fecha Inicio de Incubación",
              hintText: DateTime.now().formatTime(pattern: "dd/MM/yyyy"),
            ),
            Gap(20.sp).column,
            TimePickerField(
              controller: horaInicioIncubacionController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              initialTime: TimeOfDay.now(),
              labelText: "Hora Inicio de Incubación",
              hintText: "10:00 am",
            ),
            const Gap(Vars.gapMax * 3).column,
          ]),
        ),
      ),
      bottomWidget: Button(
        margin: Vars.paddingScaffold,
        text: "Enviar a Incubar",
        onPressed: incubateHandler,
      ),
    );
  }
}
