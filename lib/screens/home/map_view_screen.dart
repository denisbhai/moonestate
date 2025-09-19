import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/property.dart';

class MapViewScreen extends StatefulWidget {
  final List<PropertyElement> properties;

  const MapViewScreen({required this.properties});

  @override
  _MapViewScreenState createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  void _createMarkers() {
    // This is a simplified version - in a real app, you would need to geocode the addresses
    // For now, we'll use random coordinates for demonstration
    for (int i = 0; i < widget.properties.length; i++) {
      final property = widget.properties[i];

      // Generate random coordinates for demonstration
      final lat = 37.7749 + (i * 0.01); // San Francisco area
      final lng = -122.4194 + (i * 0.01);

      _markers.add(
        Marker(
          markerId: MarkerId(property.id.toString()),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: property.name,
            snippet: '\$${property.price}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(37.7749, -122.4194), // San Francisco
        zoom: 10,
      ),
      markers: _markers,
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}