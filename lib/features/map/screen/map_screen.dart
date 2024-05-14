import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mpati_pet_care/features/map/controller/map_controller.dart';
import 'package:routemaster/routemaster.dart';

import '../repository/map_repository.dart';
class MapScreenCustom extends ConsumerStatefulWidget {
  const MapScreenCustom({super.key});

  @override
  ConsumerState createState() => _MapScreenState();
}


class _MapScreenState extends ConsumerState<MapScreenCustom> {

  @override
  void initState() {
    // TODO: implement initState
      super.initState();
    print('"ınıt state calıstı');
    ref.read(mapControllerProvider).determinePositionOfUser(context);
    print("determine calıstı");
    ref.read(mapControllerProvider).fetchCaretakers(context);

  }
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final caretakers = ref.watch(caretakersProvider);
    final positionOfUser = ref.watch(userLocationProvider);
    LatLng currentPosition = LatLng(positionOfUser!.latitude, positionOfUser.longitude);
    List<Marker> markers = [];

    // User Marker
    if (positionOfUser != null) {
      markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: currentPosition,
          builder: (ctx) => Container(
            child: Icon(Icons.person_pin_circle, color: Colors.green, size: 50),
          ),
        ),
      );
    }
    // Caretakers Markers
    markers.addAll(caretakers.map((caretaker) => Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(double.parse(caretaker.address!.split(',')[0]), double.parse(caretaker.address!.split(',')[1])),
      builder: (ctx) => GestureDetector(
        onTap: () {
          Routemaster.of(context).pop();
        },
        child: Container(
          child: Icon(Icons.pets, color: Colors.blue),
        ),
      ),
    )).toList());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Screen'),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: positionOfUser != null ? LatLng(positionOfUser.latitude, positionOfUser.longitude) : LatLng(0, 0),
          zoom: 13.0,
        ),
        layers: [
          TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']
          ),
          MarkerLayerOptions(
            markers: markers,
          ),
        ],
      ),
    );
  }

}
