import 'package:google_geocoding_api/google_geocoding_api.dart';

class GeocodingService {
  final String apiKey = 'AIzaSyBmaXLlR-Pfgm1sfn-8oALHvu9Zf1fWT7k';

  Future<GoogleGeocodingResponse> getCoords(String direction) async {
    final api = GoogleGeocodingApi(apiKey);
    final searchResults = await api.search(
      direction,
      language: 'es',
    );
    return searchResults;
  }

  Future<GoogleGeocodingResponse> getAdress(String lat, String long) async {
    final api = GoogleGeocodingApi(apiKey);
    final reversedSearchResults = await api.reverse(
      "$lat, $long",
      language: 'es',
    );
    return reversedSearchResults;
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
