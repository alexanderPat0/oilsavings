import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:oilsavings/models/GasStationModel.dart';

class GasStationService {
  Future<List<GasStationData>> fetchGasStations(
      String address, String selectedFuel, String radius) async {
    final url =
        'http://34.175.24.171:8080/scrape?address=${Uri.encodeComponent(address)}&selectedFuel=${Uri.encodeComponent(selectedFuel)}&radius=${Uri.encodeComponent(radius)}';

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
      print('Error fetching gas stations: $error');
      throw Exception('Failed to fetch gas stations');
    }
  }
}
