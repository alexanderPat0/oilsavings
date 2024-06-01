class GasStationData {
  String? id;
  String? name;
  String? address;
  String? addressUrl;
  String? costDeposit;
  String? distance;
  String? pricePerLiter;
  double? latitude; // Agregar latitud
  double? longitude; // Agregar longitud

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

  GasStationData.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    name = json['name'] as String;
    address = json['address'] as String;
    addressUrl = json['address_url'] as String;
    costDeposit = json['cost_deposit'] as String;
    distance = json['distance'] as String;
    pricePerLiter = json['price_per_liter'] as String;
    latitude = json['latitude'] as double?;
    longitude = json['longitude'] as double?;
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
