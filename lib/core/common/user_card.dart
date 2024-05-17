import 'package:mpati_pet_care/models/user_model.dart';

import 'package:flutter/material.dart';
class UserCard extends StatelessWidget {
  final UserModel userModel;
  final VoidCallback? onPressed;
  const UserCard({Key? key, required this.userModel, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: SizedBox(
                width: 60,
                height: 60,
                child: ClipOval(
                  child: Image.asset("assets/images/default_pet_profile.png",
                  ),
                )
            ),
          ),
          title: Text(userModel.name!),
          subtitle: Text('${userModel.mail} - ${userModel.isAuthenticated} verification'),
          trailing: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}