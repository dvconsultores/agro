import 'package:sap_avicola/utils/extensions/type_extensions.dart';

class LoteHuevosRecepcionModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  LoteHuevosRecepcionModel({
    required this.id,
    required this.lote,
    required this.cantidadHuevos,
  });

  final int id;
  final String lote;
  final String cantidadHuevos;

  factory LoteHuevosRecepcionModel.fromJson(Map<String, dynamic> json) =>
      LoteHuevosRecepcionModel(
        id: json["id"],
        lote: json["lote"],
        cantidadHuevos: json["huevos_disponibles"].toString() == "null"
            ? json["cant_huevos"].toString()
            : json["huevos_disponibles"].toString(),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "lote": lote,
        "cantidadHuevos": cantidadHuevos,
      };

  @override
  LoteHuevosRecepcionModel copyWith({
    int? id,
    String? lote,
    String? cantidadHuevos,
  }) =>
      LoteHuevosRecepcionModel(
        id: id ?? this.id,
        lote: lote ?? this.lote,
        cantidadHuevos: cantidadHuevos ?? this.cantidadHuevos,
      );

  static List<LoteHuevosRecepcionModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => LoteHuevosRecepcionModel.fromJson(e)).toList();
}
