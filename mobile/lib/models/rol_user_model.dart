import 'package:collection/collection.dart';
import 'package:sap_avicola/models/register_option_model.dart';
import 'package:sap_avicola/utils/extensions/type_extensions.dart';

class RolUserModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  RolUserModel(
      {required this.modulo,
      required this.isActive,
      required this.enumOption,
      required this.subModulos,
      required this.process});

  final String modulo;
  final bool isActive;
  final RegisterSectionOption enumOption;
  final List<RegisterOption> subModulos;
  final List<RolUserProcessModel> process;

  factory RolUserModel.fromJson(Map<String, dynamic> json) {
    //try {
    List<RegisterOption> subModulosFinal = [];
    List<RolUserProcessModel> processList = [];
    if (json["subModulos"] != null) {
      final List<String> data = (json["subModulos"] as List<dynamic>)
          .map((e) => e as String)
          .toList();

      for (var item in data) {
        final exist = subModulosList
            .firstWhereOrNull((element) => element.identificador == item);
        if (exist != null) {
          final List<RegisterOption> processOptions = [
            RegisterOption.breedingProcess,
            RegisterOption.productionProcess,
            RegisterOption.fatteningProcess
          ];

          final bool isProcess = processOptions.contains(exist.enumOption);
          final bool existProcess = subModulosFinal
              .any((element) => isProcess && element == exist.enumOption);

          if (isProcess) {
            if (exist.process != null) {
              processList.add(exist.process!);
            }
          }

          if (!existProcess) {
            subModulosFinal.add(exist.enumOption);
          }
        }
      }
    }

    final existModulo = modulosList.firstWhereOrNull(
        (element) => element.identificador == json["modulo"].toString());
    RegisterSectionOption moduloFinal = RegisterSectionOption.breedingPhase;
    bool active = false;
    if (existModulo != null) {
      active = true;
      moduloFinal = existModulo.enumOption;
    }

    return RolUserModel(
        modulo: json["modulo"].toString(),
        isActive: active,
        enumOption: moduloFinal,
        subModulos: subModulosFinal,
        process: processList);
    /*} catch (e) {
      print("----------------------------------------------");
      print(e);
      print("----------------------------------------------");
      return RolUserModel(
        modulo: "0",
        isActive: false,
        enumOption: RegisterSectionOption.incubator,
        subModulos: [],
        process: [],
      );
    }*/
  }

  @override
  Map<String, dynamic> toJson() => {
        "modulo": modulo,
        "isActive": isActive,
        "enumOption": enumOption,
        "subModulos": subModulos,
        "process": process,
      };

  @override
  RolUserModel copyWith({
    String? modulo,
    bool? isActive,
    RegisterSectionOption? enumOption,
    List<RegisterOption>? subModulos,
    List<RolUserProcessModel>? process,
  }) =>
      RolUserModel(
        modulo: modulo ?? this.modulo,
        isActive: isActive ?? this.isActive,
        enumOption: enumOption ?? this.enumOption,
        subModulos: subModulos ?? this.subModulos,
        process: process ?? this.process,
      );

  static List<RolUserModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => RolUserModel.fromJson(e)).toList();
}

class RolUserModuloModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  RolUserModuloModel({required this.identificador, required this.enumOption});

  final String identificador;
  final RegisterSectionOption enumOption;

  factory RolUserModuloModel.fromJson(Map<String, dynamic> json) =>
      RolUserModuloModel(
        identificador: json["identificador"],
        enumOption: json["enumOption"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "identificador": identificador,
        "enumOption": enumOption,
      };

  @override
  RolUserModuloModel copyWith({
    String? identificador,
    RegisterSectionOption? enumOption,
  }) =>
      RolUserModuloModel(
        identificador: identificador ?? this.identificador,
        enumOption: enumOption ?? this.enumOption,
      );

  static List<RolUserModuloModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => RolUserModuloModel.fromJson(e)).toList();
}

class RolUserSubModuloModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  RolUserSubModuloModel(
      {required this.identificador,
      required this.enumOption,
      required this.process});

  final String identificador;
  final RegisterOption enumOption;
  final RolUserProcessModel? process;

  factory RolUserSubModuloModel.fromJson(Map<String, dynamic> json) =>
      RolUserSubModuloModel(
          identificador: json["identificador"],
          enumOption: json["enumOption"],
          process: json["process"]);

  @override
  Map<String, dynamic> toJson() => {
        "identificador": identificador,
        "enumOption": enumOption,
        "process": process
      };

  @override
  RolUserSubModuloModel copyWith({
    String? identificador,
    RegisterOption? enumOption,
    RolUserProcessModel? process,
  }) =>
      RolUserSubModuloModel(
          identificador: identificador ?? this.identificador,
          enumOption: enumOption ?? this.enumOption,
          process: process ?? this.process);

  static List<RolUserSubModuloModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => RolUserSubModuloModel.fromJson(e)).toList();
}

class RolUserProcessModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  RolUserProcessModel({required this.title, required this.index});

  final String title;
  final int index;

  factory RolUserProcessModel.fromJson(Map<String, dynamic> json) =>
      RolUserProcessModel(title: json["title"], index: json["index"]);

  @override
  Map<String, dynamic> toJson() => {"title": title, "index": index};

  @override
  RolUserProcessModel copyWith({String? title, int? index}) =>
      RolUserProcessModel(
          title: title ?? this.title, index: index ?? this.index);

  static List<RolUserProcessModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => RolUserProcessModel.fromJson(e)).toList();
}

List<RolUserModuloModel> modulosList = [
  RolUserModuloModel.fromJson({
    'identificador': 'cria',
    'enumOption': RegisterSectionOption.breedingPhase,
  }),
  RolUserModuloModel.fromJson({
    'identificador': 'produccion',
    'enumOption': RegisterSectionOption.reproductiveProductionPhase,
  }),
  RolUserModuloModel.fromJson({
    'identificador': 'engorde',
    'enumOption': RegisterSectionOption.reproductiveFatteningPhase,
  }),
  RolUserModuloModel.fromJson({
    'identificador': 'incubadora',
    'enumOption': RegisterSectionOption.incubator,
  }),
];

List<RolUserSubModuloModel> subModulosList = [
  RolUserSubModuloModel.fromJson({
    'identificador': 'inspeccion_incubadora',
    'enumOption': RegisterOption.incubatorInspect,
    'process': null
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'recepcion_huevos_incubadora',
    'enumOption': RegisterOption.eggsReception,
    'process': null
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'clasificacion_huevos_incubadora',
    'enumOption': RegisterOption.sortEggs,
    'process': null
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'incubacion_huevos_incubadora',
    'enumOption': RegisterOption.incubator,
    'process': null
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'registro_nacimiento_incubadora',
    'enumOption': RegisterOption.birthCertificate,
    'process': null
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'salida_pollitos_incubadora',
    'enumOption': RegisterOption.babyChicksExit,
    'process': null
  }),
  //////////////////////////////////////////////////////
  RolUserSubModuloModel.fromJson({
    'identificador': 'inspeccion_granjas_cria',
    'enumOption': RegisterOption.farmInspection,
    'process': null
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'distribucion_aves_cria',
    'enumOption': RegisterOption.birdsDistribution,
    'process': null
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'salida_aves_cria',
    'enumOption': RegisterOption.birdExit,
    'process': null
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'inspeccion_transporte_aves_cria',
    'enumOption': RegisterOption.transportInspection,
    'process': null
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'registro_alimento_cria',
    'enumOption': RegisterOption.breedingProcess,
    'process': RolUserProcessModel(index: 0, title: 'Registro de Alimento')
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'registro_pesaje_cria',
    'enumOption': RegisterOption.breedingProcess,
    'process': RolUserProcessModel(index: 1, title: 'Pesaje de Aves')
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'registro_mortalidad_cria',
    'enumOption': RegisterOption.breedingProcess,
    'process': RolUserProcessModel(index: 2, title: 'Mortalidad de Aves')
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'registro_vacunas_cria',
    'enumOption': RegisterOption.breedingProcess,
    'process': RolUserProcessModel(index: 3, title: 'Vacunas Colocadas')
  }),
  /////////////////////////////////////////////////////
  RolUserSubModuloModel.fromJson({
    'identificador': 'inspeccion_granjas_produccion',
    'enumOption': RegisterOption.farmInspection,
    'process': null
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'distribucion_aves_produccion',
    'enumOption': RegisterOption.birdsDistribution,
    'process': null
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'salida_aves_produccion',
    'enumOption': RegisterOption.birdExit,
    'process': null
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'inspeccion_transporte_aves_produccion',
    'enumOption': RegisterOption.transportInspection,
    'process': null
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'salida_huevos_produccion',
    'enumOption': RegisterOption.eggsExit,
    'process': null
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'inspeccion_transporte_huevos_produccion',
    'enumOption': RegisterOption.transportInspectionEgg,
    'process': null
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'registro_alimento_produccion',
    'enumOption': RegisterOption.productionProcess,
    'process': RolUserProcessModel(index: 0, title: 'Registro de Alimento')
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'registro_pesaje_produccion',
    'enumOption': RegisterOption.productionProcess,
    'process': RolUserProcessModel(index: 1, title: 'Pesaje de Aves')
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'registro_mortalidad_produccion',
    'enumOption': RegisterOption.productionProcess,
    'process': RolUserProcessModel(index: 2, title: 'Mortalidad de Aves')
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'registro_vacunas_produccion',
    'enumOption': RegisterOption.productionProcess,
    'process': RolUserProcessModel(index: 3, title: 'Vacunas Colocadas')
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'registro_recoleccion_huevos_produccion',
    'enumOption': RegisterOption.productionProcess,
    'process': RolUserProcessModel(index: 4, title: 'Recolección de Huevos')
  }),
  ////////////////////////////////////////////////////////////
  RolUserSubModuloModel.fromJson({
    'identificador': 'inspeccion_granjas_engorde',
    'enumOption': RegisterOption.farmInspection,
    'process': null
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'distribucion_aves_engorde',
    'enumOption': RegisterOption.birdsDistribution,
    'process': null
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'salida_aves_engorde',
    'enumOption': RegisterOption.birdExit,
    'process': null
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'inspeccion_transporte_aves_engorde',
    'enumOption': RegisterOption.transportInspection,
    'process': null
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'registro_alimento_engorde',
    'enumOption': RegisterOption.fatteningProcess,
    'process': RolUserProcessModel(index: 0, title: 'Registro de Alimento')
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'registro_pesaje_engorde',
    'enumOption': RegisterOption.fatteningProcess,
    'process': RolUserProcessModel(index: 1, title: 'Pesaje de Aves')
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'registro_mortalidad_engorde',
    'enumOption': RegisterOption.fatteningProcess,
    'process': RolUserProcessModel(index: 2, title: 'Mortalidad de Aves')
  }),
  RolUserSubModuloModel.fromJson({
    'identificador': 'registro_vacunas_engorde',
    'enumOption': RegisterOption.fatteningProcess,
    'process': RolUserProcessModel(index: 3, title: 'Vacunas Colocadas')
  }),
];
