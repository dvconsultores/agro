import 'package:sap_avicola/utils/extensions/type_extensions.dart';

class EquiposModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  EquiposModel(
      {required this.id, required this.nombre, required this.descripcion});

  final int id;
  final String nombre;
  final String descripcion;

  factory EquiposModel.fromJson(Map<String, dynamic> json) => EquiposModel(
        id: json["id"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "descripcion": descripcion,
      };

  @override
  EquiposModel copyWith({
    int? id,
    String? nombre,
    String? descripcion,
  }) =>
      EquiposModel(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        descripcion: descripcion ?? this.descripcion,
      );

  static List<EquiposModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => EquiposModel.fromJson(e)).toList();
}
