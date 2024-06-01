class ParkingModel {
  bool? status;
  List<ParkingData>? results;
  String? htmlAttributions;

  ParkingModel({this.status, this.results, this.htmlAttributions});

  ParkingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] == "OK";
    htmlAttributions = json['html_attributions']?.join(", ");
    if (json['results'] != null) {
      results = List<ParkingData>.from(
          json['results'].map((x) => ParkingData.fromJson(x)));
    }
  }
}

class ParkingData {
  String? businessStatus;
  double? latitude;
  double? longitude;
  String? id;
  String? name;
  bool? openNow;
  String? placeId;
  double? rating;
  int? userRatingsTotal;
  String? vicinity;

  ParkingData({
    this.businessStatus,
    this.latitude,
    this.longitude,
    this.id,
    this.name,
    this.openNow,
    this.placeId,
    this.rating,
    this.userRatingsTotal,
    this.vicinity,
  });
  ParkingData.fromJson(Map<String, dynamic> json) {
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
