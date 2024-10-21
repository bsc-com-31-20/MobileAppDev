import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Controllers for text fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Placeholder for profile image (initially a network image)
  String _profileImageUrl = 'https://example.com/user-profile.jpg';
  
  bool _isSaving = false; // Show saving indicator when saving profile

  // Function to pick a new image
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        // Update the profile image with the new image path
        _profileImageUrl = image.path;
      });
    }
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is destroyed
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: _isSaving
          ? Center(child: CircularProgressIndicator()) // Show progress when saving
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile Picture
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.blueAccent,
                          child: CircleAvatar(
                            radius: 55,
                            backgroundImage: _profileImageUrl.contains('http')
                                ? CachedNetworkImageProvider(_profileImageUrl)
                                : FileImage(File(_profileImageUrl)) as ImageProvider,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.camera_alt, color: Colors.grey[700]),
                            onPressed: _pickImage,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // First Name Field
                    _buildInputField(
                      controller: _firstNameController,
                      label: 'First Name',
                      icon: Icons.person,
                    ),
                    SizedBox(height: 20),

                    // Last Name Field
                    _buildInputField(
                      controller: _lastNameController,
                      label: 'Last Name',
                      icon: Icons.person_outline,
                    ),
                    SizedBox(height: 20),

                    // Email Field
                    _buildInputField(
                      controller: _emailController,
                      label: 'Email Address',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20),

                    // Phone Number Field
                    _buildInputField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 20),

                    // Password Field
                    _buildInputField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock,
                      isObscure: true,
                    ),
                    SizedBox(height: 30),

                    // Save Changes Button
                    ElevatedButton(
                      onPressed: () {
                        _saveProfile();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Save Changes',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isObscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

  void _saveProfile() {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String email = _emailController.text;
    String phone = _phoneController.text;
     //String password = _passwordController.text;

    // Perform validations (if necessary) and then save the new profile data
    if (firstName.isNotEmpty && lastName.isNotEmpty && email.isNotEmpty && phone.isNotEmpty) {
      setState(() {
        _isSaving = true;
      });

      // Simulate saving process (e.g., sending to backend)
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isSaving = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      });
    } else {
      // Show error message if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
    }
  }
}
