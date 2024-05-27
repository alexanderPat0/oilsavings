import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:oilsavings/models/FuelDataModel.dart';
import 'package:oilsavings/models/GasStationModel.dart';
import 'package:oilsavings/screens/user/main_screen.dart';

class GasStationList extends StatefulWidget {
  final double latitude;
  final double longitude;
  final int radius;

  const GasStationList({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  @override
  _GasStationListState createState() => _GasStationListState();
}

class _GasStationListState extends State<GasStationList> {
  List<GasStationData> _stations = [];

  final apiKey = 'AIzaSyBmaXLlR-Pfgm1sfn-8oALHvu9Zf1fWT7k';

  @override
  void initState() {
    super.initState();
    _fetchGasStations();
  }

  Future<void> _fetchGasStations() async {
    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=${widget.latitude},${widget.longitude}'
        '&radius=${widget.radius}'
        '&type=gas_station'
        '&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        setState(() {
          _stations =
              results.map((json) => GasStationData.fromJson(json)).toList();
        });
        // Fetch details including fuel prices
        _fetchGasOptionsPrices();
      } else {
        throw Exception('Failed to load gas stations');
      }
    } catch (error) {
      print('Error fetching gas stations: $error');
    }
  }

  Future<void> _fetchGasOptionsPrices() async {
    for (var station in _stations) {
      final url =
          'https://places.googleapis.com/v1/places/${station.placeId}&fields=price_level&key=$apiKey';

      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final details = data['result'];
          setState(() {
            station.fuelPrices = (details['fuelOptions']['fuelPrices'] as List)
                .map((f) => FuelPrice.fromJson(f))
                .toList();
          });
        } else {
          print(
              'Failed to load details for station  ${response.statusCode}: ${response.body}');
        }
      } catch (error) {
        print('Error fetching fuel prices: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Gas Stations'),
      ),
      body: _stations.isEmpty
          ? const Center(child: Text('No gas stations found.'))
          : ListView.builder(
              itemCount: _stations.length,
              itemBuilder: (context, index) {
                final station = _stations[index];
                String img;
                if (station.name!.toLowerCase().contains('repsol')) {
                  img = "imgs/gas_station_img/repsol_icon.png";
                } else if (station.name!.toLowerCase().contains('cepsa')) {
                  img = "imgs/gas_station_img/cepsa_icon.png";
                } else if (station.name!.toLowerCase().contains('bp')) {
                  img = "imgs/gas_station_img/bp_icon.png";
                } else if (station.name!.toLowerCase().contains('shell')) {
                  img = "imgs/gas_station_img/shell_icon.png";
                } else {
                  img = "imgs/gas_station_img/default_station.png";
                }
                return Card(
                  child: ExpansionTile(
                    leading: Image.asset(img, width: 50, height: 50),
                    title: Text(station.name ?? 'Name not available'),
                    subtitle: Text(station.vicinity ?? 'No address available'),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildFuelPriceList(station.fuelPrices),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildFuelPriceList(List<FuelPrice>? prices) {
    if (prices == null || prices.isEmpty) {
      return const Text("No fuel price information available");
    } else {
      return Column(
        children: prices
            .map((price) => Text('${price.type}: ${price.price}'))
            .toList(),
      );
    }
  }
}
