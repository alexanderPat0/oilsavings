import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:oilsavings/models/CarWashModel.dart';
import 'package:oilsavings/screens/user/reviewScreen.dart';
import 'package:oilsavings/services/carWashService.dart';
import 'package:oilsavings/services/userService.dart';

class CarWashList extends StatefulWidget {
  final double latitude;
  final double longitude;
  final int radius;

  const CarWashList({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  @override
  _CarWashListState createState() => _CarWashListState();
}

class _CarWashListState extends State<CarWashList> {
  List<CarWashData> _stations = [];
  String _username = "User not available"; // Valor predeterminado
  final UserService _userService = UserService();
  bool _isLoading = true;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final CarWashService _carWashService = CarWashService();

  @override
  void initState() {
    super.initState();
    _fetchCarWashData();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    try {
      _username = await _userService.getUsername();
    } catch (e) {
      print("Failed to fetch username: $e");
      // Maneja errores, por ejemplo mostrando un mensaje si es necesario
    }
  }

  Future<void> _fetchCarWashData() async {
    try {
      final stations = await _carWashService.fetchCarWash(
        widget.latitude.toString(),
        widget.longitude.toString(),
        widget.radius.toString(),
      );
      setState(() {
        _stations = stations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching car wash locations: $e'),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Nearby Car Wash'),
          ),
          body: Center(
            child: LoadingAnimationWidget.fourRotatingDots(
              color: Colors.orange,
              size: 200,
            ),
          ));
    }

    if (_stations.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Nearby Car Wash'),
        ),
        body: const Center(child: Text('No car wash locations found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Car Wash'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _stations.length,
              itemBuilder: (context, index) {
                final station = _stations[index];
                return Card(
                  child: ExpansionTile(
                    title: Text(station.name ?? 'Name not available'),
                    subtitle: Text(station.vicinity ?? 'No address available'),
                    trailing: IconButton(
                      icon: const Icon(Icons.rate_review),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReviewScreen(
                              placeId: station.placeId,
                              userId: userId,
                              username: _username,
                              placeName:
                                  station.name ?? 'Parking name not available.',
                            ),
                          ),
                        );
                      },
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildOpenStatus(station.openNow),
                            Text(
                                'Rating: ${station.rating} (${station.userRatingsTotal} reviews)'),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpenStatus(bool? isOpen) {
    if (isOpen == null) {
      return const Text('Open status: Unknown',
          style: TextStyle(color: Colors.grey));
    } else {
      return Text('Open Now: ${isOpen ? "Yes" : "No"}',
          style: TextStyle(color: isOpen ? Colors.green : Colors.red));
    }
  }
}
