import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sap_avicola/models/galpon_model.dart';
import 'package:sap_avicola/models/granja_model.dart';
import 'package:sap_avicola/models/lote_incubadora_model.dart';
import 'package:sap_avicola/models/orden_salida_pollitos_model.dart';
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
import 'package:sap_avicola/widgets/form_fields/multiple_select_field.dart';
import 'package:sap_avicola/widgets/form_fields/time_picker_field.dart';
import 'package:sap_avicola/widgets/loaders/loader.dart';
import 'package:sap_avicola/widgets/sheets/card_widget.dart';

class BabyChicksExitPage extends StatefulWidget {
  const BabyChicksExitPage({super.key});

  @override
  State<BabyChicksExitPage> createState() => _BabyChicksExitPageState();
}

class _BabyChicksExitPageState extends State<BabyChicksExitPage>
    with ThemesMixin {
  late final loader = AppLoader();
  final apiLiderPollo = ApiLiderPollo();

  final formKey = GlobalKey<FormState>();

  final selectedLoteController = ValueNotifier<List<int>>([]);
  final selectedTransportController = ValueNotifier<int?>(null);
  final selectedOrdenSalidaControllers = ValueNotifier<String?>(null);
  final selectedGranjaControllers = ValueNotifier<int?>(null);
  // final selectedGalponControllers = ValueNotifier<int?>(null);

  final fechaSalidaController = TextEditingController();
  final horaSalidaController = TextEditingController();
  final condicionTransporteController = TextEditingController();

  List<TextEditingController> cantidadAvesControllers = [];
  List<ValueNotifier<int?>> selectedGalponControllers = [];

  String cantidadNacida = "0";
  final availableSheds = TextEditingController();

  var batch = <LoteIncubadoraModel>[],
      farms = <GranjaModel>[],
      ordenes = <OrdenSalidaPollitosModel>[],
      transports = <TransporteModel>[],
      sheds = <GalponModel>[];

  Future<void> getData() async {
    try {
      loader.init();

      await Future.wait(
          [getLotes(), getOrdenesSalida(), getGranjas(), getTransportes()]);

      loader.close();
    } catch (e) {
      loader.close();
    }
  }

  Future<void> getLotes() async {
    final lotes =
        await apiLiderPollo.getLotesRecepcionIncubadora(0, "ASIGNADO");

    setState(() {
      batch = lotes;
    });
  }

  changeLote(List<int>? value) {
    if (selectedLoteController.value.isEmpty) return;
    if (value == null || value.isEmpty) return;

    int cantidad = 0;
    for (var element in value) {
      final lote = batch.firstWhere((item) => item.id == element);
      cantidad += int.parse(lote.cantidadNacidos);
    }

    setState(() {
      cantidadNacida = cantidad.toString();
    });
  }

  Future<void> getGranjas() async {
    final granjas = await apiLiderPollo.getGranjas();

    setState(() {
      farms = granjas;
    });
  }

  /* Future<void> getGalpones(granjaId) async {
    try {
      setState(() {
        selectedGalponControllers.value = null;
      });

      loader.init();

      if (granjaId == null) return;
      final galpones = await apiLiderPollo.getGalpones(granjaId);

      if (!mounted) return;
      loader.close();

      setState(() {
        sheds = galpones;
      });
    } catch (e) {
      if (!mounted) return;
      loader.close();
    }
  } */

  Future<void> getOrdenesSalida() async {
    final ordenesList = await apiLiderPollo.getOrdenesSalidaIncubadora();

    setState(() {
      ordenes = ordenesList;
    });
  }

  changeOrdenSalida(String? value) async {
    if (selectedOrdenSalidaControllers.value == null) return;
    if (value == null) return;

    final orden = ordenes.firstWhere((element) => element.orden == value);

    await getGalpones(orden.destinoId);

    setState(() {
      availableSheds.text = orden.cantidadAvesList.length.toString();
    });

    cantidadAvesControllers = [];
    selectedGalponControllers = [];

    cantidadAvesControllers = List.generate(
        availableSheds.text.toInt(),
        (index) => TextEditingController(
            text: orden.cantidadAvesList[index].toString()));
    selectedGalponControllers = List.generate(
        availableSheds.text.toInt(), (index) => ValueNotifier<int?>(null));

    setState(() {
      //cantidadAvesControllers = List.generate(orden.cantidadAvesList.length, (index) => TextEditingController());
      selectedGranjaControllers.value = orden.destinoId;
      selectedTransportController.value = orden.transporteId;
    });
  }

  Future<void> getGalpones(granjaId) async {
    try {
      if (granjaId == null) return;

      loader.init();

      for (var element in selectedGalponControllers) {
        element.value = null;
      } //  = List.generate(cant, (index) => ValueNotifier<int?>(null));

      // availableSheds.text = "";
      //cantAvesRecepcion = "0";

      //cantidadTotalController.text = "";

      final galpones = await apiLiderPollo.getGalpones(granjaId);

      if (!mounted) return;
      loader.close();

      /*final cant =
          availableSheds.text.isNotEmpty ? availableSheds.text.toInt() : 0;*/

      setState(() {
        sheds = galpones;
      });
    } catch (e) {
      if (!mounted) return;
      loader.close();
    }
  }

  void changeAvailableSheds(String value) {
    final cant = value.isEmpty ? 0 : int.parse(value);
    int shedCount = cant;

    cantidadAvesControllers =
        List.generate(shedCount, (index) => TextEditingController());
    selectedGalponControllers =
        List.generate(shedCount, (index) => ValueNotifier<int?>(null));

    EasyDebounce.debounce(
      "animate",
      Durations.medium4,
      () => setState(() {}),
    );
  }

  Future<void> getTransportes() async {
    final transportes = await apiLiderPollo.getTransportes();

    setState(() {
      transports = transportes;
    });
  }

  Future<void> guardar() async {
    final data = {
      "orden": selectedOrdenSalidaControllers.value,
      "recepciones": selectedLoteController.value,
      "fecha_salida": fechaSalidaController.text,
      "hora_salida": horaSalidaController.text,
      "transporte_entrega_id": selectedTransportController.value,
      "condicion_vehiculo": condicionTransporteController.text,
      "granja_destino_id": selectedGranjaControllers.value,
      "distribucion": List.generate(
        selectedGalponControllers.length,
        (index) => {
          "galpon_id": selectedGalponControllers[index].value,
          "cant_pollitos": cantidadAvesControllers[index].text,
        },
      ),
    };

    await apiLiderPollo.setSalidaPollitosIncubadora(data);
  }

  Future<void> registerHandler() async {
    if (!formKey.currentState!.validate()) return;

    final accepts = await Modal.showAlertToContinue(
      context,
      icon: Image.asset("assets/icons/baby_chick.png", height: 25),
      titleText: "¿Deseas registrar\nla Salida?",
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
            titleText: "¡Declarado con éxito!",
            descText: "La salida de aves fue declarada con éxito",
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
                      page: const BabyChicksExitPage());
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
        subTitleText: RegisterOption.babyChicksExit.title,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: Vars.gapLow),
          child: Column(children: [
            MultipleSelectField(
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
            Text("Cantidad pollitos nacidos: $cantidadNacida"),
            Gap(16.sp).column,
            BottomSelectField(
              controller: selectedOrdenSalidaControllers,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Orden de Salida",
              hintText: "Seleccionar orden salida",
              items: ordenes
                  .map((item) => DropdownMenuItem(
                        value: item.orden,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(item.numOrden),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                changeOrdenSalida(value);
              },
              dropdownMaxChildSize: .7,
              dropdownInitialChildSize: .7,
              dropdownTitleText: "Orden de Salida",
              dropdownSearchLabelText: "Orden de Salida",
              dropdownSearchHintText: "Buscar Orden de Salida",
              dropdownSearchFunction: (index, item, search) => ordenes[index]
                  .numOrden
                  .toUpperCase()
                  .contains(search.toUpperCase()),
            ),
            Gap(16.sp).column,
            BottomSelectField(
              controller: selectedGranjaControllers,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Granja destino",
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
                getGalpones(value);
              },
              dropdownMaxChildSize: .7,
              dropdownInitialChildSize: .7,
              dropdownTitleText: "Granja destino",
              dropdownSearchLabelText: "Granja destino",
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
            TimePickerField(
              controller: horaSalidaController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              initialTime: TimeOfDay.now(),
              labelText: "Hora Salida",
              hintText: "10:00 am",
            ),
            Gap(16.sp).column,
            BottomSelectField(
              controller: selectedTransportController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Transporte",
              hintText: "Seleccionar Transporte",
              items: transports
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
              dropdownSearchFunction: (index, item, search) => transports[index]
                  .name
                  .toUpperCase()
                  .contains(search.toUpperCase()),
            ),
            Gap(16.sp).column,
            InputField(
              controller: condicionTransporteController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Condiciones del Vehículo ",
              hintText: "Condiciones",
              maxLines: 2,
            ),
            Gap(18.6.sp).column,
            const Divider(height: 0),
            Gap(20.sp).column,
            InputField(
              controller: availableSheds,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Cant. de Galpones",
              hintText: "0",
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) => changeAvailableSheds(value),
            ),
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
                cantidadAvesController: cantidadAvesControllers[index],
                selectedGalponController: selectedGalponControllers[index],
              ),
            ),
            const Gap(Vars.gapMax * 3).column,
          ]),
        ),
      ),
      bottomWidget: Button(
        margin: Vars.paddingScaffold,
        text: "Registrar Salida",
        onPressed: registerHandler,
      ),
    );
  }
}

class _ShedFields extends StatelessWidget {
  const _ShedFields(
      {required this.items,
      required this.cantidadAvesController,
      required this.selectedGalponController});

  final List<GalponModel> items;
  final TextEditingController cantidadAvesController;
  final ValueNotifier<int?> selectedGalponController;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
        color: const Color(0xFFFBFBFB),
        border: Border.all(color: Theme.of(context).dividerTheme.color!),
        boxShadow: const [],
        child: Column(children: [
          BottomSelectField(
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
            dropdownSearchHintText: "Buscar Galpón",
            dropdownSearchFunction: (index, item, search) => items[index]
                .galpon
                .toLowerCase()
                .contains(search.toLowerCase()),
          ),
          Gap(16.sp).column,
          InputField(
            controller: cantidadAvesController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => ValidatorField.evaluate(
                value, (instance) => [instance.required]),
            labelText: "Cantidad aves",
            hintText: "0",
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ]));
  }
}
