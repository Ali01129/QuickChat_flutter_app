import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quickchat/auth/auth_gate.dart';
import 'package:quickchat/firebase_options.dart';
import 'package:quickchat/pages/login_page.dart';
import 'package:quickchat/pages/signup_page.dart';
import 'package:quickchat/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/login_page': (context) =>  LoginPage(),
        '/signup_page': (context) => const SignupPage(),
      },
    );
  }
}
