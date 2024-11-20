import 'package:sap_avicola/utils/extensions/type_extensions.dart';

class VacunaModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  VacunaModel({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory VacunaModel.fromJson(Map<String, dynamic> json) => VacunaModel(
        id: json["id"],
        name: json["nombre"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  VacunaModel copyWith({
    int? id,
    String? name,
  }) =>
      VacunaModel(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  static List<VacunaModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => VacunaModel.fromJson(e)).toList();
}
