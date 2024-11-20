import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sap_avicola/models/incubadora_model.dart';
import 'package:sap_avicola/models/register_option_model.dart';
import 'package:sap_avicola/pages/register_pages/operation_state_page.dart';
import 'package:sap_avicola/repositories/api_lider_pollo.dart';
import 'package:sap_avicola/utils/config/router_config.dart';
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

class IncubatorInspectionPage extends StatefulWidget {
  const IncubatorInspectionPage({super.key});

  @override
  State<IncubatorInspectionPage> createState() =>
      _IncubatorInspectionPageState();
}

class _IncubatorInspectionPageState extends State<IncubatorInspectionPage>
    with ThemesMixin {
  final apiLiderPollo = ApiLiderPollo();
  final loader = AppLoader();

  final selectedIncubadoraControllers = ValueNotifier<int?>(null);
  var incubadoras = <IncubadoraModel>[];

  final formKey = GlobalKey<FormState>();
  final fechaInspeccionController = TextEditingController();
  final temperaturaController = TextEditingController();
  final humedadController = TextEditingController();
  String ventilacionInput = "";

  Future<void> getIncubadora() async {
    loader.init();
    final incubadoraList = await apiLiderPollo.getIncubadoras();

    loader.close();

    setState(() {
      incubadoras = incubadoraList;
    });
  }

  Future<bool> registerInspeccion() async {
    //validar campos
    /*if (selectedIncubadoraControllers.value == null ||
        fechaRecepcionController.text.isEmpty ||
        temperaturaController.text.isEmpty ||
        humedadController.text.isEmpty
    )*/

    final data = {
      "incubadora_id": selectedIncubadoraControllers.value,
      "fecha_inspeccion": fechaInspeccionController.text,
      "temperatura": temperaturaController.text,
      "humedad": humedadController.text,
      "ventilacion": ventilacionInput.toUpperCase(),
    };

    try {
      loader.init();
      final result = await apiLiderPollo.setInspeccionIncubadora(data);
      if (!result) throw Exception("Error al registrar la inspección");
      loader.close();
      return true;
    } catch (e) {
      loader.close();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
      return false;
    }
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      getIncubadora();
    });

    super.initState();
  }

  Future<void> registerHandler() async {
    if (!formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos.')),
      );
      return;
    }

    final accepts = await Modal.showAlertToContinue(
      context,
      icon: SvgPicture.asset("assets/icons/incubator.svg", height: 25),
      titleText: "¿Deseas registrar la Inspección?",
      textCancelBtn: "No, cancelar",
      textConfirmBtn: "Si, confirmar",
    );
    if (accepts != true || !context.mounted) return;

    final resultRegister = await registerInspeccion();

    if (!resultRegister && !mounted) return;

    Nav.pushReplacement(context,
        hideBottomNavigationBar: true,
        page: OperationStatePage(
          operationState: OperationStateType.success,
          titleText: "¡Registro exitoso!",
          descText:
              "La Inspección de la Incubadora ha sido registrada con éxito",
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
                    page: const IncubatorInspectionPage());
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
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        titleText: RegisterSectionOption.incubator.title,
        subTitleText: RegisterOption.incubatorInspect.title,
      ),
      body: Form(
        key: formKey,
        child: ListView(
            padding: const EdgeInsets.only(top: Vars.gapLow),
            children: [
              BottomSelectField(
                controller: selectedIncubadoraControllers,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => ValidatorField.evaluate(
                    value, (instance) => [instance.required]),
                labelText: "Incubadora",
                hintText: "Seleccionar incubadora",
                items: incubadoras
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
                  selectedIncubadoraControllers.value = value;
                },
                dropdownMaxChildSize: .7,
                dropdownInitialChildSize: .7,
                dropdownTitleText: "Incubadora",
                dropdownSearchLabelText: "Incubadora",
                dropdownSearchHintText: "Buscar incubadora",
                dropdownSearchFunction: (index, dynamic item, search) =>
                    incubadoras[index]
                        .name
                        .toLowerCase()
                        .contains(search.toLowerCase()),
              ),
              Gap(16.sp).column,
              DatePickerField(
                controller: fechaInspeccionController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => ValidatorField.evaluate(
                    value, (instance) => [instance.required]),
                firstDate: DateTime.now().subtract(const Duration(days: 150)),
                lastDate: DateTime.now(),
                labelText: "Fecha de Inspección",
                hintText: DateTime.now().formatTime(pattern: 'dd/MM/yyyy'),
              ),
              Gap(20.sp).column,
              InputField(
                controller: temperaturaController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => ValidatorField.evaluate(
                    value, (instance) => [instance.required]),
                labelText: "Temperatura",
                hintText: "38°",
              ),
              Gap(20.sp).column,
              InputField(
                controller: humedadController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => ValidatorField.evaluate(
                    value, (instance) => [instance.required]),
                labelText: "Humedad",
                hintText: "22°",
              ),
              Gap(20.sp).column,
              BottomSelectField(
                labelText: "Ventilación",
                hintText: "Adecuado",
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => ValidatorField.evaluate(
                    value, (instance) => [instance.required]),
                items: ["Adecuado", "No Adecuado"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                dropdownMaxChildSize: .4,
                dropdownInitialChildSize: .4,
                onChanged: (value) {
                  ventilacionInput = value.toString();
                },
              ),
              const Gap(Vars.gapMax * 3).column,
            ]),
      ),
      bottomWidget: Button(
        margin: Vars.paddingScaffold,
        text: "Registrar Inspección",
        onPressed: registerHandler,
      ),
    );
  }
}
