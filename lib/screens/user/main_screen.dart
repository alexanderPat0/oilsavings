import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:oilsavings/screens/user/gas_station_map.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:oilsavings/screens/access/welcome.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double _currentSliderValue = 2; // Valor inicial del slider
  Position? _currentPosition;

// Suggested code may be subject to a license. Learn more: ~LicenseLog:2334053744.
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndService();
    _getCurrentLocation();
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    }
    return null;
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
            title: const Text("Location Services Disabled"),
            content: const Text("Please enable location services."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
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
      _currentPosition =
          await _getCurrentLocation(); // Get the current position and wait for it
      if (_currentPosition != null) {
        print(
            '\n\nCurrent Latitude:  ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}, Radio: ${(_currentSliderValue * 1000).toInt()}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GasStationList(
              latitude: _currentPosition!.latitude,
              longitude: _currentPosition!.longitude,
              radius: (_currentSliderValue * 1000).toInt(),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Location data is not available. Please try again."),
            duration: Duration(seconds: 5),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "To use the app you must allow it to access your location and have the location service active."),
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
                  const Center(
                    child: Text('Searching Range (in km):'),
                  ),
                  Slider(
                    value: _currentSliderValue,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: _currentSliderValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                      });
                    },
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

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomePage()),
    );
  }
}
