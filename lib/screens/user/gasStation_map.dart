import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:http/http.dart' as http;
import 'package:oilsavings/models/GasStationModel.dart';
import 'dart:convert';
import 'package:chaleno/chaleno.dart';
import 'package:oilsavings/services/gasStationService.dart';
import 'package:oilsavings/services/userService.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';

class GasStationList extends StatefulWidget {
  final double latitude;
  final double longitude;
  final int radius;
  final String favoriteFuelType;

  const GasStationList({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.favoriteFuelType,
  });

  @override
  _GasStationListState createState() => _GasStationListState();
}

class _GasStationListState extends State<GasStationList> {
  final apiKey = 'AIzaSyBmaXLlR-Pfgm1sfn-8oALHvu9Zf1fWT7k';

  @override
  void initState() {
    super.initState();
    // _gasStationService.fetchGasStations();
    // _fetchPrices();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
