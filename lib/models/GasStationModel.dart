import 'dart:ffi';

import 'package:flutter/material.dart';

class GasStations {

  bool? success;
  List<GasStationData>? data;
  String? message;

  GasStations({this.success, this.data, this.message});

  GasStations.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <GasStationData>[];
      json['data'].forEach((v) {
        data!.add(GasStationData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class GasStationData {
  int? id;
  String? company;
  String? location;
  int? valoration;
  Map<String, int>? fuelPrices; // Map for key-value pairs
  DateTime? createdAt;
  DateTime? updatedAt;

  GasStationData({
    this.id,
    this.company,
    this.location,
    this.valoration,
    this.fuelPrices,
    this.createdAt,
    this.updatedAt,
  });


   GasStationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    company = json['company'];
    location = json['location'];
    valoration = json['valoration'];
    // Convert fuelPrices from Map<String, dynamic> to Map<String, int>
    if (json['fuelPrices'] != null) {
      fuelPrices = Map<String, int>.from(json['fuelPrices']);
    }
    createdAt = json['created_at'] != null ? DateTime.parse(json['created_at']) : null;
    updatedAt = json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company'] = company;
    data['location'] = location;
    data['valoration'] = valoration;
    data['fuelPrices'] = fuelPrices;
    data['created_at'] = createdAt?.toIso8601String();
    data['updated_at'] = updatedAt?.toIso8601String();
    return data;
  }

}
