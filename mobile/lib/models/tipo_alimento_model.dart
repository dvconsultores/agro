import 'package:sap_avicola/utils/extensions/type_extensions.dart';

class TipoAlimentoModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  TipoAlimentoModel({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory TipoAlimentoModel.fromJson(Map<String, dynamic> json) =>
      TipoAlimentoModel(
        id: json["id"],
        name: json["name"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  TipoAlimentoModel copyWith({
    int? id,
    String? name,
  }) =>
      TipoAlimentoModel(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  static List<TipoAlimentoModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => TipoAlimentoModel.fromJson(e)).toList();
}
