import 'package:flutter/material.dart';
import '../widgets/custom_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(height: 10),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 40.0),

                    // Section: Accounts
                    buildSectionTitle('Accounts'),
                    buildListTile(
                      Icons.person, 
                      'Personal Information', 
                      onTap: () {
                        // Navigate to personal info screen
                      },
                    ),
                    buildListTile(
                      Icons.lock, 
                      'Change Password', 
                      onTap: () {
                        // Navigate to change password screen
                      },
                    ),

                    const SizedBox(height: 25.0),

                    // Section: Preferences
                    buildSectionTitle('Preferences'),
                    buildListTile(
                      Icons.language, 
                      'Languages',
                      trailing: Text('English'),
                      onTap: () {
                        // Open language settings screen
                      },
                    ),
                    buildListTile(
                      Icons.privacy_tip, 
                      'Privacy',
                      onTap: () {
                        // Navigate to privacy settings screen
                      },
                    ),
                    buildListTile(
                      Icons.brightness_2, 
                      'Theme',
                      onTap: () {
                        // Open theme settings screen (e.g., dark mode toggle)
                      },
                    ),
                    buildListTile(
                      Icons.notifications, 
                      'Notifications',
                      trailing: Text('off'),
                      onTap: () {
                        // Open notifications settings
                      },
                    ),

                    const SizedBox(height: 25.0),

                    // Section: Others
                    buildSectionTitle('Others'),
                    buildListTile(
                      Icons.photo, 
                      'Media',
                      onTap: () {
                        // Open media settings screen
                      },
                    ),
                    buildListTile(
                      Icons.storage, 
                      'Manage space',
                      onTap: () {
                        // Open manage space settings screen
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      color: Colors.grey[200],
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildListTile(IconData icon, String title, {Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.grey[800],
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing ?? Icon(Icons.chevron_right, color: Colors.grey[600]),
      onTap: onTap,
    );
  }
}
