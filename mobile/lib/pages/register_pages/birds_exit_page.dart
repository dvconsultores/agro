import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sap_avicola/models/galpon_recepcion_model.dart';
import 'package:sap_avicola/models/granja_model.dart';
import 'package:sap_avicola/models/lote_model.dart';
import 'package:sap_avicola/models/orden_salida_aves_model.dart';
import 'package:sap_avicola/models/planta_beneficio_model.dart';
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

class BirdsExitPage extends StatefulWidget {
  const BirdsExitPage({super.key, required this.section});
  final RegisterSectionOption section;

  @override
  State<BirdsExitPage> createState() => _BirdsExitPageState();
}

class _BirdsExitPageState extends State<BirdsExitPage> with ThemesMixin {
  late final loader = AppLoader();
  final apiLiderPollo = ApiLiderPollo();

  final formKey = GlobalKey<FormState>();

  final selectedGranjaController = ValueNotifier<int?>(null);
  final selectedGalponController = ValueNotifier<int?>(null);
  final selectedDestinoController = ValueNotifier<int?>(null);
  final selectedTransporteController = ValueNotifier<int?>(null);
  final selectedLoteController = ValueNotifier<int?>(null);
  final selectedOrdenSalidaController = ValueNotifier<int?>(null);

  final fechaSalidaController = TextEditingController();
  final cantAvesController = TextEditingController();
  final pesoPromedioController = TextEditingController();
  final placaTransporteController = TextEditingController();
  String avesDisponibles = "0";

  var farms = <GranjaModel>[],
      batch = <LoteModel>[],
      sheds = <GalponRecepcionModel>[],
      beneficiationPlant = <PlantaBeneficioModel>[],
      transport = <TransporteModel>[],
      ordenes = <OrdenSalidaAvesModel>[];

  Future<void> getData() async {
    try {
      loader.init();
      await Future.wait(
          [getGranjas(), getTransportes(), getPlantasBeneficio()]);
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

  Future<void> getPlantasBeneficio() async {
    final plantas = await apiLiderPollo.getPlantasBeneficio();

    setState(() {
      beneficiationPlant = plantas;
    });
  }

  Future<void> getTransportes() async {
    final transportes = await apiLiderPollo.getTransportes();

    setState(() {
      transport = transportes;
    });
  }

  Future<void> getDataGranja(granjaId) async {
    try {
      loader.init();

      selectedOrdenSalidaController.value = null;
      selectedLoteController.value = null;
      selectedGalponController.value = null;

      if (granjaId == null) {
        loader.close();
        return;
      }
      List<LoteModel>? lote;
      List<OrdenSalidaAvesModel>? ordenList;

      switch (widget.section) {
        case RegisterSectionOption.breedingPhase:
          {
            ordenList = await apiLiderPollo.getOrdenesSalida(granjaId, "CRIA");
            lote = await apiLiderPollo.getLotesRecepcion(granjaId, "CRIA");
          }

          break;
        case RegisterSectionOption.reproductiveProductionPhase:
          {
            ordenList =
                await apiLiderPollo.getOrdenesSalida(granjaId, "PRODUCCION");
            lote =
                await apiLiderPollo.getLotesRecepcion(granjaId, "PRODUCCION");
          }
          break;
        case RegisterSectionOption.reproductiveFatteningPhase:
          {
            ordenList =
                await apiLiderPollo.getOrdenesSalida(granjaId, "ENGORDE");
            lote = await apiLiderPollo.getLotesRecepcion(granjaId, "ENGORDE");
          }
          break;
        case RegisterSectionOption():
          {
            ordenList = null;
            lote = null;
          }
          break;
      }

      if (lote == null) {
        loader.close();
        return;
      }

      loader.close();

      setState(() {
        batch = lote!;
        ordenes = ordenList!;
      });
    } catch (e) {
      loader.close();
    }
  }

  changeOrdenSalida(int? value) {
    if (selectedOrdenSalidaController.value == null) return;
    if (value == null) return;

    final orden = ordenes.firstWhere((element) => element.id == value);

    setState(() {
      cantAvesController.text = orden.cantidadAves;
      selectedDestinoController.value = orden.destinoId;
      selectedTransporteController.value = orden.transporteId;
    });
  }

  Future<void> getGalpon(recepcionId) async {
    if (selectedLoteController.value == null) return;
    setState(() {
      avesDisponibles = "0";
    });

    loader.init();

    try {
      if (recepcionId == null) {
        loader.close();
        return;
      }

      List<GalponRecepcionModel>? galpones;

      switch (widget.section) {
        case RegisterSectionOption.breedingPhase:
          galpones =
              await apiLiderPollo.getGalponesRecepcion(recepcionId, "CRIA");
          break;
        case RegisterSectionOption.reproductiveProductionPhase:
          galpones = await apiLiderPollo.getGalponesRecepcion(
              recepcionId, "PRODUCCION");
          break;
        case RegisterSectionOption.reproductiveFatteningPhase:
          galpones =
              await apiLiderPollo.getGalponesRecepcion(recepcionId, "ENGORDE");
          break;
        case RegisterSectionOption():
          galpones = null;
          break;
      }

      if (galpones == null) {
        loader.close();
        return;
      }

      loader.close();

      setState(() {
        sheds = galpones!;
      });
    } catch (e) {
      loader.close();
    }
  }

  changeGalpon(int? value) {
    if (selectedGalponController.value == null) return;
    if (value == null) return;

    final galpon = sheds.firstWhere((element) => element.id == value);

    setState(() {
      avesDisponibles = galpon.disponible.toString();
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
      "orden_id": selectedOrdenSalidaController.value,
      "recepcion_id": selectedLoteController.value,
      "galpon_distribucion_id": selectedGalponController.value,
      "fecha_salida": fechaSalidaController.text,
      "cant_aves": cantAvesController.text,
      //"peso_promedio": pesoPromedioController.text.replaceAll(',', '.'),
      "destino_id": selectedDestinoController.value,
      "transporte_id": selectedTransporteController.value,
      "placa_transporte": placaTransporteController.text,
    };

    switch (widget.section) {
      case RegisterSectionOption.breedingPhase:
        await apiLiderPollo.setSalidaAvesCrias(data);
        break;
      case RegisterSectionOption.reproductiveProductionPhase:
        await apiLiderPollo.setSalidaAvesProduccion(data);
        break;
      case RegisterSectionOption.reproductiveFatteningPhase:
        await apiLiderPollo.setSalidaAvesEngorde(data);
        break;
      case RegisterSectionOption():
        throw "Error al guardar";
    }
  }

  Future<void> declareHandler() async {
    if (!formKey.currentState!.validate()) return;

    final accepts = await Modal.showAlertToContinue(
      context,
      icon: Image.asset(RegisterOption.birdExit.icon, height: 25),
      titleText: "¿Deseas declarar la salida de aves?",
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
                      page: BirdsExitPage(section: widget.section));
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
        subTitleText: RegisterOption.birdExit.title,
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
              controller: selectedOrdenSalidaController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Orden salida",
              hintText: "Seleccionar Orden salida",
              items: ordenes
                  .map((item) => DropdownMenuItem(
                        value: item.id,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(item.numOrden),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                // Maneja la selección aquí
                changeOrdenSalida(value);
              },
              dropdownMaxChildSize: .7,
              dropdownInitialChildSize: .7,
              dropdownTitleText: "Orden salida",
              dropdownSearchLabelText: "Orden salida",
              dropdownSearchHintText: "Buscar Orden salida",
              dropdownSearchFunction: (index, item, search) => ordenes[index]
                  .numOrden
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
              hintText: "Seleccionar Galpón",
              items: sheds
                  .map((item) => DropdownMenuItem(
                        value: item.id,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(item.galpon),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                changeGalpon(value);
              },
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
            InputField(
              controller: cantAvesController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Cant. de Aves",
              hintText: "0",
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            Text("Aves disponibles en el galpon: $avesDisponibles"),
            /*if (widget.section.name ==
                RegisterSectionOption.reproductiveFatteningPhase.name) ...[
              Gap(16.sp).column,
              InputField(
                controller: pesoPromedioController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => ValidatorField.evaluate(
                    value, (instance) => [instance.required]),
                labelText: "Peso Prom. del Ave al Salir de Granja",
                hintText: "0",
                keyboardType:
                    const TextInputType.numberWithOptions(signed: true),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],*/
            Gap(16.sp).column,
            if (widget.section.name == RegisterSectionOption.breedingPhase.name)
              BottomSelectField(
                controller: selectedDestinoController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => ValidatorField.evaluate(
                    value, (instance) => [instance.required]),
                labelText: "Granja de Producción",
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
                dropdownTitleText: "Granja de Producción",
                dropdownSearchLabelText: "Granja de Producción",
                dropdownSearchHintText: "Burcar Granja",
                dropdownSearchFunction: (index, item, search) => farms[index]
                    .name
                    .toUpperCase()
                    .contains(search.toUpperCase()),
              )
            else
              BottomSelectField(
                controller: selectedDestinoController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => ValidatorField.evaluate(
                    value, (instance) => [instance.required]),
                labelText: "Planta de Beneficio",
                hintText: "Seleccione Planta",
                items: beneficiationPlant
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
                dropdownTitleText: "Planta de Beneficio",
                dropdownSearchLabelText: "Planta de Beneficio",
                dropdownSearchHintText: "Buscar Planta",
                dropdownSearchFunction: (index, item, search) =>
                    beneficiationPlant[index]
                        .name
                        .toUpperCase()
                        .contains(search.toUpperCase()),
              ),
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
