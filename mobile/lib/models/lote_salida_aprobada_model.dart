import 'package:sap_avicola/utils/extensions/type_extensions.dart';

class LoteSalidaAprobadaModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  LoteSalidaAprobadaModel({
    required this.id,
    required this.lote,
    required this.cantidadAves,
    required this.distribucion,
  });

  final int id;
  final String lote;
  final String cantidadAves;
  final List<DistribucionLoteSalidaAprobadaModel> distribucion;

  factory LoteSalidaAprobadaModel.fromJson(Map<String, dynamic> json) =>
      LoteSalidaAprobadaModel(
        id: json["id"],
        lote: json["lote"],
        cantidadAves: json["cant_aves"].toString(),
        distribucion: DistribucionLoteSalidaAprobadaModel.buildListFrom(
            json["distribucion"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "lote": lote,
        "cantidadAves": cantidadAves,
        "distribucion": distribucion,
      };

  @override
  LoteSalidaAprobadaModel copyWith({
    int? id,
    String? lote,
    String? cantidadAves,
    List<DistribucionLoteSalidaAprobadaModel>? distribucion,
  }) =>
      LoteSalidaAprobadaModel(
        id: id ?? this.id,
        lote: lote ?? this.lote,
        cantidadAves: cantidadAves ?? this.cantidadAves,
        distribucion: distribucion ?? this.distribucion,
      );

  static List<LoteSalidaAprobadaModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => LoteSalidaAprobadaModel.fromJson(e)).toList();
}

class DistribucionLoteSalidaAprobadaModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  DistribucionLoteSalidaAprobadaModel({
    required this.galpoId,
    required this.cantidadAves,
  });

  final int galpoId;
  final String cantidadAves;

  factory DistribucionLoteSalidaAprobadaModel.fromJson(
          Map<String, dynamic> json) =>
      DistribucionLoteSalidaAprobadaModel(
        galpoId: json["galpon_id"],
        cantidadAves: json["cantidad"].toString(),
      );

  @override
  Map<String, dynamic> toJson() => {
        "galpoId": galpoId,
        "cantidadAves": cantidadAves,
      };

  @override
  DistribucionLoteSalidaAprobadaModel copyWith({
    int? galpoId,
    String? cantidadAves,
  }) =>
      DistribucionLoteSalidaAprobadaModel(
        galpoId: galpoId ?? this.galpoId,
        cantidadAves: cantidadAves ?? this.cantidadAves,
      );

  static List<DistribucionLoteSalidaAprobadaModel> buildListFrom(
          List<dynamic> list) =>
      list.map((e) => DistribucionLoteSalidaAprobadaModel.fromJson(e)).toList();
}
