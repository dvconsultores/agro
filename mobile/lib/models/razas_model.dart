import 'package:sap_avicola/utils/extensions/type_extensions.dart';

class RazasModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  RazasModel({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory RazasModel.fromJson(Map<String, dynamic> json) => RazasModel(
        id: json["id"],
        name: json["name"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  RazasModel copyWith({
    int? id,
    String? name,
  }) =>
      RazasModel(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  static List<RazasModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => RazasModel.fromJson(e)).toList();
}
