import 'package:mpati_pet_care/models/pet_caretaker_model.dart';
import 'package:flutter/material.dart';

class CareTakerCard extends StatelessWidget {
  final PetCareTakerModel petCareTakerModel;
  final VoidCallback? onPressed;

  const CareTakerCard({Key? key, required this.petCareTakerModel, this.onPressed}) : super(key: key);

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
              child: CircleAvatar(
                backgroundImage:NetworkImage(petCareTakerModel.profilePic.toString()),
              ),
            ),
          ),
          title: Text(petCareTakerModel.name!),
          subtitle: Text('${petCareTakerModel.mail} -activity: ${petCareTakerModel.isActive} '),
          trailing: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
