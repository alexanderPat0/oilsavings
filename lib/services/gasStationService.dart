import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:oilsavings/models/GasStationModel.dart';

class GasStationService {
  Future<List<GasStationData>> fetchGasStations(
      String address, String selectedFuel, String radius) async {
    String fuel = _convertFuelToValue(selectedFuel);
    print('FUEL: $fuel');
    print('ADDRESS: $address');
    final url =
        'http://34.175.24.171:8080/scrape?address=$address&selectedFuel=$fuel&radius=$radius';

    print('IMPRIMIR URL PARA PEDIR A PYTHON:---$url');
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null) {
          List<GasStationData> stations =
              data.map((json) => GasStationData.fromJson(json)).toList();
          return stations;
        } else {
          throw Exception('No results found in the API response');
        }
      } else {
        throw Exception(
            'Failed to load gas stations with status code: ${response.statusCode}');
      }
    } catch (error) {
      // print('Error fetching gas stations: $error');
      throw Exception('Failed to fetch gas stations');
    }
  }

  String _convertFuelToValue(String selectedFuel) {
    switch (selectedFuel) {
      case 'Sin Plomo 95':
        return 'GPR';
      case 'Sin Plomo 98':
        return 'G98';
      case 'Diesel':
        return 'GOA';
      case 'Diesel+':
        return 'NGO';
      default:
        return '';
    }
  }
}
