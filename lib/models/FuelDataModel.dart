class FuelPrice {
  String type;
  double price;
  DateTime updateTime;

  FuelPrice(
      {required this.type, required this.price, required this.updateTime});

  factory FuelPrice.fromJson(Map<String, dynamic> json) {
    return FuelPrice(
      type: json['type'] as String,
      price: _parsePrice(json['price']),
      updateTime: DateTime.parse(json['updateTime']),
    );
  }

  static double _parsePrice(Map<String, dynamic> priceJson) {
    int units = int.parse(priceJson['units']);
    int nanos = priceJson['nanos'];
    return units + (nanos / 1e9);
  }
}
