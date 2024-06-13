class ReviewData {
  String? placeIduserId;
  String? placeId;
  String? placeName;
  String? userId;
  String? username;
  String? review;
  String? rating;
  String? date;

  ReviewData(
      {this.placeIduserId,
      this.placeName,
      this.placeId,
      this.userId,
      this.username,
      this.review,
      this.rating,
      this.date});

  ReviewData.fromJson(Map<String, dynamic> json) {
    placeIduserId = json['placeIduserId'];
    placeName = json['placeName'];
    placeId = json['placeId'];
    userId = json['userId'];
    review = json['review'];
    username = json['username'];
    rating = json['rating'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['placeIduserId'] = placeIduserId;
    data['placeName'] = placeName;
    data['placeId'] = placeId;
    data['userId'] = userId;
    data['review'] = review;
    data['username'] = username;
    data['rating'] = rating;
    data['date'] = date;
    return data;
  }
}
