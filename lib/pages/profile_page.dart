import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile', style: TextStyle(fontSize: 18,color:Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Profile Picture
            CircleAvatar(
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
              'Nick kalulu',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),

            // User Email
            Text(
              'bsc-com-34-20@unima.ac.mw',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 15),

            // Financial Summary (E.g., Total balance and income)
            Card(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                          '\MK12,500',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Balance',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    // Income
                    Column(
                      children: [
                        Text(
                          '\MK280,000',
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
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),

            // Account Settings / Other Options
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(FontAwesomeIcons.chartLine),
                    title: Text('Financial Overview'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to financial overview
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.creditCard),
                    title: Text('Manage Accounts'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to card management
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.piggyBank),
                    title: Text('Savings Goals'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to savings goals
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.cogs),
                    title: Text('Settings'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to settings
                    },
                  ),
                  Divider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
