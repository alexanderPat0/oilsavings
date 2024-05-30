import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oilsavings/models/GasStationModel.dart';
import 'dart:convert';
import 'package:chaleno/chaleno.dart';
import 'package:oilsavings/screens/user/route_station.dart';

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
  Map<String, String> _repsol = {};
  Map<String, String> _cepsa = {};
  Map<String, String> _shell = {};
  Map<String, String> _bp = {};
  final apiKey = 'AIzaSyBmaXLlR-Pfgm1sfn-8oALHvu9Zf1fWT7k';

  @override
  void initState() {
    super.initState();
    _fetchGasStations();
    _fetchPrices();
  }

  Future<void> _fetchPrices() async {
    final parser = await Chaleno().load('https://www.dieselogasolina.com');
    if (parser != null) {
      final tablas = parser.querySelectorAll('.por_marcas table tbody tr');

      var sinPlomo95 = tablas[0].text!.split("\n");
      var sinPlomo98 = tablas[1].text!.split("\n");
      var diesel = tablas[2].text!.split("\n");
      var dieselPlus = tablas[3].text!.split("\n");

      Map<String, String> repsol = {
        "Sin plomo 95": sinPlomo95[2].trim(),
        "Sin plomo 98": sinPlomo98[2].trim(),
        "Diesel": diesel[2].trim(),
        "Diesel+": dieselPlus[2].trim(),
      };
      Map<String, String> cepsa = {
        "Sin plomo 95": sinPlomo95[3].trim(),
        "Sin plomo 98": sinPlomo98[3].trim(),
        "Diesel": diesel[3].trim(),
        "Diesel+": dieselPlus[3].trim(),
      };
      Map<String, String> shell = {
        "Sin plomo 95": sinPlomo95[5].trim(),
        "Sin plomo 98": sinPlomo98[5].trim(),
        "Diesel": diesel[5].trim(),
        "Diesel+": dieselPlus[5].trim(),
      };

      Map<String, String> bp = {
        "Sin plomo 95": sinPlomo95[6].trim(),
        "Sin plomo 98": sinPlomo98[6].trim(),
        "Diesel": diesel[6].trim(),
        "Diesel+": dieselPlus[6].trim(),
      };

      print(repsol);
      print(cepsa);
      print(shell);
      print(bp);

      setState(() {
        _bp = bp;
        _cepsa = cepsa;
        _repsol = repsol;
        _shell = shell;
      });

      // INTENTO DE HACER BIEN LA LÓGICA PARA RECOGER LOS DATOS DE LA TABLA:
      // for (var row in tablas!) {
      //   final cells = row.querySelectorAll('td');
      //   if (cells!.isNotEmpty) {
      //     String fuelType = cells[0].text!.trim();
      //     List<String> brands = ['Repsol', 'Cepsa', 'Shell', 'BP'];
      //     for (int i = 1; i <= brands.length; i++) {
      //       String brand = brands[i - 1];
      //       double price = double.tryParse(cells[i]
      //               .text!
      //               .trim()
      //               .replaceAll('€/l', '')
      //               .replaceAll(',', '.')) ??
      //           0.0;
      //       if (!prices.containsKey(brand)) {
      //         prices[brand] = {};
      //       }
      //       prices[brand]![fuelType] = price;
      //     }
      //   }
      // }
      // setState(() {});
    }
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
      } else {
        throw Exception('Failed to load gas stations');
      }
    } catch (error) {
      print('Error fetching gas stations: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Stations: ${_stations[1].name}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Gas Stations'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _stations.isEmpty
                ? const Center(child: Text('No gas stations found.'))
                : ListView.builder(
                    itemCount: _stations.length,
                    itemBuilder: (context, index) {
                      final station = _stations[index];
                      String img;
                      String brand = getBrandFromName(station.name);
                      Map<String, String>? fuelPrices;

                      if (station.name!.toLowerCase().contains('repsol')) {
                        img = "imgs/gas_station_img/repsol_icon.png";
                        fuelPrices = _repsol;
                      } else if (station.name!
                          .toLowerCase()
                          .contains('cepsa')) {
                        img = "imgs/gas_station_img/cepsa_icon.png";
                        fuelPrices = _cepsa;
                      } else if (station.name!.toLowerCase().contains('bp')) {
                        img = "imgs/gas_station_img/bp_icon.png";
                        fuelPrices = _bp;
                      } else if (station.name!
                          .toLowerCase()
                          .contains('shell')) {
                        img = "imgs/gas_station_img/shell_icon.png";
                        fuelPrices = _shell;
                      } else {
                        img = "imgs/gas_station_img/default_station.png";
                      }

                      return Card(
                        child: ExpansionTile(
                          leading: Image.asset(img, width: 50, height: 50),
                          title: Text(station.name ?? 'Name not available'),
                          subtitle:
                              Text(station.vicinity ?? 'No address available'),
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  _buildOpenStatus(station.openNow),
                                  Text(
                                      'Rating: ${station.rating} (${station.userRatingsTotal} reviews)'),
                                  const SizedBox(height: 20),
                                  fuelPrices != null
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: fuelPrices.entries
                                              .map((entry) => Text(
                                                  '${entry.key}: ${entry.value}'))
                                              .toList(),
                                        )
                                      : const Text('Fuel prices not available'),
                                  const SizedBox(height: 20),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MapScreen(
                                              destinationLat:
                                                  station.latitude ?? 36.509191,
                                              destinationLng:
                                                  station.longitude ??
                                                      -6.274902,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('More Info'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpenStatus(bool? isOpen) {
    if (isOpen == null) {
      return const Text('Open status: Unknown',
          style: TextStyle(color: Colors.grey));
    } else {
      return Text('Open Now: ${isOpen ? "Yes" : "No"}',
          style: TextStyle(color: isOpen ? Colors.green : Colors.red));
    }
  }

  String getBrandFromName(String? name) {
    if (name == null) return 'Unknown';
    name = name.toLowerCase();
    if (name.toLowerCase().contains('repsol')) return 'Repsol';
    if (name.toLowerCase().contains('cepsa')) return 'Cepsa';
    if (name.toLowerCase().contains('bp')) return 'BP';
    if (name.toLowerCase().contains('shell')) return 'Shell';
    return 'Unknown';
  }
}
