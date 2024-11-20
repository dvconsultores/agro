import 'package:sap_avicola/utils/extensions/type_extensions.dart';

class PlantaBeneficioModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  PlantaBeneficioModel({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory PlantaBeneficioModel.fromJson(Map<String, dynamic> json) =>
      PlantaBeneficioModel(
        id: json["id"],
        name: json["name"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  PlantaBeneficioModel copyWith({
    int? id,
    String? name,
  }) =>
      PlantaBeneficioModel(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  static List<PlantaBeneficioModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => PlantaBeneficioModel.fromJson(e)).toList();
}
