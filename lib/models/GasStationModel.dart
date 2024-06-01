class GasStationData {
  String? id;
  String? name;
  String? address;
  String? addressUrl;
  String? costDeposit;
  String? distance;
  String? pricePerLiter;

  GasStationData({
    this.id,
    this.name,
    this.address,
    this.addressUrl,
    this.costDeposit,
    this.distance,
    this.pricePerLiter,
  });

  GasStationData.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    name = json['name'] as String;
    address = json['address'] as String;
    addressUrl = json['address_url'] as String;
    costDeposit = json['cost_deposit'] as String;
    distance = json['distance'] as String;
    pricePerLiter = json['price_per_liter'] as String;
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
    };
  }
}
