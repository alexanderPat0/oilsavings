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

Step 3: Update Android nconfigurations
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


https://codelabs.developers.google.com/codelabs/google-maps-in-flutter?hl=es-419#3    <----- Implementar Google Maps en mi App de Flutter


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

/*OTRA IDEA PARA LO DE LAS TARJETAS 


Sí, esa es una excelente idea y puede simplificar tanto la interfaz de usuario como la implementación. En lugar de manejar la visualización y la interacción en un mapa directamente, podrías presentar la información en tarjetas que muestren detalles importantes de las gasolineras cercanas. Esto puede mejorar la usabilidad y hacer la aplicación más accesible a usuarios que prefieren una interfaz más sencilla.

Plan de implementación:
Obtener la ubicación actual del usuario.
Solicitar gasolineras cercanas usando la Google Places API.
Mostrar la información de las gasolineras en tarjetas.
Incluir un botón en cada tarjeta para mostrar la ruta a la gasolinera seleccionada en Google Maps.
Permitir al usuario modificar el radio de búsqueda.
Paso 1: Configuración de permisos y APIs (ya lo hicimos anteriormente).
Paso 2: Crear el widget principal
Vamos a crear un widget principal que gestione la obtención de la ubicación, la solicitud a la API de Google Places y la visualización de las tarjetas.

dart
Copy code
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:url_launcher/url_launcher.dart';

class GasStationScreen extends StatefulWidget {
  @override
  _GasStationScreenState createState() => _GasStationScreenState();
}

class _GasStationScreenState extends State<GasStationScreen> {
  late Position _currentPosition;
  late GoogleMapsPlaces _places;
  List<PlacesSearchResult> _gasStations = [];
  int _radius = 5000; // Default radius in meters

  @override
  void initState() {
    super.initState();
    _places = GoogleMapsPlaces(apiKey: 'YOUR_API_KEY');
    _getUserLocation();
  }

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
    _getNearbyGasStations();
  }

  void _getNearbyGasStations() async {
    final location = Location(_currentPosition.latitude, _currentPosition.longitude);
    final result = await _places.searchNearbyWithRadius(location, _radius, type: 'gas_station');

    setState(() {
      _gasStations = result.results;
    });
  }

  void _launchMapsUrl(double lat, double lng) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Gas Stations'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _getNearbyGasStations,
          ),
        ],
      ),
      body: Column(
        children: [
          Slider(
            value: _radius.toDouble(),
            min: 1000,
            max: 20000,
            divisions: 19,
            label: "${_radius}m",
            onChanged: (value) {
              setState(() {
                _radius = value.toInt();
                _getNearbyGasStations();
              });
            },
          ),
          Expanded(
            child: _gasStations.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _gasStations.length,
                    itemBuilder: (context, index) {
                      final gasStation = _gasStations[index];
                      return Card(
                        child: ListTile(
                          title: Text(gasStation.name),
                          subtitle: Text(gasStation.vicinity),
                          trailing: IconButton(
                            icon: Icon(Icons.directions),
                            onPressed: () {
                              _launchMapsUrl(gasStation.geometry!.location.lat, gasStation.geometry!.location.lng);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
Explicación del código:
Obtener la ubicación del usuario:
Utilizamos el paquete geolocator para obtener la ubicación actual del usuario.

Solicitar gasolineras cercanas:
Utilizamos GoogleMapsPlaces para solicitar gasolineras cercanas en un radio determinado.

Mostrar la información en tarjetas:
Usamos un ListView.builder para mostrar una lista de tarjetas con la información de cada gasolinera. Cada tarjeta incluye el nombre y la dirección de la gasolinera.

Botón "Cómo llegar":
Cada tarjeta incluye un botón que abre Google Maps con la dirección de la gasolinera seleccionada, utilizando url_launcher.

Control deslizante para cambiar el radio de búsqueda:
Un Slider permite al usuario ajustar el radio de búsqueda de las gasolineras.

Paso 3: Navegar a la pantalla de gasolineras después del inicio de sesión
En tu lógica de inicio de sesión, navega a la GasStationScreen después de un inicio de sesión exitoso:

dart
Copy code
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => GasStationScreen()),
);
Con esta implementación, el usuario podrá ver una lista de gasolineras cercanas en tarjetas y obtener direcciones a cada gasolinera seleccionada a través de Google Maps, con la opción de ajustar el radio de búsqueda.

*/