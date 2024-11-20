import 'package:sap_avicola/utils/extensions/type_extensions.dart';

class GalponRecepcionModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  GalponRecepcionModel(
      {required this.id, required this.galpon, required this.disponible});

  final int id;
  final String galpon;
  final int disponible;

  factory GalponRecepcionModel.fromJson(Map<String, dynamic> json) =>
      GalponRecepcionModel(
        id: json["id"],
        galpon: json["galpon"].toString(),
        disponible: json["disponible"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "galpon": galpon,
        "disponible": disponible,
      };

  @override
  GalponRecepcionModel copyWith({
    int? id,
    String? galpon,
    int? disponible,
  }) =>
      GalponRecepcionModel(
        id: id ?? this.id,
        galpon: galpon ?? this.galpon,
        disponible: disponible ?? this.disponible,
      );

  static List<GalponRecepcionModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => GalponRecepcionModel.fromJson(e)).toList();
}
