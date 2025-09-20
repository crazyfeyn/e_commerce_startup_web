// To parse this JSON data, do
//
//     final measurementModel = measurementModelFromMap(jsonString);

import 'dart:convert';

MeasurementModel measurementModelFromMap(String str) => MeasurementModel.fromMap(json.decode(str));

String measurementModelToMap(MeasurementModel data) => json.encode(data.toMap());

class MeasurementModel {
  final int? id;
  final String? title;
  final String? label;

  MeasurementModel({
    this.id,
    this.title,
    this.label,
  });

  MeasurementModel copyWith({
    int? id,
    String? title,
    String? label,
  }) =>
      MeasurementModel(
        id: id ?? this.id,
        title: title ?? this.title,
        label: label ?? this.label,
      );

  factory MeasurementModel.fromMap(Map<String, dynamic> json) => MeasurementModel(
    id: json["id"],
    title: json["title"],
    label: json["label"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "label": label,
  };
}
