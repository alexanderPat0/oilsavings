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
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);
 
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  LatLng _initialPosition = LatLng(37.77483, -122.41942); // Default location (San Francisco)
  final Set<Marker> _markers = {};
  final _places = GoogleMapsPlaces(apiKey: 'YOUR_API_KEY');
  
  @override
  void initState() {
    super.initState();
    _checkPermissionsAndGetLocation();
  }

  void _checkPermissionsAndGetLocation() async {
    var status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      if (await Permission.locationWhenInUse.request().isGranted) {
        _getUserLocation();
      } else {
        // Handle permission denial
        print("Location permission denied");
      }
    } else if (status.isGranted) {
      _getUserLocation();
    }
  }

  void _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, request user to enable it.
      serviceEnabled = await Geolocator.openLocationSettings();
      if (!serviceEnabled) {
        return;
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next step is to show a dialog
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately
      return;
    } 

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

/*

Para solicitar permisos de ubicación y manejar el caso en que la ubicación no esté activada, puedes usar el paquete permission_handler para Flutter. Este paquete permite solicitar permisos y verificar el estado de los permisos en tiempo de ejecución.

Paso 1: Agregar la dependencia
Agrega permission_handler a tu pubspec.yaml:

dependencies:
  flutter:
    sdk: flutter
  google_maps_flutter: ^2.1.1
  geolocator: ^8.2.0
  google_maps_webservice: ^0.0.20
  permission_handler: ^10.2.0

Paso 2: Configurar Android
Añade las siguientes líneas a tu AndroidManifest.xml para solicitar permisos de ubicación:

<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>

También, actualiza android/app/src/main/AndroidManifest.xml para permitir la verificación de permisos:

<application
    android:requestLegacyExternalStorage="true"
    ...>
    ...
</application>

Paso 4: Manejar la habilitación de servicios de ubicación
Este código ahora verifica los permisos y habilita los servicios de ubicación si no están activados. La aplicación solicitará 
los permisos necesarios y abrirá la configuración de ubicación si está deshabilitada. Si los permisos son concedidos y los servicios 
de ubicación están habilitados, se obtiene la ubicación actual del usuario y se muestran las estaciones de servicio cercanas en el mapa.

Paso 5: Ejecutar la aplicación
Ejecuta tu aplicación y prueba el flujo completo para asegurarte de que los permisos de ubicación son solicitados correctamente 
y las estaciones de servicio cercanas se muestran en el mapa.

*/