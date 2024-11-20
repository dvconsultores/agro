import 'dart:developer';

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
import 'package:sap_avicola/widgets/loaders/loader.dart';

class BirdMortalityPage extends StatefulWidget {
  const BirdMortalityPage({
    super.key,
    required this.option,
    required this.optionIndex,
  });
  final RegisterOption option;
  final int optionIndex;

  @override
  State<BirdMortalityPage> createState() => _BirdMortalityPageState();
}

class _BirdMortalityPageState extends State<BirdMortalityPage>
    with ThemesMixin {
  late final loader = AppLoader();
  final apiLiderPollo = ApiLiderPollo();

  final formKey = GlobalKey<FormState>();

  final selectedGranjaController = ValueNotifier<int?>(null);
  final selectedLoteController = ValueNotifier<int?>(null);
  final selectedGalponController = ValueNotifier<int?>(null);

  final fechaController = TextEditingController();
  final cantAvesMuertasController = TextEditingController();
  final cantHembrasMuertasController = TextEditingController();
  final cantMachosMuertosController = TextEditingController();

  var farms = <GranjaModel>[],
      batch = <LoteModel>[],
      sheds = <GalponRecepcionModel>[];

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
    loader.init();

    try {
      if (granjaId == null) {
        loader.close();
        return;
      }
      List<LoteModel>? lote;

      switch (widget.option) {
        case RegisterOption.breedingProcess:
          lote = await apiLiderPollo.getLotesRecepcion(granjaId, "CRIA");
          break;
        case RegisterOption.productionProcess:
          lote = await apiLiderPollo.getLotesRecepcion(granjaId, "PRODUCCION");
          break;
        case RegisterOption.fatteningProcess:
          lote = await apiLiderPollo.getLotesRecepcion(granjaId, "ENGORDE");
          break;
        case RegisterOption():
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

  Future<void> getGalpon(recepcionId) async {
    loader.init();

    try {
      if (recepcionId == null) {
        loader.close();
        return;
      }
      List<GalponRecepcionModel>? galpones;

      switch (widget.option) {
        case RegisterOption.breedingProcess:
          galpones =
              await apiLiderPollo.getGalponesRecepcion(recepcionId, "CRIA");
          break;
        case RegisterOption.productionProcess:
          galpones = await apiLiderPollo.getGalponesRecepcion(
              recepcionId, "PRODUCCION");
          break;
        case RegisterOption.fatteningProcess:
          galpones =
              await apiLiderPollo.getGalponesRecepcion(recepcionId, "ENGORDE");
          break;
        case RegisterOption():
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

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      getData();
    });

    super.initState();
  }

  Future<void> guardar() async {
    final data = {
      "fecha": fechaController.text,
      "recepcion_id": selectedLoteController.value,
      "galpon_distribucion_id": selectedGalponController.value,
      "cantidad_muertas": cantAvesMuertasController.text,
      "cant_hembras": cantHembrasMuertasController.text,
      "cant_machos": cantMachosMuertosController.text,
    };

    switch (widget.option) {
      case RegisterOption.breedingProcess:
        await apiLiderPollo.setMortalidad(data, "CRIA");
        break;
      case RegisterOption.productionProcess:
        await apiLiderPollo.setMortalidad(data, "PRODUCCION");
        break;
      case RegisterOption.fatteningProcess:
        await apiLiderPollo.setMortalidad(data, "ENGORDE");
        break;
      case RegisterOption():
        throw "Error al guardar";
    }
  }

  Future<void> registerHandler() async {
    if (!formKey.currentState!.validate()) return;

    final accepts = await Modal.showAlertToContinue(
      context,
      icon: widget.option.icon is IconData
          ? Icon(widget.option.icon, size: 25)
          : Image.asset(widget.option.icon, height: 25),
      titleText: "¿Deseas guardar el registro?",
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
            descText: "El registro de mortalidad fue guardado con éxito",
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
                      page: BirdMortalityPage(
                        option: widget.option,
                        optionIndex: widget.optionIndex,
                      ));
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
          titleText: "Error al sincronizar",
          contentText: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    log(widget.option.name);

    return AppScaffold(
      appBar: CustomAppBar(
        titleText: widget.option.children[widget.optionIndex],
        subTitleText: widget.option.title,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: Vars.gapLow),
          child: Column(children: [
            DatePickerField(
              controller: fechaController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              firstDate: DateTime.now().subtract(const Duration(days: 150)),
              lastDate: DateTime.now(),
              labelText: "Fecha",
              hintText: DateTime.now().formatTime(pattern: "dd/MM/yyyy"),
            ),
            Gap(16.sp).column,
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
            if (widget.option == RegisterOption.breedingProcess ||
                widget.option == RegisterOption.productionProcess)
              InputField(
                controller: cantHembrasMuertasController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => ValidatorField.evaluate(
                    value, (instance) => [instance.required]),
                labelText: "Cant. Hembras Muertas",
                hintText: "0",
                keyboardType:
                    const TextInputType.numberWithOptions(signed: true),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            Gap(16.sp).column,
            InputField(
              controller: cantMachosMuertosController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Cant. Machos Muertos",
              hintText: "0",
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            if (widget.option == RegisterOption.fatteningProcess)
              InputField(
                controller: cantAvesMuertasController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => ValidatorField.evaluate(
                    value, (instance) => [instance.required]),
                labelText: "Cant. Aves Muertas",
                hintText: "0",
                keyboardType:
                    const TextInputType.numberWithOptions(signed: true),
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
