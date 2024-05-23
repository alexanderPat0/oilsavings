import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:oilsavings/screens/access/welcome.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    _checkPermissionsAndService();
  }

  void _checkPermissionsAndService() async {
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      await Permission.locationWhenInUse.request();
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Prompt the user to enable the location services.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Location Services Disabled"),
            content: Text("Please enable location services."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }

  void _handleButtonPress(BuildContext context, VoidCallback onSuccess) async {
    if (await Permission.locationWhenInUse.isGranted &&
        await Geolocator.isLocationServiceEnabled()) {
      onSuccess();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Para usar la aplicación debes permitir el uso de la ubicación y asegurar que el servicio de ubicación esté activo."),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () =>
                    _handleButtonPress(context, () => _logout(context)),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade800,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: TextButton(
                        onPressed: () => _handleButtonPress(context, () {}),
                        child: const Text(
                          'Main',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSmallButton(context, 'Option 1', () {}),
                      _buildSmallButton(context, 'Option 2', () {}),
                      _buildSmallButton(context, 'Option 3', () {}),
                      _buildSmallButton(context, 'Option 4', () {}),
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

  Widget _buildSmallButton(
      BuildContext context, String label, VoidCallback onPress) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.orange.shade600,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: TextButton(
          onPressed: () => _handleButtonPress(context, onPress),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomePage()),
    );
  }
}
