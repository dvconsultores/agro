import 'package:sap_avicola/utils/extensions/type_extensions.dart';

class SemanaModel implements DefaultModel {
  @override
  Iterable<dynamic> get values => toJson().values;
  SemanaModel({
    required this.weekNumber,
    required this.weekDes,
  });

  final int weekNumber;
  final String weekDes;

  factory SemanaModel.fromJson(Map<String, dynamic> json) => SemanaModel(
        weekNumber: json["weekNumber"],
        weekDes: json["weekDes"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "weekNumber": weekNumber,
        "weekDes": weekDes,
      };

  @override
  SemanaModel copyWith({
    int? weekNumber,
    String? weekDes,
  }) =>
      SemanaModel(
        weekNumber: weekNumber ?? this.weekNumber,
        weekDes: weekDes ?? this.weekDes,
      );

  static List<SemanaModel> buildListFrom(List<dynamic> list) =>
      list.map((e) => SemanaModel.fromJson(e)).toList();
}
