class GasStationData {
  String? id;
  String? name;
  String? address;
  String? addressUrl;
  String? costDeposit;
  String? distance;
  String? pricePerLiter;
  double? latitude; // This will be set later once geocoded
  double? longitude; // This will be set later once geocoded

  GasStationData({
    this.id,
    this.name,
    this.address,
    this.addressUrl,
    this.costDeposit,
    this.distance,
    this.pricePerLiter,
    this.latitude,
    this.longitude,
  });

  factory GasStationData.fromJson(Map<String, dynamic> json) {
    return GasStationData(
      id: json['id'] as String?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      addressUrl: json['address_url'] as String?,
      costDeposit: json['cost_deposit'] as String?,
      distance: json['distance'] as String?,
      pricePerLiter: json['price_per_liter'] as String?,
      latitude: null, // Latitude and longitude are not directly from JSON
      longitude: null, // These will be set post instantiation
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'address_url': addressUrl,
      'cost_deposit': costDeposit,
      'distance': distance,
      'price_per_liter': pricePerLiter,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
