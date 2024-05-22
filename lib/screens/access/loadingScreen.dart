import 'dart:async';
import 'package:flutter/material.dart';
import 'welcome.dart';
import '../user/main_screen.dart'; // Asumiendo que tienes una pantalla principal llamada MainScreen
import '../../themes/themeColors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 4),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.orange.shade900,
              Colors.orange.shade800,
              Colors.orange.shade400,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: 'O',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 0, 17, 255),
                ),
                children: [
                  TextSpan(
                    text: 'il',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                    ),
                  ),
                  TextSpan(
                    text: 'S',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 17, 255),
                      fontSize: 40,
                    ),
                  ),
                  TextSpan(
                    text: 'avings',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: Colors.black,
                size: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
