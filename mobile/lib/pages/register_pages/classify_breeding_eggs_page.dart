import 'package:collection/collection.dart';
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
import 'package:sap_avicola/widgets/loaders/loader.dart';
import 'package:sap_avicola/widgets/sheets/card_widget.dart';

class ClassifyBreedingEggsPage extends StatefulWidget {
  const ClassifyBreedingEggsPage({super.key});

  @override
  State<ClassifyBreedingEggsPage> createState() =>
      _ClassifyBreedingEggsPageState();
}

class _ClassifyBreedingEggsPageState extends State<ClassifyBreedingEggsPage>
    with SingleTickerProviderStateMixin, ThemesMixin {
  late final loader = AppLoader();
  final apiLiderPollo = ApiLiderPollo();

  final formKey = GlobalKey<FormState>();

  late final AnimationController batchAnimationController;
  final batchControler = ValueNotifier<String?>(null);

  var unclassifiedBreedingEggs =
      <LoteIncubadoraModel>[]; /*[
    {
      "id": "",
      "lote": "Lote 1",
      "granjaOrigen": "Granja 1",
      "cantidad": "321",
      "fechaRecepcion": "17/07/2024",
    },
    {
      "key": "Lote 2",
      "farm": "Granja 2",
      "receivedAmount": "322",
      "receptionDate": "17/07/2023",
    },
  ];*/

  final fechaClasificacionController = TextEditingController();
  final cantidadFertilesController = TextEditingController();
  final cantidadSuciosController = TextEditingController();
  final cantidadInfertilesController = TextEditingController();
  final cantidadDescartadosController = TextEditingController();
  final pesoPromedioHuevoController = TextEditingController();

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
        await apiLiderPollo.getLotesRecepcionIncubadora(0, "RECEPCIONADO");

    setState(() {
      unclassifiedBreedingEggs = lotes;
    });
  }

  Future<void> guardar() async {
    final data = {
      "recepcion_id": batchControler.value,
      "fecha_clasificacion": fechaClasificacionController.text,
      "cant_huevos_fertiles": cantidadFertilesController.text,
      "cant_huevos_sucios": cantidadSuciosController.text,
      "cant_huevos_infertiles": cantidadInfertilesController.text,
      "cant_huevos_descartados": cantidadDescartadosController.text,
      "peso_prom_huevos": pesoPromedioHuevoController.text,
    };

    await apiLiderPollo.setClasificacionIncubadora(data);
  }

  Future<void> classifyHandler() async {
    if (!formKey.currentState!.validate()) return;

    final accepts = await Modal.showAlertToContinue(
      context,
      icon: Image.asset("assets/icons/eggs.svg", height: 25),
      titleText: "¿Deseas clasificar los huevos?",
      textCancelBtn: "No, cancelar",
      textConfirmBtn: "Si, clasificar",
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
            titleText: "¡Clasificado con éxito!",
            descText: "Los huevos fueron clasificado con éxito",
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
                      page: const ClassifyBreedingEggsPage());
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
    batchAnimationController = AnimationController(
      vsync: this,
      duration: Durations.short4,
    );
    super.initState();
  }

  @override
  void dispose() {
    batchAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        titleText: RegisterSectionOption.incubator.title,
        subTitleText: RegisterOption.sortEggs.title,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: Vars.gapLow),
          child: Column(children: [
            BottomSelectField(
              labelText: "Identificación de Lote",
              hintText: "Seleccione lote",
              controller: batchControler,
              onChanged: (value) {
                setState(() {});

                value != null
                    ? batchAnimationController.forward()
                    : batchAnimationController.reverse();
              },
              items: unclassifiedBreedingEggs
                  .map((item) => DropdownMenuItem(
                        value: item.id.toString(),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(item.lote),
                        ),
                      ))
                  .toList(),
              dropdownMaxChildSize: .7,
              dropdownInitialChildSize: .7,
              dropdownTitleText: "Lotes sin clasificar",
              dropdownSearchLabelText: "Identificación de Lote",
              dropdownSearchHintText: "Busacar lote",
              dropdownSearchFunction: (index, item, search) =>
                  unclassifiedBreedingEggs[index]
                      .lote
                      .toUpperCase()
                      .contains(search.toUpperCase()),
            ),
            Gap(10.sp).column,
            AnimatedBuilder(
                animation: batchAnimationController,
                builder: (context, child) {
                  final translate = Tween<double>(
                    begin: 1,
                    end: 0,
                  ).animate(batchAnimationController);

                  return Column(children: [
                    Transform.translate(
                      offset: Offset(media.size.width * translate.value, 0),
                      child: _BatchPreview(unclassifiedBreedingEggs
                          .where((element) =>
                              element.id.toString() == batchControler.value)
                          .firstOrNull),
                    ),
                    Gap(20.sp).column,
                    Transform.translate(
                      offset: Offset(0, media.size.height * translate.value),
                      child: _BatchFields(
                        fechaClasificacionController:
                            fechaClasificacionController,
                        cantidadFertilesController: cantidadFertilesController,
                        cantidadSuciosController: cantidadSuciosController,
                        cantidadInfertilesController:
                            cantidadInfertilesController,
                        cantidadDescartadosController:
                            cantidadDescartadosController,
                        pesoPromedioHuevoController:
                            pesoPromedioHuevoController,
                      ),
                    ),
                  ]);
                }),
          ]),
        ),
      ),
      bottomWidget: Button(
        margin: Vars.paddingScaffold,
        text: "Clasificar",
        onPressed: classifyHandler,
      ),
    );
  }
}

class _BatchPreview extends StatelessWidget {
  const _BatchPreview(this.batch);
  final LoteIncubadoraModel? batch;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
        color: const Color(0xFFFBFBFB),
        border: Border.all(color: Theme.of(context).dividerTheme.color!),
        boxShadow: const [],
        child: Column(children: [
          InputField(
            disabled: true,
            labelText: "Granja",
            controller: TextEditingController(text: batch?.granjaOrigen),
          ),
          Gap(16.sp).column,
          InputField(
            disabled: true,
            labelText: "Cantidad Recibida",
            controller: TextEditingController(text: batch?.cantidad.toString()),
          ),
          Gap(16.sp).column,
          InputField(
            disabled: true,
            labelText: "Fecha de Recepción",
            controller: TextEditingController(text: batch?.fechaRecepcion),
          ),
        ]));
  }
}

class _BatchFields extends StatelessWidget {
  const _BatchFields(
      {required this.fechaClasificacionController,
      required this.cantidadFertilesController,
      required this.cantidadSuciosController,
      required this.cantidadInfertilesController,
      required this.cantidadDescartadosController,
      required this.pesoPromedioHuevoController});

  final TextEditingController fechaClasificacionController;
  final TextEditingController cantidadFertilesController;
  final TextEditingController cantidadSuciosController;
  final TextEditingController cantidadInfertilesController;
  final TextEditingController cantidadDescartadosController;
  final TextEditingController pesoPromedioHuevoController;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      DatePickerField(
        controller: fechaClasificacionController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) =>
            ValidatorField.evaluate(value, (instance) => [instance.required]),
        labelText: "Fecha de Clasificación",
        hintText: DateTime.now().formatTime(pattern: "dd/MM/yyyy"),
        firstDate: DateTime.now().subtract(const Duration(days: 150)),
        lastDate: DateTime.now(),
      ),
      Gap(16.sp).column,
      InputField(
        controller: cantidadFertilesController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) =>
            ValidatorField.evaluate(value, (instance) => [instance.required]),
        labelText: "Cant. Huevos Fértiles",
        hintText: "0",
        keyboardType: const TextInputType.numberWithOptions(signed: true),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
      Gap(16.sp).column,
      InputField(
        controller: cantidadSuciosController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) =>
            ValidatorField.evaluate(value, (instance) => [instance.required]),
        labelText: "Cant. Huevos Sucios",
        hintText: "0",
        keyboardType: const TextInputType.numberWithOptions(signed: true),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
      Gap(16.sp).column,
      InputField(
        controller: cantidadInfertilesController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) =>
            ValidatorField.evaluate(value, (instance) => [instance.required]),
        labelText: "Cant. Huevos Infértiles",
        hintText: "0",
        keyboardType: const TextInputType.numberWithOptions(signed: true),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
      Gap(16.sp).column,
      InputField(
        controller: cantidadDescartadosController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) =>
            ValidatorField.evaluate(value, (instance) => [instance.required]),
        labelText: "Cant. Huevos Descartados",
        hintText: "0",
        keyboardType: const TextInputType.numberWithOptions(signed: true),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
      Gap(16.sp).column,
      InputField(
        controller: pesoPromedioHuevoController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) =>
            ValidatorField.evaluate(value, (instance) => [instance.required]),
        labelText: "Peso Promedio de Huevo (Grs)",
        hintText: "0",
        numeric: true,
      ),
      const Gap(Vars.gapMax * 3).column,
    ]);
  }
}
