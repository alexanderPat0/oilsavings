/*

    Sure, I can help you with that. To create a Flutter screen that displays a map with the user's location and marks nearby gas stations using Google Maps and the Google Places API, you'll need to follow these steps:

Set up your Flutter project:

Add the necessary dependencies in your pubspec.yaml file.
Get API keys for Google Maps and Google Places API.
Add dependencies:

google_maps_flutter: To display the map.
geolocator: To get the user's current location.
google_maps_webservice: To interact with the Google Places API.

Step 1: Add dependencies
Add these dependencies to your pubspec.yaml file:

dependencies:
  flutter:
    sdk: flutter
  google_maps_flutter: ^2.1.1
  geolocator: ^8.2.0
  google_maps_webservice: ^0.0.20

Step 2: Get API keys
Get your API keys from the Google Cloud Console and enable the Google Maps SDK for Android/iOS and Google Places API.

Step 3: Update Android and iOS configurations
Android
Add your API key to the android/app/src/main/AndroidManifest.xml:

<application>
    <!-- Add this meta-data tag -->
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="YOUR_API_KEY"/>
</application>

*/

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  LatLng _initialPosition; // Default location (San Francisco)
  final Set<Marker> _markers = {};
  final _places = GoogleMapsPlaces(apiKey: 'YOUR_API_KEY');
  
  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
    _mapController.animateCamera(
      CameraUpdate.newLatLng(_initialPosition),
    );
    _getNearbyGasStations();
  }

  void _getNearbyGasStations() async {
    final location = Location(_initialPosition.latitude, _initialPosition.longitude);
    final result = await _places.searchNearbyWithRadius(location, 5000, type: 'gas_station');

    setState(() {
      _markers.clear();
      result.results.forEach((place) {
        _markers.add(
          Marker(
            markerId: MarkerId(place.placeId),
            position: LatLng(place.geometry!.location.lat, place.geometry!.location.lng),
            infoWindow: InfoWindow(title: place.name),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Gas Stations'),
      ),
      body: _initialPosition == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 14,
              ),
              markers: _markers,
            ),
    );
  }
}
