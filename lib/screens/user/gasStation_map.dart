import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oilsavings/models/GasStationModel.dart';
import 'package:oilsavings/services/addressCoordsService.dart';
import 'package:oilsavings/services/gasStationService.dart';

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
  final apiKey = 'AIzaSyC4EClbyk-lhTAV0qURaU8uUdHxSeiMuhA';
  List<GasStationData>? _stations;
  final GeocodingService _geocodingService = GeocodingService();
  late GoogleMapController mapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _fetchGasStations();
  }

  void _fetchGasStations() async {
    print(
        "LATITUD Y LONGITUD: ${widget.latitude.toString()},${widget.longitude.toString()}");
    print("COMBUSTIBLE PREFERIDO: ${widget.favoriteFuelType}");
    print("RADIO STRING: ${widget.radius.toString()}");
    String formattedAddress = await _geocodingService.getAdress(
        widget.latitude.toString(), widget.longitude.toString());

    print('FORMATTED ADDRESS: $formattedAddress');

    var stations = await GasStationService().fetchGasStations(
      formattedAddress,
      widget.favoriteFuelType,
      widget.radius.toString(),
    );

    List<GasStationData> tempStations = [];
    for (var station in stations) {
      try {
        var updatedStation = await _geocodingService.fetchCoordinates(station);
        print("GASOLINERA ACTUALIZADA: ${updatedStation.toString()}");
        tempStations.add(updatedStation);
      } catch (e) {
        print('Error fetching coordinates: $e');
      }
    }

    setState(() {
      _stations = tempStations;
      markers = _stations!
          .map((station) => Marker(
                markerId: MarkerId(station.id.toString()),
                position: LatLng(station.latitude!, station.longitude!),
                infoWindow: InfoWindow(
                  title: station.name,
                  snippet:
                      'Precio del ${widget.favoriteFuelType}: ${station.pricePerLiter}',
                ),
              ))
          .toSet();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gasolineras Cercanas")),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: 12.0,
        ),
        markers: markers,
      ),
    );
  }
}
