import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quickchat/auth/auth_gate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthGate()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Q U I C K C H A T",
                style: TextStyle(
                    color: Colors.purple, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Lottie.asset('animations/ann2.json'),
              const SizedBox(height: 50),
              Text(
                "M A D E   B Y   A L I   N A W A Z",
                style: TextStyle(color: Colors.amber.shade900),
              ),
            ],
          ),
        ),
      ),
    );
  }
}