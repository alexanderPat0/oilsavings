import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oilsavings/models/CarWashModel.dart';

class CarWashService {
  final apiKey = 'AIzaSyBmaXLlR-Pfgm1sfn-8oALHvu9Zf1fWT7k';

  Future<List<CarWashData>> fetchCarWash(
      String lat, String long, String radius) async {
    int rad = 1000 * int.parse(radius);
    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=$lat,$long'
        '&radius=$rad'
        '&type=car_wash'
        '&key=$apiKey';

    try {
      // Comentados print de depuración
      // print("URL: $url");
      final response = await http.get(Uri.parse(url));
      // print("RESPUESTA: ${response.statusCode}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // print("DATA: $data"); // Imprime los datos completos
        final List<dynamic> results = data['results'];
        // print("DATA RESULTS: $results"); // Imprime los resultados
        return results.map((json) => CarWashData.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load car wash locations');
      }
    } catch (error) {
      // print('Error fetching car wash locations: $error');
      return [];
    }
  }
}
