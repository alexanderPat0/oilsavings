import 'package:flutter/material.dart';

class GasStationModel {
  bool? status;
  List<GasStationData>? results;
  String? htmlAttributions;

  GasStationModel({this.status, this.results, this.htmlAttributions});

  GasStationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] == "OK";
    htmlAttributions = json['html_attributions']?.join(", ");
    if (json['results'] != null) {
      results = List<GasStationData>.from(
          json['results'].map((x) => GasStationData.fromJson(x)));
    }
  }
}

class GasStationData {
  String? businessStatus;
  double? latitude;
  double? longitude;
  String? name;
  bool? openNow;
  String? placeId;
  double? rating;
  int? userRatingsTotal;
  String? vicinity;

  GasStationData({
    this.businessStatus,
    this.latitude,
    this.longitude,
    this.name,
    this.openNow,
    this.placeId,
    this.rating,
    this.userRatingsTotal,
    this.vicinity,
  });

  GasStationData.fromJson(Map<String, dynamic> json) {
    businessStatus = json['business_status'] as String?;
    latitude = (json['geometry']['location']['lat'] as num?)?.toDouble();
    longitude = (json['geometry']['location']['lng'] as num?)?.toDouble();
    name = json['name'] as String?;
    openNow = json['opening_hours'] != null
        ? json['opening_hours']['open_now'] as bool?
        : null;
    placeId = json['place_id'] as String?;
    rating = (json['rating'] as num?)?.toDouble();
    userRatingsTotal = json['user_ratings_total'] != null
        ? json['user_ratings_total'] as int?
        : null;
    vicinity = json['vicinity'] as String?;
  }
}
