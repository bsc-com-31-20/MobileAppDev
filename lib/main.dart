import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/signup_page.dart';
import 'pages/onboarding_screen.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

void main() {
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
        '/signup': (context) => const SignUpPage(),  // Sign Up route
        '/home': (context) => const HomePage(),
      },
    );
  }
}
