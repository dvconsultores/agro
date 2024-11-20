import 'package:flutter/material.dart';
import 'package:sap_avicola/utils/extensions/type_extensions.dart';

class KpisStatisticModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  KpisStatisticModel({
    required this.name,
    required this.desc,
    required this.percent,
    required this.color,
  });
  final String name;
  final String desc;
  final double? percent;
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

  factory KpisStatisticModel.fromJson(Map<String, dynamic> json) {
    return KpisStatisticModel(
      name: json["nombre"],
      desc: json["value"].toString(),
      percent: json["porcentaje"].toString().toDouble(),
      color: json["color"] == null
          ? listColor["primaryLighten"]!
          : listColor[json["color"]] ?? listColor["primaryLighten"]!,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "name": name,
        "desc": desc,
        "percent": percent,
        "color": color,
      };

  @override
  KpisStatisticModel copyWith({
    String? name,
    String? desc,
    double? percent,
    Color? color,
  }) =>
      KpisStatisticModel(
        name: name ?? this.name,
        desc: desc ?? this.desc,
        percent: percent ?? this.percent,
        color: color ?? this.color,
      );

  static List<KpisStatisticModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => KpisStatisticModel.fromJson(e)).toList();
}
