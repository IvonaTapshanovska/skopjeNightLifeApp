import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skopjeapp/models/event.dart';
import 'package:skopjeapp/widgets/event_widget.dart';

class MapPage extends StatefulWidget {
  final EventInfo event;

  const MapPage({Key? key, required this.event}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState(event);
}


class _MapPageState extends State<MapPage> {
  final LatLng _pGooglePlex;

  Set<Marker> _markers = {};

  _MapPageState(EventInfo event)
      : _pGooglePlex = LatLng(event.lat, event.lon) {
    // Add a marker for _pGooglePlex
    _markers.add(
      Marker(
        markerId: MarkerId('_pGooglePlex'),
        position: _pGooglePlex,
        // You can customize the marker icon here if needed
        // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _pGooglePlex,
          zoom: 16,
        ),
        markers: _markers,
      ),
    );
  }
}

