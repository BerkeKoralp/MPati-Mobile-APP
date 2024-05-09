import 'package:flutter/material.dart';

class ChooseTypeScreen extends StatelessWidget {
  final Function(String) onRoleChosen;

  ChooseTypeScreen({required this.onRoleChosen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Your Role"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => onRoleChosen("owner"),
              child: Text("User"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => onRoleChosen("caretaker"),
              child: Text("Pet Caretaker"),
            ),
          ],
        ),
      ),
    );
  }
}
