// lib/screens/announcement_screen.dart
import 'package:flutter/material.dart';

class AnnouncementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Announcements"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildAnnouncementCard(
              title: "🎉 New Feature: Address Management",
              body: "You can now add and edit your delivery address in Settings > Address.",
              date: "May 28, 2024",
            ),
            _buildAnnouncementCard(
              title: "🚚 Free Shipping This Week!",
              body: "Enjoy free shipping on all orders this week. Limited time only!",
              date: "May 25, 2024",
            ),
            _buildAnnouncementCard(
              title: "⚠️ Scheduled Maintenance",
              body: "Our servers will be under maintenance on June 1st, 2AM-4AM. Sorry for inconvenience.",
              date: "May 20, 2024",
            ),
            _buildAnnouncementCard(
              title: "🎁 10% Off for First-Time Buyers",
              body: "Use code WELCOME10 for 10% off your first purchase.",
              date: "May 15, 2024",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementCard({
    required String title,
    required String body,
    required String date,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              body,
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            SizedBox(height: 12),
            Text(
              date,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}