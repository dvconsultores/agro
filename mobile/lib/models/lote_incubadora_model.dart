import 'package:sap_avicola/utils/extensions/type_extensions.dart';

class LoteIncubadoraModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  LoteIncubadoraModel({
    required this.id,
    required this.lote,
    required this.cantidad,
    required this.fechaRecepcion,
    required this.granjaOrigen,
    required this.cantidadNacidos,
  });

  final int id;
  final String lote;
  final String cantidad;
  final String fechaRecepcion;
  final String granjaOrigen;
  final String cantidadNacidos;

  factory LoteIncubadoraModel.fromJson(Map<String, dynamic> json) =>
      LoteIncubadoraModel(
        id: json["id"],
        lote: json["lote"].toString(),
        cantidad: json["cantidad_recibida"].toString(),
        fechaRecepcion: json["fecha_recepcion"].toString(),
        granjaOrigen: json["granja_origen"].toString(),
        cantidadNacidos: json["cantidad_nacida"].toString(),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "lote": lote,
        "cantidad": cantidad,
        "fechaRecepcion": fechaRecepcion,
        "granjaOrigen": granjaOrigen,
        "cantidadNacidos": cantidadNacidos,
      };

  @override
  LoteIncubadoraModel copyWith({
    int? id,
    String? lote,
    String? cantidad,
    String? fechaRecepcion,
    String? granjaOrigen,
    String? cantidadNacidos,
  }) =>
      LoteIncubadoraModel(
        id: id ?? this.id,
        lote: lote ?? this.lote,
        cantidad: cantidad ?? this.cantidad,
        fechaRecepcion: fechaRecepcion ?? this.fechaRecepcion,
        granjaOrigen: granjaOrigen ?? this.granjaOrigen,
        cantidadNacidos: cantidadNacidos ?? this.cantidadNacidos,
      );

  static List<LoteIncubadoraModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => LoteIncubadoraModel.fromJson(e)).toList();
}
