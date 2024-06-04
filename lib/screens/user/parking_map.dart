import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oilsavings/models/ParkingModel.dart';
import 'package:oilsavings/screens/user/reviewScreen.dart';
import 'package:oilsavings/services/parkingService.dart';

class ParkingList extends StatefulWidget {
  final double latitude;
  final double longitude;
  final int radius;

  const ParkingList({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  @override
  _ParkingListState createState() => _ParkingListState();
}

class _ParkingListState extends State<ParkingList> {
  List<ParkingData> _parkings = [];
  bool _isLoading = true;
    final String userId = FirebaseAuth.instance.currentUser!.uid;

  final ParkingService _parkingService = ParkingService();

  @override
  void initState() {
    super.initState();
    _fetchParkingData();
  }

  Future<void> _fetchParkingData() async {
    try {
      final parkings = await _parkingService.fetchParking(
        widget.latitude.toString(),
        widget.longitude.toString(),
        widget.radius.toString(),
      );
      setState(() {
        _parkings = parkings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching parking locations: $e'),
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
          title: const Text('Nearby parking'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_parkings.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Nearby  Parking'),
        ),
        body: const Center(child: Text('No  Parking locations found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby  Parking'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _parkings.length,
              itemBuilder: (context, index) {
                final parking = _parkings[index];
                return Card(
                  child: ExpansionTile(
                    title: Text(parking.name ?? 'Name not available'),
                    subtitle: Text(parking.vicinity ?? 'No address available'),
                    trailing: IconButton(
                      icon: const Icon(Icons.rate_review),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReviewScreen(
                              placeId: parking.placeId,
                              userId: userId,
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
                            _buildOpenStatus(parking.openNow),
                            Text(
                                'Rating: ${parking.rating} (${parking.userRatingsTotal} reviews)'),
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
