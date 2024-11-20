import 'package:sap_avicola/utils/extensions/type_extensions.dart';

class IncubadoraModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  IncubadoraModel({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory IncubadoraModel.fromJson(Map<String, dynamic> json) =>
      IncubadoraModel(
        id: json["id"],
        name: json["name"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  IncubadoraModel copyWith({
    int? id,
    String? name,
  }) =>
      IncubadoraModel(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  static List<IncubadoraModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => IncubadoraModel.fromJson(e)).toList();
}
