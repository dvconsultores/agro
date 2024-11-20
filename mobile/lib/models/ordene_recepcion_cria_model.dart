import 'package:sap_avicola/utils/extensions/type_extensions.dart';

class OrdenRecepcionCriaModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  OrdenRecepcionCriaModel(
      {required this.id,
      required this.ordenCompra,
      required this.cantHembras,
      required this.cantMachos,
      required this.granjaId,
      required this.proveedor});

  final int id;
  final String ordenCompra;
  final int cantHembras;
  final int cantMachos;
  final int granjaId;
  final int proveedor;

  factory OrdenRecepcionCriaModel.fromJson(Map<String, dynamic> json) =>
      OrdenRecepcionCriaModel(
        id: json["id"],
        ordenCompra: json["orden_compra"].toString(),
        cantHembras: json["cant_hembras"],
        cantMachos: json["cant_machos"],
        granjaId: json["granja_id"],
        proveedor: json["proveedor"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "ordenCompra": ordenCompra,
        "cantHembras": cantHembras,
        "cantMachos": cantMachos,
        "granjaId": granjaId,
        "proveedor": proveedor,
      };

  @override
  OrdenRecepcionCriaModel copyWith(
          {int? id,
          String? ordenCompra,
          int? cantHembras,
          int? cantMachos,
          int? granjaId,
          int? proveedor}) =>
      OrdenRecepcionCriaModel(
        id: id ?? this.id,
        ordenCompra: ordenCompra ?? this.ordenCompra,
        cantHembras: cantHembras ?? this.cantHembras,
        cantMachos: cantMachos ?? this.cantMachos,
        granjaId: granjaId ?? this.granjaId,
        proveedor: proveedor ?? this.proveedor,
      );

  static List<OrdenRecepcionCriaModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => OrdenRecepcionCriaModel.fromJson(e)).toList();
}
