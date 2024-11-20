import 'package:sap_avicola/utils/extensions/type_extensions.dart';

class OrdenSalidaAvesModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  OrdenSalidaAvesModel(
      {required this.id,
      required this.numOrden,
      required this.cantidadAves,
      required this.destinoId,
      required this.transporteId});

  final int id;
  final String numOrden;
  final String cantidadAves;
  final int destinoId;
  final int transporteId;

  factory OrdenSalidaAvesModel.fromJson(Map<String, dynamic> json) =>
      OrdenSalidaAvesModel(
          id: json["id"],
          numOrden: json["orden"].toString(),
          cantidadAves: json["cant_aves"].toString(),
          destinoId: json["destino_id"],
          transporteId: json["transporte_id"]);

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "numOrden": numOrden,
        "cantidadAves": cantidadAves,
        "destinoId": destinoId,
        "transporteId": transporteId
      };

  @override
  OrdenSalidaAvesModel copyWith(
          {int? id,
          String? numOrden,
          String? cantidadAves,
          int? destinoId,
          int? transporteId}) =>
      OrdenSalidaAvesModel(
          id: id ?? this.id,
          numOrden: numOrden ?? this.numOrden,
          cantidadAves: cantidadAves ?? this.cantidadAves,
          destinoId: destinoId ?? this.destinoId,
          transporteId: transporteId ?? this.transporteId);

  static List<OrdenSalidaAvesModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => OrdenSalidaAvesModel.fromJson(e)).toList();
}
