import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_1/pages/setting_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String displayName = 'Loading...';
  String email = 'Loading...';
  double totalBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    _fetchTotalBalance();
  }

  // Fetch user profile data (display_name and email)
  Future<void> _fetchUserProfile() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        setState(() {
           displayName = user.userMetadata?['display_name'] ?? 'No Name';
          email = user.email ?? 'No Email';
        });
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  // Fetch total balance from the accounts table
  Future<void> _fetchTotalBalance() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final response = await Supabase.instance.client
            .from('accounts')
            .select('balance')
            .eq('user_id', user.id)
            .execute();

        if (response.status == 200 && response.data != null) {
          setState(() {
            totalBalance = response.data.fold(
              0.0,
              (sum, account) => sum + (account['balance'] as double),
            );
          });
        }
      }
    } catch (e) {
      print('Error fetching total balance: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Profile',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Profile Picture
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blueAccent,
              child: CircleAvatar(
                radius: 55,
                backgroundImage: CachedNetworkImageProvider(
                    'https://example.com/user-profile.jpg'),
              ),
            ),
            SizedBox(height: 20),
            
            
            // User Name
            Text(
              displayName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),

            // User Email
            Text(
              email,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),

            // Financial Summary (E.g., Total balance and income)
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Balance
                    Column(
                      children: [
                        Text(
                          'MK${totalBalance.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Balance',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    // Income (Static value or replace with dynamic if needed)
                    Column(
                      children: const [
                        Text(
                          'MK280,000',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Monthly Income',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Account Settings / Other Options
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(FontAwesomeIcons.chartLine),
                    title: const Text('Financial Overview'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to financial overview
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(FontAwesomeIcons.creditCard),
                    title: const Text('Manage Accounts'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to card management
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(FontAwesomeIcons.piggyBank),
                    title: const Text('Savings Goals'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to savings goals
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(FontAwesomeIcons.cogs),
                    title: const Text('Settings'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage()),
                      );
                    },
                  ),
                  const Divider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
