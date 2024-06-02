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
  bool _isLoading = true;
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
    var stations = await GasStationService().fetchGasStations(
      // Coordenadas de Cádiz
      // await _geocodingService.getAdress("36.513056", "-6.278733"),
      await _geocodingService.getAdress(
          widget.latitude.toString(), widget.longitude.toString()),
      widget.favoriteFuelType,
      widget.radius.toString(),
    );

    Set<Marker> tempMarkers = {};
    for (var station in stations) {
      try {
        var updatedStation = await _geocodingService.fetchCoordinates(station);
        BitmapDescriptor icon = await _getMarkerIcon(updatedStation.name!);
        tempMarkers.add(Marker(
          markerId: MarkerId(updatedStation.id.toString()),
          position: LatLng(updatedStation.latitude!, updatedStation.longitude!),
          icon: icon,
          infoWindow: InfoWindow(
            title: updatedStation.name,
            snippet:
                'Precio del ${widget.favoriteFuelType}: ${updatedStation.pricePerLiter}\nDistancia: ${updatedStation.distance}',
          ),
        ));
      } catch (e) {
        print('Error fetching coordinates: $e');
      }
    }

    setState(() {
      _stations = stations;
      markers = tempMarkers;
      _isLoading = false;
    });
  }

  Future<BitmapDescriptor> _getMarkerIcon(String stationName) async {
    String imagePath;
    try {
      if (stationName.toLowerCase().contains("cepsa")) {
        imagePath = 'imgs/gas_station_img/markerCepsa.png';
      } else if (stationName.toLowerCase().contains("bp")) {
        imagePath = 'imgs/gas_station_img/markerBP.png';
      } else if (stationName.toLowerCase().contains("repsol")) {
        imagePath = 'imgs/gas_station_img/markerRepsol.png'; // Corrected path
      } else if (stationName.toLowerCase().contains("shell")) {
        imagePath = 'imgs/gas_station_img/markerShell.png'; // Corrected path
      } else {
        imagePath = 'imgs/gas_station_img/default_station.png';
      }
      return BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(30, 30)), imagePath,
          mipmaps: false);
    } catch (e) {
      print("ERROR EN EL _GET-MARKER-ICON: ${e}");
      return BitmapDescriptor.defaultMarker;
      ;
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gasolineras Cercanas")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
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
