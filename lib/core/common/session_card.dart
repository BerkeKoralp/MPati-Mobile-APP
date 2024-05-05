import 'package:flutter/material.dart';

import '../../models/session_model.dart';
class SessionCard extends StatelessWidget {
  final SessionModel session;

  SessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Session ID: ${session.id}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('UserId: ${session.userId}', style: TextStyle(fontSize: 14)),
            Text('Care Taker Id: ${session.caretakerId}', style: TextStyle(fontSize: 14)),
            SizedBox(height: 8),
            Text('Status: ${session.status ?? "Pending"}', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}