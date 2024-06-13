import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
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
  // Porque como hasta el state no lo uso, me da error por variable sin usar.
  // ignore: unused_field
  List<GasStationData>? _stations;
  final GeocodingService _geocodingService = GeocodingService();
  late GoogleMapController mapController;
  Set<Marker> markers = {};

  late Location _location;
  bool _locationServiceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  LocationData? _locationData;

  @override
  void initState() {
    super.initState();
    _location = new Location();
    _initializeLocation();
    _fetchGasStations();
  }

  Future<void> _initializeLocation() async {
    _locationServiceEnabled = await _location.serviceEnabled();
    if (!_locationServiceEnabled) {
      _locationServiceEnabled = await _location.requestService();
      if (!_locationServiceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await _location.getLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_locationData != null) {
      _updateUserLocation(_locationData!);
    }
  }

  void _updateUserLocation(LocationData locationData) {
    setState(() {
      markers.add(Marker(
        markerId: const MarkerId("user_location"),
        position: LatLng(locationData.latitude!, locationData.longitude!),
        infoWindow: const InfoWindow(title: "Your location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    });
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
        // Comprobar si las coordenadas de la API son mejores (mas exactas) que las de la URL
        // print("-----------");
        // print(
        //     "COORDENADAS COLOCADAS POR LA API: ${updatedStation.latitude}, ${updatedStation.longitude}");
        // print(
        //     "COORDENADAS EXACTAS SACADAS DE LA URL: ${updatedStation.addressUrl}");
        // print("-----------");
        try {
          // BitmapDescriptor icon = await _getMarkerIcon(updatedStation.name!);
          tempMarkers.add(Marker(
            markerId: MarkerId(updatedStation.id.toString()),
            position:
                LatLng(updatedStation.latitude!, updatedStation.longitude!),
            // icon: icon,
            infoWindow: InfoWindow(
              title: updatedStation.name,
              snippet:
                  'Precio del ${widget.favoriteFuelType}: ${updatedStation.pricePerLiter}',
            ),
          ));
        } catch (e2) {
          print('ERROR PLACING MARKERS: $e2');
        }
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

  // INTENTO DE PONER IMÁGENES PERSONALIZADAS EN LOS MARKERS.
  // Future<BitmapDescriptor> _getMarkerIcon(String stationName) async {
  //   String imagePath;
  //   try {
  //     if (stationName.toLowerCase().contains("cepsa")) {
  //       imagePath = 'imgs/gas_station_img/markerCepsa.png';
  //     } else if (stationName.toLowerCase().contains("bp")) {
  //       imagePath = 'imgs/gas_station_img/markerBP.png';
  //     } else if (stationName.toLowerCase().contains("repsol")) {
  //       imagePath = 'imgs/gas_station_img/markerRepsol.png';
  //     } else if (stationName.toLowerCase().contains("shell")) {
  //       imagePath = 'imgs/gas_station_img/markerShell.png';
  //     } else {
  //       imagePath = 'imgs/gas_station_img/default_station.png';
  //     }
  //     return BitmapDescriptor.fromAssetImage(
  //         const ImageConfiguration(size: Size(30, 30)), imagePath,
  //         mipmaps: false);
  //   } catch (e) {
  //     return BitmapDescriptor.defaultMarker;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gas Stations")),
      body: _isLoading
          ? Center(
              child: DefaultTextStyle(
                style: const TextStyle(fontSize: 20.0, color: Colors.black),
                child: AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText('Loading gas stations...'),
                    WavyAnimatedText("Maybe it's taking too long..."),
                  ],
                  isRepeatingAnimation: true,
                ),
              ),
            )
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
