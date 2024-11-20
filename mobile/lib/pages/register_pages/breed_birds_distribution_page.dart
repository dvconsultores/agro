import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sap_avicola/models/galpon_model.dart';
import 'package:sap_avicola/models/granja_model.dart';
import 'package:sap_avicola/models/lote_model.dart';
import 'package:sap_avicola/models/ordene_recepcion_cria_model.dart';
import 'package:sap_avicola/models/proveedores_model.dart';
import 'package:sap_avicola/models/razas_model.dart';
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

class BreedBirdsDistributionPage extends StatefulWidget {
  const BreedBirdsDistributionPage({super.key});

  @override
  State<BreedBirdsDistributionPage> createState() =>
      _BreedBirdsDistributionPageState();
}

class _BreedBirdsDistributionPageState extends State<BreedBirdsDistributionPage>
    with ThemesMixin {
  late final loader = AppLoader();
  final apiLiderPollo = ApiLiderPollo();

  final formKey = GlobalKey<FormState>();

  int? selectedGranjaControllers;
  final selectProveedorController = ValueNotifier<int?>(null);
  final selectedLoteController = ValueNotifier<int?>(null);
  final selectRazaController = ValueNotifier<int?>(null);
  final selectedordenCompraController = ValueNotifier<int?>(null);

  final loteController = TextEditingController();
  final cantidadAvesHembrasController = TextEditingController();
  final cantidadAvesMachosController = TextEditingController();
  final fechaDespachoController = TextEditingController();
  final fechaRecepcionController = TextEditingController();
  final pesoReportadoController = TextEditingController();
  final pesoPromedioController = TextEditingController();

  List<TextEditingController> cantidadMachosControllers = [];
  List<TextEditingController> cantidadHembrasControllers = [];
  List<ValueNotifier<int?>> selectedGalponControllers = [];

  var farms = <GranjaModel>[],
      providers = <ProveedorModel>[],
      breedBirds = <RazasModel>[],
      sheds = <GalponModel>[],
      ordenes = <OrdenRecepcionCriaModel>[],
      lotesDisponibles = <LoteModel>[];

  final availableSheds = TextEditingController();

  Future<void> getData() async {
    try {
      loader.init();

      await Future.wait(
          [getGranjas(), getLotesDisponibles(), getProveedores(), getRazas()]);

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

  Future<void> getLotesDisponibles() async {
    final lotes = await apiLiderPollo.getCriaLotesDisponibles();

    setState(() {
      lotesDisponibles = lotes;
    });
  }

  Future<void> getProveedores() async {
    final proveedores = await apiLiderPollo.getProveedores();

    setState(() {
      providers = proveedores;
    });
  }

  Future<void> getRazas() async {
    final razas = await apiLiderPollo.getRazas();

    setState(() {
      breedBirds = razas;
    });
  }

  Future<void> getDataGranja(galponId) async {
    try {
      loader.init();

      availableSheds.text = "";
      selectedGalponControllers = [];
      cantidadMachosControllers = [];
      cantidadHembrasControllers = [];
      selectedordenCompraController.value = null;

      if (galponId == null) return;
      final galpones = await apiLiderPollo.getGalpones(galponId);
      final ordenesResult =
          await apiLiderPollo.getOrdenesRecepcionCrias(galponId);

      if (!mounted) return;
      loader.close();

      setState(() {
        sheds = galpones;
        ordenes = ordenesResult;
      });
    } catch (e) {
      if (!mounted) return;
      loader.close();
    }
  }

  void changeOrden(int? value) {
    if (selectedordenCompraController.value == null) return;
    if (value == null) return;

    final orden = ordenes.firstWhere((element) => element.id == value);

    setState(() {
      selectProveedorController.value = orden.proveedor;
      cantidadAvesHembrasController.text = orden.cantHembras.toString();
      cantidadAvesMachosController.text = orden.cantMachos.toString();
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
      "granja_id": selectedGranjaControllers,
      "orden_compra_id": selectedordenCompraController.value,
      "lote": selectedLoteController.value,
      "proveedor_id": selectProveedorController.value,
      "raza_ave_id": selectRazaController.value,
      "cant_hembras": cantidadAvesHembrasController.text.toInt(),
      "cant_machos": cantidadAvesMachosController.text.toInt(),
      "fecha_despacho": fechaDespachoController.text,
      "fecha_recepcion": fechaRecepcionController.text,
      "peso_reportado":
          pesoReportadoController.text.replaceAll(',', '.').toDouble(),
      "peso_promedio_granja":
          pesoPromedioController.text.replaceAll(',', '.').toDouble(),
      "Distribucion": List.generate(
        selectedGalponControllers.length,
        (index) => {
          "galpon_id": selectedGalponControllers[index].value,
          "cant_hembras": cantidadMachosControllers[index].text,
          "cant_machos": cantidadHembrasControllers[index].text,
        },
      ),
    };

    await apiLiderPollo.setRecepcionCrias(data);
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
                      page: const BreedBirdsDistributionPage());
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
        titleText: RegisterSectionOption.breedingPhase.title,
        subTitleText: "Recepción y ${RegisterOption.birdsDistribution.title}",
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: Vars.gapLow),
          child: Column(children: [
            BottomSelectField(
              // controller: selectedGranjaControllers,
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
                selectedGranjaControllers = value;
                getDataGranja(value);
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
              controller: selectedordenCompraController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Ordenes de Compra",
              hintText: "Seleccionar Orden",
              items: ordenes
                  .map((item) => DropdownMenuItem(
                        value: item.id,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(item.ordenCompra),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                // Maneja la selección aquí
                changeOrden(value);
              },
              dropdownMaxChildSize: .7,
              dropdownInitialChildSize: .7,
              dropdownTitleText: "Orden Compra",
              dropdownSearchLabelText: "Orden Compra",
              dropdownSearchHintText: "Buscar Orden",
              dropdownSearchFunction: (index, item, search) => ordenes[index]
                  .ordenCompra
                  .toUpperCase()
                  .contains(search.toUpperCase()),
            ),
            /* Gap(16.sp).column,
            InputField(
              controller: ordenCompraController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Orden de Compra",
              hintText: "Indicar orden de compra",
            ), */
            /*Gap(16.sp).column,
            InputField(
              controller: loteController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Lote",
              hintText: "Indicar lote",
            ),*/
            Gap(16.sp).column,
            BottomSelectField(
              controller: selectedLoteController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Lotes",
              hintText: "Seleccionar Lote",
              items: lotesDisponibles
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
              dropdownTitleText: "Lotes",
              dropdownSearchLabelText: "Lotes",
              dropdownSearchHintText: "Buscar lote",
              dropdownSearchFunction: (index, item, search) =>
                  lotesDisponibles[index]
                      .lote
                      .toUpperCase()
                      .contains(search.toUpperCase()),
            ),
            Gap(16.sp).column,
            BottomSelectField(
              controller: selectProveedorController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Proveedor",
              hintText: "Seleccione proveedor",
              items: providers
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
              dropdownTitleText: "Proveedor",
              dropdownSearchLabelText: "Proveedor",
              dropdownSearchHintText: "buscar proveedor",
              dropdownSearchFunction: (index, item, search) => providers[index]
                  .name
                  .toUpperCase()
                  .contains(search.toUpperCase()),
            ),
            Gap(16.sp).column,
            BottomSelectField(
              controller: selectRazaController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Raza del Ave",
              hintText: "Seleccione Raza",
              items: breedBirds
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
              dropdownTitleText: "Raza del ave",
              dropdownSearchLabelText: "Raza del ave",
              dropdownSearchHintText: "Buscar raza",
              dropdownSearchFunction: (index, item, search) => breedBirds[index]
                  .name
                  .toUpperCase()
                  .contains(search.toUpperCase()),
            ),
            Gap(16.sp).column,
            InputField(
              controller: cantidadAvesHembrasController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Cant. Aves Hembras",
              hintText: "0",
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            Gap(16.sp).column,
            InputField(
              controller: cantidadAvesMachosController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Cant. Aves Machos",
              hintText: "0",
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            Gap(16.sp).column,
            DatePickerField(
              controller: fechaDespachoController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              firstDate: DateTime.now().subtract(const Duration(days: 150)),
              lastDate: DateTime.now(),
              labelText: "Fecha Despacho del Ave",
              hintText: DateTime.now().formatTime(pattern: "dd/MM/yyyy"),
            ),
            Gap(16.sp).column,
            DatePickerField(
              controller: fechaRecepcionController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              firstDate: DateTime.now().subtract(const Duration(days: 150)),
              lastDate: DateTime.now(),
              labelText: "Fecha Recepción del Ave",
              hintText: DateTime.now().formatTime(pattern: "dd/MM/yyyy"),
            ),
            Gap(16.sp).column,
            InputField(
              controller: pesoReportadoController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Peso reportado del proveedor al entregar",
              hintText: "0",
              numeric: true,
            ),
            Gap(23.sp).column,
            InputField(
              controller: pesoPromedioController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Peso promedio granja",
              hintText: "0",
              numeric: true,
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
            hintText: "seleccionar Galpón",
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
                .toUpperCase()
                .contains(search.toUpperCase()),
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
            hintText: "55",
          ),
        ]));
  }
}
