import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng _currentPosition = LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    //Checking if the services are enabled for location activities
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    //Checking if the permissions are enabled for location activities
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      //If Permissions denied ask for permissions
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        //If user denied return error
        return Future.error('Location permissions are denied');
      }
    }
    //If user denied for eternity return error
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // getCurrentPosition Returns the current position taking the supplied [desiredAccuracy] into account.
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      //Moves the map to a specific location and zoom level
      _mapController.move(_currentPosition, 15.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Screen'),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _currentPosition,
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
                point: _currentPosition,
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
