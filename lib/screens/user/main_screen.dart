import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:oilsavings/screens/user/gas_station_map.dart';
import 'package:oilsavings/services/userService.dart';
import 'package:permission_handler/permission_handler.dart';

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
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    }
    return null;
  }

  void _comprobarUsuarioLoggeado() {
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
      );
    } else {
      print(FirebaseAuth.instance.currentUser!.email);
    }
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

  void _getGasStations(BuildContext context, VoidCallback onSuccess) async {
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
              favoriteFuelType: _favoriteFuelType!,
              latitude: _currentPosition!.latitude,
              longitude: _currentPosition!.longitude,
              radius: (_currentSliderValue).toInt(),
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

  Future<void> _loadUserMainFuel() async {
    if (user != null) {
      String userId = user!.uid;
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
        print('Error fetching main fuel: $e');
        setState(() {
          _favoriteFuelType = _fuelTypes.first;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _comprobarUsuarioLoggeado();
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
                child: FutureBuilder<String>(
                  future: UserService().getUsername(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading...");
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else if (snapshot.hasData) {
                      return Text(
                        "Hello ${snapshot.data}!",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 16),
                      );
                    } else {
                      return const Text("No username found");
                    }
                  },
                ),
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
                  FutureBuilder<String>(
                    future: user != null
                        ? UserService().getMainFuel()
                        : Future.value(null),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        _favoriteFuelType = snapshot.data!;
                        return _buildDropdown();
                      } else {
                        return const Text("Failed to load fuel type");
                      }
                    },
                  ),
                  const SizedBox(height: 20),
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
              _favoriteFuelType = newValue!;
            });
          },
        ),
      ],
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
          onPressed: () => () {},
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

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomePage()),
    );
  }
}
