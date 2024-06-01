import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oilsavings/models/ParkingModel.dart';

class ParkingService {
  final apiKey = 'AIzaSyC4EClbyk-lhTAV0qURaU8uUdHxSeiMuhA';

  Future<List<ParkingData>> fetchParking(
      String lat, String long, String radius) async {
    int rad = 1000 * int.parse(radius);
    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=$lat,$long'
        '&radius=$rad'
        '&type=parking'
        '&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => ParkingData.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load parking locations');
      }
    } catch (error) {
      // print('Error fetching parking locations: $error');
      return [];
    }
  }
}
