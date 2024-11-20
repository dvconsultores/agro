import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sap_avicola/models/galpon_model.dart';
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
import 'package:sap_avicola/widgets/loaders/loader.dart';
import 'package:sap_avicola/widgets/sheets/card_widget.dart';

class ProductionBirdsDistributionPage extends StatefulWidget {
  const ProductionBirdsDistributionPage({super.key});

  @override
  State<ProductionBirdsDistributionPage> createState() =>
      _ProductionBirdsDistributionPageState();
}

class _ProductionBirdsDistributionPageState
    extends State<ProductionBirdsDistributionPage> with ThemesMixin {
  late final loader = AppLoader();
  final apiLiderPollo = ApiLiderPollo();

  final formKey = GlobalKey<FormState>();

  final selectedGranjaController = ValueNotifier<int?>(null);
  final selectedLoteController = ValueNotifier<int?>(null);

  final fechaEnvioController = TextEditingController();
  final pesoPromedioSalidaController = TextEditingController();
  final pesoPromedioEntradaController = TextEditingController();
  final fechaRecepcionController = TextEditingController();
  final cantidadMachosController = TextEditingController();
  final cantidadHembrasController = TextEditingController();

  List<TextEditingController> cantidadMachosControllers = [];
  List<TextEditingController> cantidadHembrasControllers = [];
  List<ValueNotifier<int?>> selectedGalponControllers = [];

  String cantAvesRecepcion = "0";

  var farms = <GranjaModel>[],
      batch = <LoteSalidaModel>[],
      sheds = <GalponModel>[];

  final availableSheds = TextEditingController();

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

  Future<void> getDataGranja(granjaId) async {
    try {
      loader.init();

      availableSheds.text = "";
      cantAvesRecepcion = "0";
      selectedLoteController.value = null;
      selectedGalponControllers = [];
      cantidadMachosControllers = [];
      cantidadHembrasControllers = [];

      if (granjaId == null) {
        loader.close();
        return;
      }

      final galpones = await apiLiderPollo.getGalpones(granjaId);
      final lote =
          await apiLiderPollo.getLotesSalidaAprobadaProduccion(granjaId);

      if (!mounted) return;
      loader.close();

      setState(() {
        sheds = galpones;
        batch = lote;
      });
    } catch (e) {
      if (!mounted) return;
      loader.close();
    }
  }

  changeLoteSalidaAprobadas(int? value) {
    if (selectedLoteController.value == null) return;
    if (value == null) return;

    final lote = batch.firstWhere((element) => element.id == value);

    setState(() {
      cantAvesRecepcion = lote.cantidadAves;
    });
  }

  void changeAvailableSheds(String value) {
    final cant = value.isEmpty ? 0 : int.parse(value);

    int shedCount = cant;

    cantidadMachosControllers =
        List.generate(shedCount, (index) => TextEditingController());
    cantidadHembrasControllers =
        List.generate(shedCount, (index) => TextEditingController());
    selectedGalponControllers =
        List.generate(shedCount, (index) => ValueNotifier<int?>(null));

    EasyDebounce.debounce(
      "animate",
      Durations.medium4,
      () => setState(() {}),
    );
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
      "granja_id": selectedGranjaController.value,
      "fecha_envio": fechaEnvioController.text,
      "peso_promedio_salida": pesoPromedioSalidaController.text,
      "peso_promedio_entrada": pesoPromedioEntradaController.text,
      "fecha_recepcion": fechaRecepcionController.text,
      "cant_machos": cantidadMachosController.text,
      "cant_hembras": cantidadHembrasController.text,
      "salida_ave_cria_id": selectedLoteController.value,
      "Distribucion": List.generate(
        selectedGalponControllers.length,
        (index) => {
          "galpon_id": selectedGalponControllers[index].value,
          "cant_hembras": cantidadMachosControllers[index].text,
          "cant_machos": cantidadHembrasControllers[index].text,
        },
      ),
    };

    await apiLiderPollo.setRecepcionProduccion(data);
  }

  Future<void> registerHandler() async {
    if (!formKey.currentState!.validate()) return;

    final accepts = await Modal.showAlertToContinue(
      context,
      icon: Icon(RegisterOption.birdsDistribution.icon, size: 25),
      titleText: "¿Deseas registrar la distribución?",
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
            titleText: "¡Distribución exitosa!",
            descText: "La distribución ha sido confirmada con éxito",
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
                      page: const ProductionBirdsDistributionPage());
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
        titleText: RegisterSectionOption.reproductiveProductionPhase.title,
        subTitleText: RegisterOption.birdsDistribution.title,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: Vars.gapNormal),
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
                getDataGranja(value);
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
                changeLoteSalidaAprobadas(value);
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
            Text("Cantidad de aves a recibir: $cantAvesRecepcion"),
            Gap(16.sp).column,
            DatePickerField(
              controller: fechaEnvioController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              firstDate: DateTime.now().subtract(const Duration(days: 150)),
              lastDate: DateTime.now(),
              labelText: "Fecha Envío desde la Granja de Cría",
              hintText: DateTime.now().formatTime(pattern: "dd/MM/yyyy"),
            ),
            Gap(16.sp).column,
            InputField(
              controller: pesoPromedioSalidaController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Peso prom. Ave al salir de la Granja de Cría",
              hintText: "0",
              numeric: true,
            ),
            Gap(16.sp).column,
            InputField(
              controller: pesoPromedioEntradaController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Peso prom. Ave al Llegar Granja de Reproductora",
              hintText: "0",
              numeric: true,
            ),
            Gap(16.sp).column,
            DatePickerField(
              controller: fechaRecepcionController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              firstDate: DateTime.now().subtract(const Duration(days: 150)),
              lastDate: DateTime.now(),
              labelText: "Fecha Recepción",
              hintText: DateTime.now().formatTime(pattern: "dd/MM/yyyy"),
            ),
            Gap(16.sp).column,
            InputField(
              controller: cantidadMachosController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Cant. Aves Macho",
              hintText: "0",
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            Gap(16.sp).column,
            InputField(
              controller: cantidadHembrasController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Cant. Aves Hembras",
              hintText: "0",
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            Gap(23.sp).column,
            Text("Distribución por Galpón", style: theme.textTheme.bodyLarge),
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
                cantidadMachosController: cantidadMachosControllers[index],
                cantidadHembrasController: cantidadHembrasControllers[index],
                selectedGalponController: selectedGalponControllers[index],
              ),
            ),
            const Gap(Vars.gapMax * 3).column,
          ]),
        ),
      ),
      bottomWidget: Button(
        margin: Vars.paddingScaffold,
        text: "Registrar Distribución",
        onPressed: registerHandler,
      ),
    );
  }
}

class _ShedFields extends StatelessWidget {
  const _ShedFields(
      {required this.items,
      required this.cantidadMachosController,
      required this.cantidadHembrasController,
      required this.selectedGalponController});

  final List<GalponModel> items;
  final TextEditingController cantidadMachosController;
  final TextEditingController cantidadHembrasController;
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
            hintText: "Sekeccionar Galpón",
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
            controller: cantidadMachosController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => ValidatorField.evaluate(
                value, (instance) => [instance.required]),
            labelText: "Cantidad aves machos",
            hintText: "0",
          ),
          Gap(16.sp).column,
          InputField(
            controller: cantidadHembrasController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => ValidatorField.evaluate(
                value, (instance) => [instance.required]),
            labelText: "Cantidad de Aves hembras",
            hintText: "0",
          ),
        ]));
  }
}
