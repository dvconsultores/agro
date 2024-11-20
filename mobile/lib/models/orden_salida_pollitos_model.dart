import 'package:sap_avicola/utils/extensions/type_extensions.dart';

class OrdenSalidaPollitosModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  OrdenSalidaPollitosModel(
      {required this.orden,
      required this.numOrden,
      required this.destinoId,
      required this.transporteId,
      required this.cantidadAvesList});

  final String orden;
  final String numOrden;
  final int destinoId;
  final int transporteId;
  final List<int> cantidadAvesList;

  factory OrdenSalidaPollitosModel.fromJson(Map<String, dynamic> json) =>
      OrdenSalidaPollitosModel(
        orden: json["orden"].toString(),
        numOrden: json["numOrden"].toString(),
        destinoId: json["destinoId"],
        transporteId: json["transporteId"],
        cantidadAvesList: (json["cantidadAves"] as List<dynamic>)
            .map((e) => e as int)
            .toList(),
      );

  @override
  Map<String, dynamic> toJson() => {
        "orden": orden,
        "numOrden": numOrden,
        "destinoId": destinoId,
        "transporteId": transporteId,
        "cantidadAvesList": cantidadAvesList
      };

  @override
  OrdenSalidaPollitosModel copyWith(
          {String? orden,
          String? numOrden,
          int? destinoId,
          int? transporteId,
          List<int>? cantidadAvesList}) =>
      OrdenSalidaPollitosModel(
          orden: orden ?? this.orden,
          numOrden: numOrden ?? this.numOrden,
          destinoId: destinoId ?? this.destinoId,
          transporteId: transporteId ?? this.transporteId,
          cantidadAvesList: cantidadAvesList ?? this.cantidadAvesList);

  static List<OrdenSalidaPollitosModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => OrdenSalidaPollitosModel.fromJson(e)).toList();
}
