import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/access/loadingScreen.dart';
// import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    runApp(const OilSavings());
  } catch (e) {
    runApp(ErrorScreen(error: e.toString()));
  }
}

class OilSavings extends StatelessWidget {
  const OilSavings({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'OilSavings',
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String error;

  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Error',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('Error initializing application: $error'),
        ),
      ),
    );
  }
}
