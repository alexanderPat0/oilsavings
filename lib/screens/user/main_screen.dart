import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:oilsavings/screens/user/parking_map.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:oilsavings/screens/user/carWash_map.dart';
import 'package:oilsavings/services/userService.dart';
import 'package:oilsavings/screens/access/welcome.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double _currentSliderValue = 2;
  Position? _currentPosition;
  String? _favoriteFuelType;
  String? _username;
  final user = FirebaseAuth.instance.currentUser;

  final List<String> _fuelTypes = [
    'Sin Plomo 95',
    'Sin Plomo 98',
    'Diesel',
    'Diesel+',
  ];

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndService();
    _getCurrentLocation();
    _loadUserMainFuel();
    _loadUsername();
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

  void _getLocationAndProceed(BuildContext context, VoidCallback onSuccess,
      Widget Function(double, double, int) navigateToPage) async {
    if (await Permission.locationWhenInUse.isGranted &&
        await Geolocator.isLocationServiceEnabled()) {
      _currentPosition = await _getCurrentLocation();
      if (_currentPosition != null) {
        // Asegurarme de que los datos se envían bien
        // print(
        //     '\n\nCurrent Latitude:  ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}, Radio: ${(_currentSliderValue * 1000).toInt()}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => navigateToPage(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
              (_currentSliderValue).toInt(),
            ),
          ),
        );
        onSuccess();
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

  void _getGasStations(BuildContext context, VoidCallback onSuccess) {
    // _getLocationAndProceed(
    //   context,
    //   onSuccess,
    //   (latitude, longitude, radius) => GasStationList(
    //     favoriteFuelType: _favoriteFuelType!,
    //     latitude: latitude,
    //     longitude: longitude,
    //     radius: radius,
    //   ),
    // );
  }

  void _getCarWash(BuildContext context, VoidCallback onSuccess) {
    _getLocationAndProceed(
      context,
      onSuccess,
      (latitude, longitude, radius) => CarWashList(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
      ),
    );
  }

  void _getParking(BuildContext context, VoidCallback onSuccess) {
    _getLocationAndProceed(
      context,
      onSuccess,
      (latitude, longitude, radius) => ParkingList(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
      ),
    );
  }

  Future<void> _loadUserMainFuel() async {
    if (user != null) {
      try {
        String mainFuel = await UserService().getMainFuel();
        if (_fuelTypes.contains(mainFuel)) {
          setState(() {
            _favoriteFuelType = mainFuel;
          });
        } else {
          setState(() {
            _favoriteFuelType = _fuelTypes.first;
          });
        }
      } catch (e) {
        // Imprimo error
        // print('Error fetching main fuel: $e');
        setState(() {
          _favoriteFuelType = _fuelTypes.first;
        });
      }
    }
  }

  Future<void> _loadUsername() async {
    if (user != null) {
      try {
        String username = await UserService().getUsername();
        setState(() {
          _username = username;
        });
      } catch (e) {
        // Imprimo error
        // print('Error fetching username: $e');
      }
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
                onPressed: () => _logout(context),
              ),
            ),
            Positioned(
              top: 10,
              right: 20,
              child: Align(
                alignment: Alignment.topRight,
                child: _username != null
                    ? Text(
                        "Hello $_username!",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 16),
                      )
                    : const Text("Loading..."),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Nearby fuel stations"),
                  const SizedBox(height: 5),
                  TextButton(
                    onPressed: () => _getGasStations(context, () {}),
                    child: Image.asset(
                      "imgs/randomIcon/oilsavings.png",
                      width: 100,
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 5),
                  _favoriteFuelType != null
                      ? _buildDropdown()
                      : const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          TextButton(
                            onPressed: () => _getCarWash(context, () {}),
                            child: Image.asset(
                              "imgs/randomIcon/sponge.png",
                              width: 100,
                              height: 100,
                            ),
                          ),
                          const Text(
                            'Nearby\ncar washes',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          TextButton(
                            onPressed: () => _getParking(context, () {}),
                            child: Image.asset(
                              "imgs/randomIcon/parkingIcon.png",
                              width: 100,
                              height: 100,
                            ),
                          ),
                          const Text(
                            'Nearby\nparkings',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
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

  Widget _buildDropdown() {
    return Column(
      children: [
        const Text("Preferred fuel: "),
        DropdownButton<String>(
          value: _favoriteFuelType,
          items: _fuelTypes.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            UserService().changeMainFuel(newValue!);
            setState(() {
              _favoriteFuelType = newValue;
            });
          },
        ),
      ],
    );
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomePage()),
    );
  }
}
