import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading = false;  // Track loading state

  void _signUp() {
    setState(() {
      _isLoading = true;  // Show loading indicator
    });

    // Simulate a delay or network request
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;  // Hide loading indicator
      });

      // Show a SnackBar with account creation success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // After showing SnackBar, navigate back to login page
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Sign Up', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person_add_outlined,
                size: 100,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 20),

              // First Name TextField
              TextField(
                decoration: InputDecoration(
                  labelText: 'First Name',
                  labelStyle: const TextStyle(color: Colors.blueAccent),
                  filled: true,
                  fillColor: Colors.blueAccent[50],
                  prefixIcon: const Icon(Icons.person_outlined, color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Last Name TextField
              TextField(
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  labelStyle: const TextStyle(color: Colors.blueAccent),
                  filled: true,
                  fillColor: Colors.blueAccent[50],
                  prefixIcon: const Icon(Icons.person_outlined, color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Email TextField
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.blueAccent),
                  filled: true,
                  fillColor: Colors.blueAccent[50],
                  prefixIcon: const Icon(Icons.email, color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Password TextField
              TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.blueAccent),
                  filled: true,
                  fillColor: Colors.blueAccent[50],
                  prefixIcon: const Icon(Icons.lock, color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 15),

              // Confirm Password TextField
              TextField(
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: const TextStyle(color: Colors.blueAccent),
                  filled: true,
                  fillColor: Colors.blueAccent[50],
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),

              // Sign Up Button or Loading Indicator
              _isLoading
                  ? const CircularProgressIndicator()  // Show loading indicator while signing up
                  : ElevatedButton(
                      onPressed: _signUp,  // Call the sign-up function
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 100.0,
                        ),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
              const SizedBox(height: 10),

              // Already have an account? Login
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');  // Navigate back to login
                },
                child: const Text(
                  "Already have an account? Login",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
