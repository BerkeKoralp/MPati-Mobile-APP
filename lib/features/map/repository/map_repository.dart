

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:mpati_pet_care/core/failure.dart';
import 'package:mpati_pet_care/core/type_defs.dart';
import 'package:mpati_pet_care/features/authentication/controller/auth_controller.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/providers/firebase_providers.dart';

final mapRepositoryProvider = Provider((ref) => MapRepository(
  firestore: ref.read(firestoreProvider),
  ref: ref
));

class MapRepository{
  final FirebaseFirestore _firestore;
  final Ref _ref;
  late final Position _position;
  LatLng _currentPosition = LatLng(0, 0);
   MapRepository( {
    required FirebaseFirestore firestore,
     required Ref ref,
  }) : _firestore = firestore,
        _ref = ref;

  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);

  Future<void> updateUserAddress(String userId, String newAddress) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'address': newAddress
      });
      print("Address updated successfully");
    } catch (e) {
      print("Error updating address: $e");
    }
  }
   FutureEither<Position> determinePositionOfUser() async {
    bool serviceEnabled;
    LocationPermission permission;
    Position position;
    final user = _ref.read(userProvider);
    try{
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Future.error('Location services are disabled.');
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        //If Permissions denied ask for permissions
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          //If user denied return error
          throw Future.error('Location permissions are denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Future.error('Location permissions are permanently denied, we cannot request permissions.');
      }
      position = await Geolocator.getCurrentPosition();
      String positionString = position.latitude.toString()+","+position.longitude.toString();
      print(position.toString()+"Repositorydeki");
      updateUserAddress(user!.uid.toString(), positionString);
      print("geliyor");
      return right(position);
      }
      catch(e){
       return left(Failure(e.toString()));
      }

    }

}



