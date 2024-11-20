import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sap_avicola/models/granja_model.dart';
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

class EggsReceptionPage extends StatefulWidget {
  const EggsReceptionPage({super.key});

  @override
  State<EggsReceptionPage> createState() => _EggsReceptionPageState();
}

class _EggsReceptionPageState extends State<EggsReceptionPage>
    with ThemesMixin {
  late final loader = AppLoader();
  final apiLiderPollo = ApiLiderPollo();

  final formKey = GlobalKey<FormState>();

  final selectedGranjaController = ValueNotifier<int?>(null);
  final selectedLoteController = ValueNotifier<int?>(null);
  final selectedTransporteController = ValueNotifier<int?>(null);

  final fechaRecepcionController = TextEditingController(),
      ordenTrasladoController = TextEditingController(),
      cantidadRecibidaController = TextEditingController(),
      temperaturaHuevosController = TextEditingController(),
      placaController = TextEditingController();

  String cantHuevosRecepcion = "0";

  var farms = <GranjaModel>[],
      batch = <LoteHuevosRecepcionModel>[],
      transports = <TransporteModel>[];

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
      transports = transportes;
    });
  }

  Future<void> getLote(granjaId) async {
    try {
      setState(() {
        cantHuevosRecepcion = "0";
        cantidadRecibidaController.text = "";
      });
      loader.init();

      selectedLoteController.value = null;

      if (granjaId == null) {
        loader.close();
        return;
      }
      final lote = await apiLiderPollo.getLotesHuevosRecepcionar(granjaId);

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
      cantHuevosRecepcion = lote.cantidadHuevos;
      cantidadRecibidaController.text = lote.cantidadHuevos;
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
      "fecha_recepcion": fechaRecepcionController.text,
      "salida_huevos_produccion_id": selectedLoteController.value,
      "orden_traslado": ordenTrasladoController.text,
      "cant_huevos": cantidadRecibidaController.text,
      "temperatura_huevos": temperaturaHuevosController.text,
      "transporte_entrega_id": selectedTransporteController.value,
      "placa_transporte": placaController.text,
    };

    await apiLiderPollo.setRecepcionIncubadora(data);
  }

  Future<void> registerHandler() async {
    if (!formKey.currentState!.validate()) return;
    final accepts = await Modal.showAlertToContinue(
      context,
      icon: const Icon(Icons.egg_outlined, size: 25),
      titleText: "¿Deseas confirmar la recepción?",
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
            titleText: "¡Recepción exitosa!",
            descText: "La recepción de huevos ha sido confirmada con éxito",
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
                      page: const EggsReceptionPage());
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
        subTitleText: RegisterOption.eggsReception.title,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: Vars.gapLow),
          child: Column(children: [
            DatePickerField(
              controller: fechaRecepcionController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              firstDate: DateTime.now().subtract(const Duration(days: 150)),
              lastDate: DateTime.now(),
              labelText: "Fecha de Recepción",
              hintText: DateTime.now().formatTime(pattern: "dd/MM/yyyy"),
            ),
            Gap(20.sp).column,
            BottomSelectField(
              controller: selectedGranjaController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Granja",
              hintText: "seleccione Granja",
              items: farms
                  .map(
                      (e) => DropdownMenuItem(value: e.id, child: Text(e.name)))
                  .toList(),
              onChanged: (value) => getLote(value),
              dropdownMaxChildSize: .7,
              dropdownInitialChildSize: .7,
              dropdownTitleText: "Granja",
              dropdownSearchLabelText: "Granja",
              dropdownSearchHintText: "buscar Granja",
              dropdownSearchFunction: (index, item, search) => farms[index]
                  .name
                  .toUpperCase()
                  .contains(search.toUpperCase()),
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
                  .toUpperCase()
                  .contains(search.toUpperCase()),
            ),
            Text("Cantidad de huevos a recibir: $cantHuevosRecepcion"),
            Gap(20.sp).column,
            InputField(
              controller: ordenTrasladoController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Orden de Traslado",
              hintText: "Orden",
            ),
            Gap(20.sp).column,
            InputField(
              controller: cantidadRecibidaController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Cantidad Recibida",
              hintText: "0",
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            Gap(20.sp).column,
            InputField(
              controller: temperaturaHuevosController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Temperatura de los huevos",
              hintText: "0°",
            ),
            Gap(20.sp).column,
            BottomSelectField(
              controller: selectedTransporteController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Transporte de entrega",
              hintText: "Seleccionar Transporte",
              items: transports
                  .map(
                      (e) => DropdownMenuItem(value: e.id, child: Text(e.name)))
                  .toList(),
              dropdownMaxChildSize: .7,
              dropdownInitialChildSize: .7,
              dropdownTitleText: "Transporte de entrega",
              dropdownSearchLabelText: "Transporte de entrega",
              dropdownSearchHintText: "Buscar transporte",
              dropdownSearchFunction: (index, item, search) => transports[index]
                  .name
                  .toUpperCase()
                  .contains(search.toUpperCase()),
            ),
            Gap(20.sp).column,
            InputField(
              controller: placaController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Placa",
              hintText: "123-XYT",
            ),
            const Gap(Vars.gapMax * 3).column,
          ]),
        ),
      ),
      bottomWidget: Button(
        margin: Vars.paddingScaffold,
        text: "Confirmar Recepción",
        onPressed: registerHandler,
      ),
    );
  }
}
