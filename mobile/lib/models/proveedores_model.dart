import 'package:sap_avicola/utils/extensions/type_extensions.dart';

class ProveedorModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  ProveedorModel({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory ProveedorModel.fromJson(Map<String, dynamic> json) => ProveedorModel(
        id: json["id"],
        name: json["name"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  ProveedorModel copyWith({
    int? id,
    String? name,
  }) =>
      ProveedorModel(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  static List<ProveedorModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => ProveedorModel.fromJson(e)).toList();
}
