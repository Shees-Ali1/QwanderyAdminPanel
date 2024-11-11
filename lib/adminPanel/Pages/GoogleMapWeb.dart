import 'package:flutter/material.dart';
import 'package:google_maps/google_maps.dart';
import '../GoogleMap/get_map_widget.dart';
import '../GoogleMap/google.dart';
import '../GoogleMap/google_placeholder.dart'; // Import your GooglePlaceholder widget

class MapScreen extends StatefulWidget {

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng selectedLocation = LatLng(0.0, 0.0); // Initialize to default location

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Google Maps."),
      ),
      body: Stack(
        children: [
          Container(child: GooglePlaceholder()),
          // Align(
          //   alignment: Alignment.topCenter,
          //   child:  Google(),
          //
          // ),
        ],
      ),
    );
  }
}
