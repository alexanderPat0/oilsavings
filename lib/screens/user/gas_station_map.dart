import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:http/http.dart' as http;
import 'package:oilsavings/models/GasStationModel.dart';
import 'dart:convert';
import 'package:chaleno/chaleno.dart';
import 'package:oilsavings/screens/user/route_station.dart';
import 'package:oilsavings/services/userServices.dart';

class GasStationList extends StatefulWidget {
  final double latitude;
  final double longitude;
  final int radius;
  final String favoriteFuelType;

  const GasStationList({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.favoriteFuelType,
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
    // _fetchGasStations();
    // _fetchPrices();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

  // Future<void> _fetchPrices() async {
  //   final parser = await Chaleno().load('https://www.dieselogasolina.com');
  //   if (parser != null) {
  //     final tablas = parser.querySelectorAll('.por_marcas table tbody tr');

  //     var sinPlomo95 = tablas[0]
  //         .text!
  //         .split("\n")
  //         .where((line) => line.trim().isNotEmpty)
  //         .toList();
  //     var sinPlomo98 = tablas[1]
  //         .text!
  //         .split("\n")
  //         .where((line) => line.trim().isNotEmpty)
  //         .toList();
  //     var diesel = tablas[2]
  //         .text!
  //         .split("\n")
  //         .where((line) => line.trim().isNotEmpty)
  //         .toList();
  //     var dieselPlus = tablas[3]
  //         .text!
  //         .split("\n")
  //         .where((line) => line.trim().isNotEmpty)
  //         .toList();

  //     setState(() {
  //       _prices['Repsol'] = {
  //         "Sin plomo 95": double.parse(
  //             sinPlomo95[2].trim().replaceAll('€/l', '').replaceAll(',', '.')),
  //         "Sin plomo 98": double.parse(
  //             sinPlomo98[2].trim().replaceAll('€/l', '').replaceAll(',', '.')),
  //         "Diesel": double.parse(
  //             diesel[2].trim().replaceAll('€/l', '').replaceAll(',', '.')),
  //         "Diesel+": double.parse(
  //             dieselPlus[2].trim().replaceAll('€/l', '').replaceAll(',', '.')),
  //       };
  //       _prices['Cepsa'] = {
  //         "Sin plomo 95": double.parse(
  //             sinPlomo95[3].trim().replaceAll('€/l', '').replaceAll(',', '.')),
  //         "Sin plomo 98": double.parse(
  //             sinPlomo98[3].trim().replaceAll('€/l', '').replaceAll(',', '.')),
  //         "Diesel": double.parse(
  //             diesel[3].trim().replaceAll('€/l', '').replaceAll(',', '.')),
  //         "Diesel+": double.parse(
  //             dieselPlus[3].trim().replaceAll('€/l', '').replaceAll(',', '.')),
  //       };
  //       _prices['Shell'] = {
  //         "Sin plomo 95": double.parse(
  //             sinPlomo95[5].trim().replaceAll('€/l', '').replaceAll(',', '.')),
  //         "Sin plomo 98": double.parse(
  //             sinPlomo98[5].trim().replaceAll('€/l', '').replaceAll(',', '.')),
  //         "Diesel": double.parse(
  //             diesel[5].trim().replaceAll('€/l', '').replaceAll(',', '.')),
  //         "Diesel+": double.parse(
  //             dieselPlus[5].trim().replaceAll('€/l', '').replaceAll(',', '.')),
  //       };
  //       _prices['BP'] = {
  //         "Sin plomo 95": double.parse(
  //             sinPlomo95[6].trim().replaceAll('€/l', '').replaceAll(',', '.')),
  //         "Sin plomo 98": double.parse(
  //             sinPlomo98[6].trim().replaceAll('€/l', '').replaceAll(',', '.')),
  //         "Diesel": double.parse(
  //             diesel[6].trim().replaceAll('€/l', '').replaceAll(',', '.')),
  //         "Diesel+": double.parse(
  //             dieselPlus[6].trim().replaceAll('€/l', '').replaceAll(',', '.')),
  //       };
  //     });
  //   }
  // }

  // Future<void> _fetchGasStations() async {
  //   final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
  //       '?location=${widget.latitude},${widget.longitude}'
  //       '&radius=${widget.radius}'
  //       '&type=gas_station'
  //       '&key=$apiKey';

  //   try {
  //     final response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       final List<dynamic> results = data['results'];
  //       setState(() {
  //         _stations =
  //             results.map((json) => GasStationData.fromJson(json)).toList();
  //         _stations.sort((a, b) => _comparePrices(
  //             a, b)); // Ordenar por precio del combustible favorito
  //       });
  //     } else {
  //       throw Exception('Failed to load gas stations');
  //     }
  //   } catch (error) {
  //     print('Error fetching gas stations: $error');
  //   }
  // }


//   @override
//   Widget build(BuildContext context) {
//     if (_stations.isEmpty) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Nearby Gas Stations'),
//         ),
//         body: const Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Nearby Gas Stations'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: _stations.length,
//               itemBuilder: (context, index) {
//                 final station = _stations[index];
//                 String img;
//                 Map<String, double>? fuelPrices;

//                 if (station.name!.toLowerCase().contains('repsol')) {
//                   img = "imgs/gas_station_img/repsol_icon.png";
//                   fuelPrices = _prices['Repsol'];
//                 } else if (station.name!.toLowerCase().contains('cepsa')) {
//                   img = "imgs/gas_station_img/cepsa_icon.png";
//                   fuelPrices = _prices['Cepsa'];
//                 } else if (station.name!.toLowerCase().contains('bp')) {
//                   img = "imgs/gas_station_img/bp_icon.png";
//                   fuelPrices = _prices['BP'];
//                 } else if (station.name!.toLowerCase().contains('shell')) {
//                   img = "imgs/gas_station_img/shell_icon.png";
//                   fuelPrices = _prices['Shell'];
//                 } else {
//                   img = "imgs/gas_station_img/default_station.png";
//                 }

//                 return Card(
//                   child: ExpansionTile(
//                     leading: Image.asset(img, width: 50, height: 50),
//                     title: Text(station.name ?? 'Name not available'),
//                     subtitle: Text(station.vicinity ?? 'No address available'),
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             _buildOpenStatus(station.openNow),
//                             Text(
//                                 'Rating: ${station.rating} (${station.userRatingsTotal} reviews)'),
//                             const SizedBox(height: 20),
//                             fuelPrices != null
//                                 ? Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: fuelPrices.entries
//                                         .map((entry) => Text(
//                                             '${entry.key}: ${entry.value.toStringAsFixed(3)} €/l'))
//                                         .toList(),
//                                   )
//                                 : const Text('Fuel prices not available'),
//                             const SizedBox(height: 20),
//                             Align(
//                               alignment: Alignment.centerLeft,
//                               child: OutlinedButton(
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => MapScreen(
//                                         destinationLat:
//                                             station.latitude ?? 36.509191,
//                                         destinationLng:
//                                             station.longitude ?? -6.274902,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 child: const Text('More Info'),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOpenStatus(bool? isOpen) {
//     if (isOpen == null) {
//       return const Text('Open status: Unknown',
//           style: TextStyle(color: Colors.grey));
//     } else {
//       return Text('Open Now: ${isOpen ? "Yes" : "No"}',
//           style: TextStyle(color: isOpen ? Colors.green : Colors.red));
//     }
//   }

//   String getBrandFromName(String? name) {
//     if (name == null) return 'Unknown';
//     name = name.toLowerCase();
//     if (name.toLowerCase().contains('repsol')) return 'Repsol';
//     if (name.toLowerCase().contains('cepsa')) return 'Cepsa';
//     if (name.toLowerCase().contains('bp')) return 'BP';
//     if (name.toLowerCase().contains('shell')) return 'Shell';
//     return 'Unknown';
//   }
// }
