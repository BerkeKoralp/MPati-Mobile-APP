
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:mpati_pet_care/features/map/repository/map_repository.dart';

import '../../../core/utils.dart';

final mapControllerProvider = Provider<MapControllerCustom>(
        (ref) => MapControllerCustom(
          mapRepository: ref.watch(mapRepositoryProvider),
            ref:  ref
        )
);
final userLocationProvider = StateProvider<Position?>((ref) => null);
final careTakerLocationProvider = StateProvider<LatLng?>((ref) => null);

class MapControllerCustom {
  final MapRepository _mapRepository;
  final Ref _ref;

  MapControllerCustom( {
    required MapRepository mapRepository,
     required Ref ref
  }) : _mapRepository = mapRepository,
       _ref = ref;


   void determinePositionOfUser(BuildContext context) async{
    final position =  await _ref.read(mapRepositoryProvider).determinePositionOfUser();
    print(position.toString()+" controllerdeyim");
    position.fold(
          (l) => showSnackBar(context, l.message),
          (pos) => _ref.read(userLocationProvider.notifier).update((state) => pos),
    );
   }

  Future<void> determinePositionOfCareTaker(BuildContext context) async {
    // final positionOfCareTaker= await _ref.read(mapRepositoryProvider).determinePositionOfCareTaker();
    // positionOfCareTaker.fold((l) => showSnackBar(context, l.message),
    //         (posOfCareTaker) => _ref.read(careTakerLocationProvider.notifier).update((state) => posOfCareTaker));
  }
}