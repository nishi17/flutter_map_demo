import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Completer<GoogleMapController> _controller = Completer();
  MapType _currentMapType = MapType.normal;
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;
  late GoogleMapController _controller1;
  Location _location = Location();
  late LocationData currentLocation;
  // late StreamSubscription<LocationData> locationSubscription;

  static const LatLng _center = const LatLng(23.0120, 72.5108);

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    _controller1 = controller;
    currentLocation = await _location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 15.0,
              ),
              mapType: _currentMapType,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              markers: _markers,
              onCameraMove: _onCameraMove,
              myLocationEnabled: true,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.green,
                      onPressed: _onMapTypeButtonPressed,
                      child: Center(
                        child: Icon(Icons.map),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    FloatingActionButton(
                      onPressed: _onAddMarkerButtonPressed,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.add_location, size: 30.0),
                    ),
                    SizedBox(width: 16.0),
                    FloatingActionButton(
                      onPressed: _onCurrentLocation,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.location_searching_sharp, size: 30.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }


  void _onCurrentLocation()
  /*{
    setState(() {
    locationSubscription=      _location.onLocationChanged.listen((l) {
        _controller1.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
          ),
        );
      });

    locationSubscription.cancel();

    });

  }*/ /*async*/ {
    /*final GoogleMapController controller = await _controller.future;
    LocationData currentLocation;
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }*/

    _controller1.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
        zoom: 15.0,
      ),
    ));
  }
}
