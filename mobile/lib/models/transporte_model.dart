import 'package:sap_avicola/utils/extensions/type_extensions.dart';

class TransporteModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  TransporteModel({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory TransporteModel.fromJson(Map<String, dynamic> json) =>
      TransporteModel(
        id: json["id"],
        name: json["name"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  TransporteModel copyWith({
    int? id,
    String? name,
  }) =>
      TransporteModel(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  static List<TransporteModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => TransporteModel.fromJson(e)).toList();
}
