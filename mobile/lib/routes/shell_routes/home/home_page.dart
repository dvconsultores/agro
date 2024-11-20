import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_mixin_layout/responsive_mixin_layout.dart';
import 'package:sap_avicola/models/kpis_home_model.dart';
import 'package:sap_avicola/models/profile_model.dart';
import 'package:sap_avicola/repositories/api_lider_pollo.dart';
import 'package:sap_avicola/utils/general/variables.dart';
import 'package:sap_avicola/utils/mixins/general_mixins.dart';
import 'package:sap_avicola/utils/services/local_data/hive_data_service.dart';
import 'package:sap_avicola/widgets/defaults/button.dart';
import 'package:sap_avicola/widgets/defaults/scaffold.dart';
import 'package:sap_avicola/widgets/loaders/loader.dart';
import 'package:sap_avicola/widgets/sheets/card_widget.dart';
import 'package:sap_avicola/widgets/simple_pie_graph.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with ThemesMixin, SingleTickerProviderStateMixin {
  late final loader = AppLoader();
  final apiLiderPollo = ApiLiderPollo();

  String userName = "";
  String etapa = "CRIA";

  KpisHomeModel kpis = KpisHomeModel(indicadores: [], graficos: []);
  var indicators = <KpisHomeIndicadoresModel>[];
  List<MapEntry<String, (double, Color)>> graphs = [];

  List<String> moduloActive = [];

  // funcion getData
  Future<void> getData() async {
    var data = HiveData.read(HiveDataCollection.profile);

    if (data != null) {
      Map<String, dynamic> stringKeyedData = Map<String, dynamic>.from(data);
      ProfileModel profile = ProfileModel.fromJson(stringKeyedData);
      userName = profile.nombre;

      await Future.wait([getRoles(), getKpisHome()]);

      setState(() {});
    }
  }

  Future<void> getKpisHome() async {
    final kpisList = await apiLiderPollo.getKpisHome(etapa);
    kpis = kpisList;

    setState(() {
      indicators = kpis.indicadores;
      graphs = List.generate(
          kpis.graficos.length,
          (index) => MapEntry(kpis.graficos[index].desc,
              (kpis.graficos[index].porcentaje, kpis.graficos[index].color)));
    });
  }

  Future<void> getRoles() async {
    final roles = await apiLiderPollo.getRolUser();
    final modulos = ['cria', 'produccion', 'engorde'];
    for (var modulo in modulos) {
      bool foundModulo = roles.any((role) {
        return role.modulo == modulo && role.isActive;
      });
      if (foundModulo) {
        moduloActive.add(modulo);
      }
    }
  }

  late final AnimationController animationController;

  int carouselIndex = 0;

  /*List<MapEntry<String, (double, Color)>> get graphs => [
        MapEntry("Lorem ipsum\nlorem", (37.5, colors.tertiaryDarken)),
        MapEntry("Lorem ipsum\nlorem", (80, colors.secondary)),
        MapEntry("Lorem ipsum\nlorem", (100, colors.primary)),
      ];*/

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      getData();
    });
    animationController = AnimationController(
      vsync: this,
      duration: Durations.short2,
      value: 1,
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scrollable: true,
      doubleBackToExit: true,
      body: Column(children: [
        Text("¡Buenos días!",
            style: TextStyle(
              fontSize: 22.sp,
            )),
        Gap(12.sp).column,
        CardWidgetV2(
          width: double.maxFinite,
          child: Column(children: [
            CircleAvatar(radius: 18.dm),
            Gap(4.sp).column,
            Text(userName,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                )),
            /*Text("Supervisor Planta",
                style: TextStyle(
                  fontSize: 12.sp,
                  letterSpacing: 0.4,
                )),*/
          ]),
        ),
        Gap(24.sp).column,
        SizedBox(
          width: 280,
          height: 39,
          child: Row(children: [
            if (moduloActive.contains('cria'))
              Expanded(
                child: Button(
                  text: "Cría",
                  padding: const EdgeInsets.all(0),
                  color: etapa == 'CRIA'
                      ? const Color(0xfffafafa)
                      : colors.primaryDarken,
                  bgColor:
                      etapa == 'CRIA' ? colors.primaryDarken : theme.cardColor,
                  borderSide: BorderSide(color: colors.primaryDarken),
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(100),
                  ),
                  textStyle: TextStyle(fontSize: 13.5.sp),
                  onPressed: () async {
                    setState(() {
                      etapa = "CRIA";
                    });
                    loader.init();
                    await getKpisHome();
                    loader.close();
                  },
                ),
              ),
            if (moduloActive.contains('produccion'))
              Expanded(
                child: Button(
                  text: "Producción",
                  padding: const EdgeInsets.all(0),
                  color: etapa == 'PRODUCCION'
                      ? const Color(0xfffafafa)
                      : colors.primaryDarken,
                  bgColor: etapa == 'PRODUCCION'
                      ? colors.primaryDarken
                      : theme.cardColor,
                  borderSide: BorderSide(color: colors.primaryDarken),
                  borderRadius: const BorderRadius.horizontal(),
                  textStyle: TextStyle(fontSize: 13.5.sp),
                  onPressed: () async {
                    // etapa = "CRIA"; // "PRODUCCION";
                    setState(() {
                      etapa = "PRODUCCION";
                    });

                    loader.init();
                    await getKpisHome();
                    loader.close();
                  },
                ),
              ),
            if (moduloActive.contains('engorde'))
              Expanded(
                child: Button(
                  text: "Engorde",
                  padding: const EdgeInsets.all(0),
                  color: etapa == 'ENGORDE'
                      ? const Color(0xfffafafa)
                      : colors.primaryDarken,
                  bgColor: etapa == 'ENGORDE'
                      ? colors.primaryDarken
                      : theme.cardColor,
                  borderSide: BorderSide(color: colors.primaryDarken),
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(100),
                  ),
                  textStyle: TextStyle(fontSize: 13.5.sp),
                  onPressed: () async {
                    //etapa = "CRIA"; // "ENGORDE";
                    setState(() {
                      etapa = "ENGORDE";
                    });

                    loader.init();
                    await getKpisHome();
                    loader.close();
                  },
                ),
              ),
          ]),
        ),
        Gap(40.sp).column,
        CarouselSlider(
          options: CarouselOptions(
            height: context.width.isXmobile ? 240 : 250,
            viewportFraction: .7,
            clipBehavior: Clip.none,
            onPageChanged: (index, carouselPageChangedReason) {
              carouselIndex = index;
              animationController
                  .reverse()
                  .then((_) => animationController.forward());
            },
          ),
          items: graphs
              .mapIndexed((i, item) => AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    final animation = Tween<double>(begin: .8, end: 1)
                        .animate(animationController);

                    double getScale() {
                      if (carouselIndex == i) {
                        return animationController.status !=
                                AnimationStatus.reverse
                            ? animation.value
                            : .8;
                      }

                      return animationController.status ==
                              AnimationStatus.reverse
                          ? animation.value
                          : .8;
                    }

                    return Transform.scale(
                      scale: getScale(),
                      child: SimplePieGraph(
                        title: item.key,
                        value: item.value.$1,
                        color: item.value.$2,
                        showState: true,
                        bgColor:
                            carouselIndex == i ? null : const Color(0xFFf7f8fc),
                      ),
                    );
                  }))
              .toList(),
        ),
        Gap(30.sp).column,
        Align(
          alignment: Alignment.centerLeft,
          child: Text("Indicadores", style: theme.textTheme.bodyLarge),
        ),
        Gap(8.sp).column,
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: indicators.length,
            separatorBuilder: (context, index) => Gap(12.sp).row,
            itemBuilder: (context, index) => CardWidget(
                width: 120,
                border: Border.all(color: colors.label),
                boxShadow: const [],
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(Vars.radius4),
                          ),
                          border:
                              Border.all(width: 1.5, color: colors.secondary),
                        ),
                        child: Transform.scale(
                          scale: 1.1,
                          child: Icon(
                            Icons.house_siding_rounded,
                            size: 25,
                            color: colors.secondary,
                          ),
                        ),
                      ),
                      Gap(7.sp).column,
                      Text(indicators[index].desc,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          )),
                      Gap(4.sp).column,
                      Text(indicators[index].value,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 24,
                            color: colors.label,
                          )),
                    ])),
          ),
        ),
      ]),
    );
  }
}
