import 'package:google_geocoding_api/google_geocoding_api.dart';
import 'package:oilsavings/models/GasStationModel.dart'; // Asegúrate de importar correctamente tus modelos

class GeocodingService {
  final String apiKey = 'AIzaSyC4EClbyk-lhTAV0qURaU8uUdHxSeiMuhA';

  Future<GasStationData> fetchCoordinates(GasStationData station) async {
    RegExp regExp = RegExp(r'daddr=([^&]+)');
    String url = station.addressUrl!;

    print("URL LLAMADA PARA CONSEGUIR LAS COORDS EXACTAS: $url");

    RegExpMatch? match = regExp.firstMatch(url);

    if (match != null) {
      String daddr = match.group(1)!;
      print('El valor de daddr es: $daddr');

      List<String> stationCoords = daddr.split(",");

      if (stationCoords.length == 2) {
        double? latitude = double.tryParse(stationCoords[0]);
        double? longitude = double.tryParse(stationCoords[1]);

        if (latitude != null && longitude != null) {
          station.latitude = latitude;
          station.longitude = longitude;
          print('Latitude: ${station.latitude}');
          print('Longitude: ${station.longitude}');
        } else {
          print('Error al convertir las coordenadas.');
        }
      } else {
        print('Formato de coordenadas no válido.');
      }
    } else {
      print('No se encontró el valor de daddr');
    }

    return station;
  }

  Future<String> getAdress(String lat, String long) async {
    final api = GoogleGeocodingApi(apiKey);
    final reversedSearchResults = await api.reverse(
      "$lat,$long",
      language: 'es',
    );
    print(
        "REVERSED SEARCH RESULTS ${reversedSearchResults.results.elementAt(0)}");
    if (reversedSearchResults.results.isNotEmpty) {
      return reversedSearchResults.results.elementAt(0).formattedAddress;
    } else {
      throw Exception('Failed to fetch address or no results found');
    }
  }

  Future<String> getPlaceID(String lat, String long) async {
    final api = GoogleGeocodingApi(apiKey);
    final reversedSearchResults = await api.reverse(
      "$lat,$long",
      language: 'es',
    );
    // print(
    //     "REVERSED SEARCH RESULTS ${reversedSearchResults.results.first.formattedAddress}");
    if (reversedSearchResults.results.isNotEmpty) {
      return reversedSearchResults.results.elementAt(0).placeId;
    } else {
      throw Exception('Failed to fetch placeId or no results found');
    }
  }
}
