import 'package:google_geocoding_api/google_geocoding_api.dart';
import 'package:oilsavings/models/GasStationModel.dart'; // Asegúrate de importar correctamente tus modelos

class GeocodingService {
  final String apiKey = 'AIzaSyC4EClbyk-lhTAV0qURaU8uUdHxSeiMuhA';

  Future<GasStationData> fetchCoordinates(GasStationData station) async {
    final api = GoogleGeocodingApi(apiKey);
    if (station.address != null) {
      final searchResults = await api.search(station.address!, language: 'es');
      if (searchResults.results.isNotEmpty) {
        final location = searchResults.results.first.geometry!.location;
        station.latitude = location.lat;
        station.longitude = location.lng;
      }
    } else {
      throw Exception("La dirección de la gasolinera no puede ser nula.");
    }
    return station;
  }

  Future<GoogleGeocodingResponse> getCoords(String direction) async {
    final api = GoogleGeocodingApi(apiKey);
    final searchResults = await api.search(
      direction,
      language: 'es',
    );
    return searchResults;
  }

  Future<String> getAdress(String lat, String long) async {
    final api = GoogleGeocodingApi(apiKey);
    final reversedSearchResults = await api.reverse(
      "$lat,$long",
      language: 'es',
    );
    // print(
    //     "REVERSED SEARCH RESULTS ${reversedSearchResults.results.first.formattedAddress}");
    if (reversedSearchResults.results.isNotEmpty) {
      return reversedSearchResults.results.first.formattedAddress;
    } else {
      throw Exception('Failed to fetch address or no results found');
    }
  }
}
  // final geocodingService = GeocodingService();

  // Llamar al método getCoords y manejar el resultado
  // try {
  //   final response = await geocodingService.getAdress();
  // Puedes hacer algo con la respuesta, como mostrar un diálogo con la información
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       final results = response.results.toList();
  //       return AlertDialog(
  //         title: Text('Geocoding Results'),
  //         content: SizedBox(
  //           height: 200,
  //           child: ListView.builder(
  //             itemCount: results.length,
  //             itemBuilder: (context, index) {
  //               final result = results[index];
  //               return ListTile(
  //                 title: Text(result.formattedAddress),
  //                 subtitle: Text(
  //                     'Lat: ${result.geometry!.location.lat}, Lng: ${result.geometry!.location.lng}'),
  //               );
  //             },
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('OK'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // } catch (e) {
  // Manejar errores
  //   print('Error: $e');
  // }
