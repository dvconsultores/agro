import 'package:provider/provider.dart';
import 'package:sap_avicola/main_provider.dart';
import 'package:sap_avicola/utils/extensions/type_extensions.dart';
import 'package:sap_avicola/utils/general/context_utility.dart';

class ProfileModel implements DefaultModel {
  ProfileModel({
    required this.id,
    required this.nombre,
  });
  final int? id;
  final String nombre;

  @override
  Iterable get values => toJson().values;

  static ProfileModel get() =>
      ContextUtility.context!.read<MainProvider>().profile as ProfileModel;

  @override
  ProfileModel copyWith({
    int? id,
    String? nombre,
  }) =>
      ProfileModel(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
      );

  @override
  Map<String, dynamic> toJson() => {"id": id, "nombre": nombre};

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      ProfileModel(id: json["id"], nombre: json["nombre"] ?? "");

  static ProfileModel? fromJsonNullable(Map<String, dynamic>? json) =>
      json != null ? ProfileModel.fromJson(json) : null;
}
