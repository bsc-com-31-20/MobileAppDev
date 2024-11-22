import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _profileImageUrl = 'https://example.com/user-profile.jpg';
  bool _isSaving = false;

  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      setState(() {
        _nameController.text = user.userMetadata?['display_name'] ?? '';
        _emailController.text = user.email ?? '';
        _phoneController.text = user.userMetadata?['phone'] ?? '';
        _profileImageUrl = user.userMetadata?['profile_image_url'] ??
            'https://example.com/user-profile.jpg';
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImageUrl = image.path;
      });
    }
  }

  Future<void> _saveProfile() async {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String phone = _phoneController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      setState(() {
        _isSaving = true;
      });

      String? uploadedImageUrl;
      if (!_profileImageUrl.contains('http')) {
        final file = File(_profileImageUrl);
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

        final storageResponse = await supabase.storage
            .from('images') 
            .upload(fileName, file);

        if (storageResponse.error != null) {
          throw Exception('Image upload failed: ${storageResponse.error!.message}');
        }

        uploadedImageUrl = supabase.storage
            .from('images')
            .getPublicUrl(fileName)
            .data;
      }

      final user = supabase.auth.currentUser;
      if (user != null) {
       
        final updateResponse = await supabase.auth.updateUser(UserAttributes(
          email: email, 
          data: {
            'display_name': name,
            'phone': phone,
            'profile_image_url': uploadedImageUrl ?? _profileImageUrl,
          },
        ));

        if (updateResponse.error != null) {
          throw Exception('Profile update failed: ${updateResponse.error!.message}');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Update Profile', style: TextStyle(color: Colors.white, fontWeight:FontWeight.bold  ),),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                   
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.blueAccent,
                          child: CircleAvatar(
                            radius: 55,
                            backgroundImage: _profileImageUrl.contains('http')
                                ? CachedNetworkImageProvider(_profileImageUrl)
                                : FileImage(File(_profileImageUrl))
                                    as ImageProvider,
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
                    const SizedBox(height: 20),

                    _buildInputField(
                      controller: _nameController,
                      label: 'Name',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 20),

                    _buildInputField(
                      controller: _emailController,
                      label: 'Email Address',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    _buildInputField(
                      controller: _phoneController,
                      label: 'Mobile Phone Number',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: _isSaving ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(fontSize: 18, color: Colors.white),
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
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: false,
        fillColor: Colors.grey[100],
      ),
    );
  }
}

extension on String {
  String? get data => null;
  
  get error => null;
}

extension on UserResponse {
  get error => null;
}
