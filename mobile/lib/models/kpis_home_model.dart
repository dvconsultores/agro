import 'package:flutter/material.dart';
import 'package:sap_avicola/utils/extensions/type_extensions.dart';

class KpisHomeModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  KpisHomeModel({
    required this.indicadores,
    required this.graficos,
  });
  final List<KpisHomeIndicadoresModel> indicadores;
  final List<KpisHomeGraficosModel> graficos;

  factory KpisHomeModel.fromJson(Map<String, dynamic> json) {
    return KpisHomeModel(
      indicadores: KpisHomeIndicadoresModel.buildListFrom(json["indicadores"]),
      graficos: KpisHomeGraficosModel.buildListFrom(json["graficos"]),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "indicadores": indicadores,
        "graficos": graficos,
      };

  @override
  KpisHomeModel copyWith({
    List<KpisHomeIndicadoresModel>? indicadores,
    List<KpisHomeGraficosModel>? graficos,
  }) =>
      KpisHomeModel(
        indicadores: indicadores ?? this.indicadores,
        graficos: graficos ?? this.graficos,
      );

  static List<KpisHomeModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => KpisHomeModel.fromJson(e)).toList();
}

class KpisHomeIndicadoresModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  KpisHomeIndicadoresModel({
    required this.desc,
    required this.value,
  });
  final String desc;
  final String value;

  factory KpisHomeIndicadoresModel.fromJson(Map<String, dynamic> json) {
    return KpisHomeIndicadoresModel(
        desc: json["desc"].toString(), value: json["value"].toString());
  }

  @override
  Map<String, dynamic> toJson() => {
        "desc": desc,
        "value": value,
      };

  @override
  KpisHomeIndicadoresModel copyWith({
    String? desc,
    String? value,
  }) =>
      KpisHomeIndicadoresModel(
        desc: desc ?? this.desc,
        value: value ?? this.value,
      );

  static List<KpisHomeIndicadoresModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => KpisHomeIndicadoresModel.fromJson(e)).toList();
}

class KpisHomeGraficosModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  KpisHomeGraficosModel({
    required this.desc,
    required this.porcentaje,
    required this.color,
  });
  final String desc;
  final double porcentaje;
  final Color color;

  static Map<String, Color> listColor = {
    "primaryLighten": const Color(0xFF0D154B),
    "primaryDarken": const Color(0xFF3B4279),
    "secondaryLighten": const Color(0xFFFF8B65),
    "tertiaryDarken": const Color(0xFFC5AA00),
    "primary": const Color(0xff001689),
    "secondary": const Color(0xFFFF5100),
    "tertiary": const Color(0xFFF7E388),
  };

  factory KpisHomeGraficosModel.fromJson(Map<String, dynamic> json) {
    return KpisHomeGraficosModel(
      desc: json["desc"].toString(),
      porcentaje: json["porcentaje"].toString().toDouble(),
      color: json["color"] == null
          ? listColor["primaryLighten"]!
          : listColor[json["color"]] ?? listColor["primaryLighten"]!,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "desc": desc,
        "porcentaje": porcentaje,
        "color": color,
      };

  @override
  KpisHomeGraficosModel copyWith({
    String? desc,
    double? porcentaje,
    Color? color,
  }) =>
      KpisHomeGraficosModel(
        desc: desc ?? this.desc,
        porcentaje: porcentaje ?? this.porcentaje,
        color: color ?? this.color,
      );

  static List<KpisHomeGraficosModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => KpisHomeGraficosModel.fromJson(e)).toList();
}
