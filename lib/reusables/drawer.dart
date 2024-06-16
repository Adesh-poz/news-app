import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:news_app/screens/favourite_articles_screen.dart';
import 'constants.dart';

/// Custom drawer widget for the application.
class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // UserAccountsDrawerHeader with personalized user information.
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: cherryRed,
            ),
            accountName: Text(
              'Adesh',
              style: TextStyle(
                fontFamily: GoogleFonts.roboto().fontFamily,
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              'adesh@example.com',
              style: TextStyle(
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic),
            ),
            currentAccountPicture: const Padding(
              padding: EdgeInsets.all(1.0),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/bg_1.png'),
              ),
            ),
          ),

          // ListTile for navigating to Favorite Articles screen.
          ListTile(
            title: Text(
              'Favorite Articles',
              style: TextStyle(
                fontFamily: GoogleFonts.ubuntu().fontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoriteArticlesScreen(),
                ),
              );
            },
          ),

          const Divider(), // Divider line between list items.

          // ListTile for handling Settings action (placeholder).
          ListTile(
            title: Text(
              'Settings',
              style: TextStyle(
                fontFamily: GoogleFonts.ubuntu().fontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              // Handle settings action
            },
          ),

          // ListTile for handling Help & Feedback action (placeholder).
          ListTile(
            title: Text(
              'Help & Feedback',
              style: TextStyle(
                fontFamily: GoogleFonts.ubuntu().fontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              // Handle help & feedback action
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Made with ❤️ by Adesh",
                style: TextStyle(
                  fontFamily: GoogleFonts.ubuntu().fontFamily,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
