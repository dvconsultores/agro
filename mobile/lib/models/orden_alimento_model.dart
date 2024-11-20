import 'package:sap_avicola/utils/extensions/type_extensions.dart';

class OrdenAlimentoModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  OrdenAlimentoModel(
      {required this.id,
      required this.numOrden,
      required this.cantidadKg,
      required this.codigoAlimento,
      required this.tipoAlimento});

  final int id;
  final String numOrden;
  final String cantidadKg;
  final String codigoAlimento;
  final String tipoAlimento;

  factory OrdenAlimentoModel.fromJson(Map<String, dynamic> json) =>
      OrdenAlimentoModel(
        id: json["id"],
        numOrden: json["num_orden"].toString(),
        cantidadKg: json["cantidad_kg"].toString(),
        codigoAlimento: json["codigo_alimento"].toString(),
        tipoAlimento: json["tipo_alimento"].toString(),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "numOrden": numOrden,
        "cantidadKg": cantidadKg,
        "codigoAlimento": codigoAlimento,
        "tipoAlimento": tipoAlimento
      };

  @override
  OrdenAlimentoModel copyWith(
          {int? id,
          String? numOrden,
          String? cantidadKg,
          String? codigoAlimento,
          String? tipoAlimento}) =>
      OrdenAlimentoModel(
          id: id ?? this.id,
          numOrden: numOrden ?? this.numOrden,
          cantidadKg: cantidadKg ?? this.cantidadKg,
          codigoAlimento: codigoAlimento ?? this.codigoAlimento,
          tipoAlimento: tipoAlimento ?? this.tipoAlimento);

  static List<OrdenAlimentoModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => OrdenAlimentoModel.fromJson(e)).toList();
}
