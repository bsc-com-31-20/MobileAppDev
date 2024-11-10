import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/pages/signup_page.dart';
import 'pages/onboarding_screen.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

 //to be changed
  await Supabase.initialize(
    url: 'https://ceembasvhajkbzmdfpmn.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNlZW1iYXN2aGFqa2J6bWRmcG1uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjgzMDgxMzYsImV4cCI6MjA0Mzg4NDEzNn0.UZIwXHIIkI7ugOqUi6ulxWEs17VloKAmi3sOag74eVA', 
  );

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
