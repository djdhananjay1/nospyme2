import 'package:flutter/material.dart';
import 'package:location/location.dart';

class RealTimeLocationPage extends StatefulWidget {
  const RealTimeLocationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RealTimeLocationPageState createState() => _RealTimeLocationPageState();
}

class _RealTimeLocationPageState extends State<RealTimeLocationPage> {
  final RealTimeLocation _realTimeLocation = RealTimeLocation();

  late Stream<LocationData> _locationStream;

  @override
  void initState() {
    super.initState();

    _locationStream = _realTimeLocation.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real Time Location'),
      ),
      body: StreamBuilder<LocationData>(
        stream: _locationStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(
                'Latitude: ${snapshot.data!.latitude}, Longitude: ${snapshot.data!.longitude}');
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Text('Loading...');
          }
        },
      ),
    );
  }
}

class RealTimeLocation {
  final Location _location = Location();

  Stream<LocationData> getLocation() {
    return _location.onLocationChanged;
  }
}
