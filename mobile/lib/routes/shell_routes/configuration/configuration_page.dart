import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sap_avicola/utils/general/variables.dart';
import 'package:sap_avicola/utils/services/local_data/hive_data_service.dart';
import 'package:sap_avicola/widgets/defaults/app_bar.dart';
import 'package:sap_avicola/widgets/defaults/scaffold.dart';
import 'package:sap_avicola/widgets/form_fields/switch_field.dart';
import 'package:sap_avicola/widgets/sheets/card_widget.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final biometric = ValueNotifier<bool>(false);

  enabledDisabledBiometric(value) {
    HiveData.write(HiveDataCollection.biometrics, value);
  }

  getData() {
    setState(() {
      biometric.value = HiveData.read(HiveDataCollection.biometrics) ?? false;
    });
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
    final options = [
      {
        "title": "Biometría",
        "desc": "Activa las opciones de biometría de tu dispositivo",
        "widget": SwitchField(
            controller: biometric,
            onChanged: (value) => enabledDisabledBiometric(value)),
      },
      /*{
        "title": "Contraseña",
        "desc": "Cambiar contraseña de inicio",
        "widget": const Icon(Icons.chevron_right_rounded),
        "onTap": () {},
      },*/
    ];

    return AppScaffold(
      goHomeOnBack: true,
      appBar: CustomAppBar(
        titleText: "Configuración",
        onPop: () => context.goNamed("home"),
      ),
      padding: const EdgeInsets.all(0),
      body: ListView.separated(
        padding: Vars.paddingScaffold,
        itemCount: options.length,
        separatorBuilder: (context, index) => Gap(16.sp).column,
        itemBuilder: (context, index) => _OptionCard(
          title: options[index]['title'] as String,
          desc: options[index]['desc'] as String,
          trailling: options[index]['widget'] as Widget,
          onTap: options[index]['onTap'] as VoidCallback?,
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.title,
    required this.desc,
    required this.trailling,
    this.onTap,
  });
  final String title;
  final String desc;
  final Widget trailling;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      onTap: onTap,
      padding: const EdgeInsets.all(Vars.gapLarge),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            )),
        Gap(4.sp).column,
        Row(children: [
          Expanded(
            child: Text(desc,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                )),
          ),
          const Gap(Vars.gapXLarge).row,
          trailling,
        ]),
      ]),
    );
  }
}
