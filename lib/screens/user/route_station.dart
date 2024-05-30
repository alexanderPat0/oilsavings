import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  final double destinationLat;
  final double destinationLng;

  const MapScreen({
    super.key,
    required this.destinationLat,
    required this.destinationLng,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LocationData? _currentLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final locationData = await location.getLocation();
    setState(() {
      _currentLocation = locationData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    _currentLocation!.latitude!, _currentLocation!.longitude!),
                zoom: 14.0,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('currentLocation'),
                  position: LatLng(_currentLocation!.latitude!,
                      _currentLocation!.longitude!),
                  infoWindow: const InfoWindow(title: 'Your Location'),
                ),
                Marker(
                  markerId: const MarkerId('destination'),
                  position:
                      LatLng(widget.destinationLat, widget.destinationLng),
                  infoWindow: const InfoWindow(title: 'Gas Station'),
                ),
              },
              polylines: {
                Polyline(
                  polylineId: const PolylineId('route'),
                  points: [
                    LatLng(_currentLocation!.latitude!,
                        _currentLocation!.longitude!),
                    LatLng(widget.destinationLat, widget.destinationLng),
                  ],
                  color: Colors.blue,
                  width: 5,
                ),
              },
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
            ),
    );
  }
}
