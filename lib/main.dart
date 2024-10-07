import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/onboarding_screen.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Financial Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const OnboardingScreen(), 
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
