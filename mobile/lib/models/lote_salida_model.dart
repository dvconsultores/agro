import 'package:sap_avicola/utils/extensions/type_extensions.dart';

class LoteSalidaModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  LoteSalidaModel({
    required this.id,
    required this.lote,
    required this.cantidadAves,
  });

  final int id;
  final String lote;
  final String cantidadAves;

  factory LoteSalidaModel.fromJson(Map<String, dynamic> json) =>
      LoteSalidaModel(
          id: json["id"],
          lote: json["lote"],
          cantidadAves: json["cant_aves"].toString());

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "lote": lote,
        "cantidadAves": cantidadAves,
      };

  @override
  LoteSalidaModel copyWith({
    int? id,
    String? lote,
    String? cantidadAves,
  }) =>
      LoteSalidaModel(
        id: id ?? this.id,
        lote: lote ?? this.lote,
        cantidadAves: cantidadAves ?? this.cantidadAves,
      );

  static List<LoteSalidaModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => LoteSalidaModel.fromJson(e)).toList();
}
