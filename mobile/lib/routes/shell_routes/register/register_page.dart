import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sap_avicola/models/register_option_model.dart';
import 'package:sap_avicola/models/rol_user_model.dart';
import 'package:sap_avicola/repositories/api_lider_pollo.dart';
import 'package:sap_avicola/utils/general/variables.dart';
import 'package:sap_avicola/widgets/defaults/app_bar.dart';
import 'package:sap_avicola/widgets/defaults/scaffold.dart';
import 'package:sap_avicola/widgets/item_list_widget.dart';
import 'package:sap_avicola/widgets/loaders/loader.dart';
import 'package:sap_avicola/widgets/sheets/card_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final loader = AppLoader();
  final apiLiderPollo = ApiLiderPollo();

  List<RolUserModel> rolesActives = [];

  Future<void> getData() async {
    try {
      loader.init();

      final roles = await apiLiderPollo.getRolUser();
      rolesActives = roles;

      loader.close();
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      goHomeOnBack: true,
      padding: const EdgeInsets.all(0),
      appBar: CustomAppBar(
        titleText: "Registro de datos",
        subTitleText: "Selecciona",
        onPop: () => context.goNamed("home"),
      ),
      body: ListView.separated(
        padding: Vars.paddingScaffold,
        itemCount: RegisterSectionOption.values.length,
        separatorBuilder: (context, index) => Gap(16.sp).column,
        itemBuilder: (context, index) {
          final section = RegisterSectionOption.values[index];

          bool foundModulo = rolesActives.any((role) {
            return role.enumOption == section && role.isActive;
          });

          if (foundModulo) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(section.title, style: theme.textTheme.bodyLarge),
                  Gap(8.sp).column,
                  CardWidgetV2(
                    padding: const EdgeInsets.all(0),
                    border: Border(
                        top: BorderSide(
                      width: 13.sp,
                      color: section.color,
                    )),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: section.options.length,
                      separatorBuilder: (context, i) =>
                          const Divider(height: 1, color: Color(0xFFE3E1EC)),
                      itemBuilder: (context, i) {
                        final option = section.options[i];

                        List<RolUserModel> submodulosList = rolesActives
                            .where((element) =>
                                element.enumOption == section &&
                                element.isActive)
                            .toList();
                        bool foundSubModulo =
                            submodulosList.first.subModulos.any((item) {
                          return item == option;
                        }); //contains(option);

                        /*print(
                            "section: $section - option: $option - founfSubmodulo: $foundSubModulo - submodulo: $submodulosList.first.subModulos");
*/
                        /*rolesActives.any((role) {
                          return role.enumOption == section &&
                              role.isActive && role.subModulos.contains(option);
                        });*/

                        if (foundSubModulo) {
                          return ItemList(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Vars.gapLarge,
                            ),
                            height: 40.sp,
                            name: option.title,
                            icon: option.icon,
                            onTap: () => RegisterOption.onTapItemRegister(
                              section: section,
                              option: option,
                              processActive: submodulosList.first.process,
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ]);
          }
          return const SizedBox();
        },
      ),
    );
  }
}
