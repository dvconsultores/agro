import 'package:sap_avicola/utils/extensions/type_extensions.dart';

class GranjaModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  GranjaModel({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory GranjaModel.fromJson(Map<String, dynamic> json) => GranjaModel(
        id: json["id"],
        name: json["name"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  GranjaModel copyWith({
    int? id,
    String? name,
  }) =>
      GranjaModel(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  static List<GranjaModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => GranjaModel.fromJson(e)).toList();
}
