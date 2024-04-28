import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mpati_pet_care/features/map/controller/map_controller.dart';
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

  }
  final MapController _mapController = MapController();
  @override
  Widget build(BuildContext context) {
    final positionOfUser =  ref.watch(userLocationProvider);
    LatLng currentPosition = LatLng(positionOfUser!.latitude, positionOfUser.longitude);
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Screen'),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: currentPosition,
          zoom: 13.0,
        ),
        layers: [
          TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(positionOfUser!.latitude,positionOfUser.longitude),
                builder: (ctx) =>
                    Container(
                      child: Icon(Icons.location_on, color: Colors.red,),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
