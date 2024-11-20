import 'package:sap_avicola/utils/extensions/type_extensions.dart';

class GalponModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  GalponModel(
      {required this.id, required this.galpon, required this.capacidad});

  final int id;
  final String galpon;
  final int capacidad;

  factory GalponModel.fromJson(Map<String, dynamic> json) => GalponModel(
        id: json["id"],
        galpon: json["galpon"],
        capacidad: json["capacidad"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "galpon": galpon,
        "capacidad": capacidad,
      };

  @override
  GalponModel copyWith({
    int? id,
    String? galpon,
    int? capacidad,
  }) =>
      GalponModel(
        id: id ?? this.id,
        galpon: galpon ?? this.galpon,
        capacidad: capacidad ?? this.capacidad,
      );

  static List<GalponModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => GalponModel.fromJson(e)).toList();
}
