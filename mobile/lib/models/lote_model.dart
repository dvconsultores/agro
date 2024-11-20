import 'package:sap_avicola/utils/extensions/type_extensions.dart';

class LoteModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  LoteModel({
    required this.id,
    required this.lote,
  });

  final int id;
  final String lote;

  factory LoteModel.fromJson(Map<String, dynamic> json) => LoteModel(
        id: json["id"],
        lote: json["lote"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "lote": lote,
      };

  @override
  LoteModel copyWith({
    int? id,
    String? lote,
  }) =>
      LoteModel(
        id: id ?? this.id,
        lote: lote ?? this.lote,
      );

  static List<LoteModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => LoteModel.fromJson(e)).toList();
}
