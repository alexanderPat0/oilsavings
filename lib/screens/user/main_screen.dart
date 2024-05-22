import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:oilsavings/screens/access/login.dart';
import 'package:permission_handler/permission_handler.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  void _requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      await Permission.locationWhenInUse.request();
    }

    // Check if permissions were granted after the request
    if (await Permission.locationWhenInUse.isGranted) {
      // Permission granted, proceed to get location
      _getCurrentLocation();
    } else {
      // Handle the situation when the user denies the permission
      print("Location permission denied.");
    }
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print("Location: ${position.latitude}, ${position.longitude}");
      // Here you could update the state or perform additional operations with the location
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _logout(BuildContext context) {
    // Implementa la lógica de cerrar sesión aquí
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Botón de cerrar sesión en la esquina superior izquierda
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _logout(context),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botón grande en el centro
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade800,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'Main',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Fila de botones más pequeños debajo del botón grande
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSmallButton(context, 'Option 1'),
                      _buildSmallButton(context, 'Option 2'),
                      _buildSmallButton(context, 'Option 3'),
                      _buildSmallButton(context, 'Option 4'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Función para construir los botones pequeños
  Widget _buildSmallButton(BuildContext context, String label) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.orange.shade600,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
