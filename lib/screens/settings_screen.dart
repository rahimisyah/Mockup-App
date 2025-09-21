// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        children: [
          ListTile(
            title: Text("Dark Mode"),
            trailing: Switch.adaptive(
              value: false,
              onChanged: (v) {},
            ),
          ),
          ListTile(
            title: Text("Notifications"),
            trailing: Switch.adaptive(
              value: true,
              onChanged: (v) {},
            ),
          ),
          ListTile(
            title: Text("About"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("Prototype App V.1"),
                content: Text("This app features a secure mock login, an intuitive dashboard for easy navigation, and a suite of essential screens—all wrapped in a beautiful UI with smooth gradients and elegant icons. It's a testament to modern cross-platform development, focusing on a polished user experience with fully functional features like token persistence and secure logout."),
                actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text("OK"))],
              ),
            ),
          ),
          ListTile(
            title: Text("Address"),
            subtitle: Text("Manage your address"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, '/address');
            },
          ),
        ],
      ),
    );
  }
}