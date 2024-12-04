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
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 40.0),

                    // Section: Accounts
                    buildSectionTitle('Accounts'),
                    buildListTile(Icons.person, 'Personal Information'),
                    buildListTile(Icons.lock, 'Change Password'),

                    const SizedBox(height: 25.0),

                    // Section: Preferences
                    buildSectionTitle('Preferences'),
                    buildListTile(Icons.language, 'Languages',
                        trailing: Text('English')),
                    buildListTile(Icons.privacy_tip, 'Privacy'),
                    buildListTile(Icons.brightness_2, 'Theme'),
                    buildListTile(Icons.notifications, 'Notifications',
                        trailing: Text('off')),

                    const SizedBox(height: 25.0),

                    // Section: Others
                    buildSectionTitle('Others'),
                    buildListTile(Icons.photo, 'Media'),
                    buildListTile(Icons.storage, 'Manage space'),
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

  Widget buildListTile(IconData icon, String title, {Widget? trailing}) {
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
      onTap: () {},
    );
  }
}
