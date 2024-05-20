import 'package:flutter/material.dart';
import 'screens/access/loadingScreen.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
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

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
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
          child: Text('Error initializing Firebase: $error'),
        ),
      ),
    );
  }
}
