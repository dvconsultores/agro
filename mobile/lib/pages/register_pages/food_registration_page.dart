import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sap_avicola/models/granja_model.dart';
import 'package:sap_avicola/models/lote_model.dart';
import 'package:sap_avicola/models/orden_alimento_model.dart';
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

class FoodRegistrationPage extends StatefulWidget {
  const FoodRegistrationPage({
    super.key,
    required this.option,
    required this.optionIndex,
  });
  final RegisterOption option;
  final int optionIndex;

  @override
  State<FoodRegistrationPage> createState() => _FoodRegistrationPageState();
}

class _FoodRegistrationPageState extends State<FoodRegistrationPage>
    with ThemesMixin {
  late final loader = AppLoader();
  final apiLiderPollo = ApiLiderPollo();

  final formKey = GlobalKey<FormState>();

  final selectedGranjaControllers = ValueNotifier<int?>(null);
  final loteController = ValueNotifier<int?>(null);
  final selectedOrdenController = ValueNotifier<int?>(null);

  var farms = <GranjaModel>[],
      batch = <LoteModel>[],
      ordenTransferencia = <OrdenAlimentoModel>[];

  final fechaController = TextEditingController();
  final fechaTransferenciaController = TextEditingController();
  final codigoAlimentoController = TextEditingController();
  final cantidadController = TextEditingController();
  final tipoAlimentoController = TextEditingController();

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
    loader.init();

    try {
      loteController.value = null;
      selectedOrdenController.value = null;

      if (granjaId == null) {
        loader.close();
        return;
      }
      List<LoteModel>? lote;
      List<OrdenAlimentoModel>? ordenes;

      switch (widget.option) {
        case RegisterOption.breedingProcess:
          {
            lote = await apiLiderPollo.getLotesRecepcion(granjaId, "CRIA");
            ordenes = await apiLiderPollo.getOrdenesAlimento(granjaId, "CRIA");
          }
          break;
        case RegisterOption.productionProcess:
          {
            lote =
                await apiLiderPollo.getLotesRecepcion(granjaId, "PRODUCCION");
            ordenes =
                await apiLiderPollo.getOrdenesAlimento(granjaId, "PRODUCCION");
          }
          break;
        case RegisterOption.fatteningProcess:
          {
            lote = await apiLiderPollo.getLotesRecepcion(granjaId, "ENGORDE");
            ordenes =
                await apiLiderPollo.getOrdenesAlimento(granjaId, "ENGORDE");
          }
          break;
        case RegisterOption():
          lote = null;
          break;
      }

      if (lote == null || ordenes == null) {
        loader.close();
        return;
      }

      loader.close();

      setState(() {
        batch = lote!;
        ordenTransferencia = ordenes!;
      });
    } catch (e) {
      loader.close();
    }
  }

  void changeOrden(int? value) {
    if (selectedOrdenController.value == null) return;
    if (value == null) return;

    final orden =
        ordenTransferencia.firstWhere((element) => element.id == value);

    setState(() {
      tipoAlimentoController.text = orden.tipoAlimento;
      codigoAlimentoController.text = orden.codigoAlimento;
      cantidadController.text = orden.cantidadKg.toString();
    });
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      getData();
    });

    super.initState();
  }

  Future<void> setAlimentoCrias() async {
    final data = {
      "recepcion_id": loteController.value,
      "fecha": fechaController.text,
      "orden_transferencia_id": selectedOrdenController.value,
      "fecha_transferencia": fechaTransferenciaController.text,
      "cantidad": cantidadController.text,
    };

    switch (widget.option) {
      case RegisterOption.breedingProcess:
        await apiLiderPollo.setAlimento(data, "CRIA");
        break;
      case RegisterOption.productionProcess:
        await apiLiderPollo.setAlimento(data, "PRODUCCION");
        break;
      case RegisterOption.fatteningProcess:
        await apiLiderPollo.setAlimento(data, "ENGORDE");
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
      await setAlimentoCrias();

      if (!mounted) return;
      loader.close();

      Nav.pushReplacement(context,
          hideBottomNavigationBar: true,
          page: OperationStatePage(
            operationState: OperationStateType.success,
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
                      page: FoodRegistrationPage(
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
            BottomSelectField(
              controller: selectedGranjaControllers,
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
                //getLote(value);
              },
              dropdownMaxChildSize: .7,
              dropdownInitialChildSize: .7,
              dropdownTitleText: "Granjas",
              dropdownSearchLabelText: "Granja",
              dropdownSearchHintText: "Buscar Granja",
              dropdownSearchFunction: (index, item, search) => farms[index]
                  .name
                  .toLowerCase()
                  .contains(search.toLowerCase()),
            ),
            Gap(16.sp).column,
            BottomSelectField(
              controller: selectedOrdenController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Orden Transferencia",
              hintText: "Seleccione orden de transferencia",
              items: ordenTransferencia
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
                changeOrden(value);
              },
              dropdownMaxChildSize: .7,
              dropdownInitialChildSize: .7,
              dropdownTitleText: "Orden Transferencia",
              dropdownSearchLabelText: "Orden Transferencia",
              dropdownSearchHintText: "Buscar orden de transferencia",
              dropdownSearchFunction: (index, item, search) =>
                  ordenTransferencia[index]
                      .numOrden
                      .toLowerCase()
                      .contains(search.toLowerCase()),
            ),
            Gap(16.sp).column,
            BottomSelectField(
              controller: loteController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Lote",
              hintText: "Indique lote",
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
              dropdownSearchHintText: "Buscar lote",
              dropdownSearchFunction: (index, item, search) => batch[index]
                  .lote
                  .toLowerCase()
                  .contains(search.toLowerCase()),
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
              hintText: DateTime.now().formatTime(pattern: "dd/MM/yyyy"),
            ),
            Gap(16.sp).column,
            DatePickerField(
              controller: fechaTransferenciaController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              firstDate: DateTime.now().subtract(const Duration(days: 150)),
              lastDate: DateTime.now(),
              labelText: "Fecha transferencia de planta a granja",
              hintText: DateTime.now().formatTime(pattern: "dd/MM/yyyy"),
            ),
            Gap(16.sp).column,
            InputField(
              controller: codigoAlimentoController,
              disabled: true,
              labelText: "Código de alimento",
              hintText: "",
            ),
            Gap(16.sp).column,
            InputField(
              controller: tipoAlimentoController,
              disabled: true,
              labelText: "Tipo de alimento",
              hintText: "",
            ),
            Gap(16.sp).column,
            InputField(
              controller: cantidadController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => ValidatorField.evaluate(
                  value, (instance) => [instance.required]),
              labelText: "Cantidad",
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
