import 'package:flutter/material.dart';
import 'package:mpati_pet_care/models/pet_model.dart';

class PetCard extends StatelessWidget {
  final PetModel pet;

  const PetCard({Key? key, required this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
        title: Text(pet.name!),
        subtitle: Text('${pet.breed} - ${pet.age} years old'),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          // Optionally, navigate to a detail screen or perform other actions
        },
      ),
    );
  }
}