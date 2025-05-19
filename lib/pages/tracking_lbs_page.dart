import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TrackingLBSPage extends StatefulWidget {
  const TrackingLBSPage({super.key});

  @override
  State<TrackingLBSPage> createState() => _TrackingLBSPageState();
}

class _TrackingLBSPageState extends State<TrackingLBSPage> {
  String _locationMessage = "Getting location...";
  String _address = "Address not available";
  bool _isLoading = false;
  double? _latitude;
  double? _longitude;
  List<Position> _locationHistory = [];
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isTracking = false;

  MapController _mapController = MapController();
  List<Marker> _markers = [];
  LatLng _currentPosition = LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  void _updateMapMarkers(Position position) {
    final latLng = LatLng(position.latitude, position.longitude);
    setState(() {
      _currentPosition = latLng;
      _markers = [
        ..._locationHistory.map((pos) => Marker(
          width: 40,
          height: 40,
          point: LatLng(pos.latitude, pos.longitude),
          child: const Icon(Icons.location_on, color: Colors.red),
        )),
        Marker(
          width: 40,
          height: 40,
          point: latLng,
          child: const Icon(Icons.my_location, color: Colors.blue),
        ),
      ];
    });
    _mapController.move(latLng, 15);
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showError("Location services are disabled.");
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showError("Location permissions are denied");
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showError("Location permissions are permanently denied.");
      return false;
    }

    return true;
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _locationMessage = "Lat: ${position.latitude}, Lng: ${position.longitude}";
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
      _updateMapMarkers(position);
      _getAddressFromLatLng(position);
    } catch (e) {
      _showError("Error getting location: $e");
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _address = '${place.street}, ${place.locality}, ${place.country}';
        });
      }
    } catch (e) {
      setState(() => _address = "Error getting address");
    }
  }

  void _toggleTracking() {
    if (_isTracking) {
      _positionStreamSubscription?.cancel();
      setState(() => _isTracking = false);
    } else {
      _startTracking();
    }
  }

  void _startTracking() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    const settings = LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10);
    setState(() {
      _isTracking = true;
      _locationHistory.clear();
    });

    _positionStreamSubscription = Geolocator.getPositionStream(locationSettings: settings).listen((position) {
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _locationMessage = "Lat: ${position.latitude}, Lng: ${position.longitude}";
        _locationHistory.insert(0, position);
      });
      _updateMapMarkers(position);
      _getAddressFromLatLng(position);
    });
  }

  void _showError(String msg) {
    setState(() {
      _locationMessage = msg;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Tracking Location"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_home.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildLocationCard(),
              _buildMapCard(),
              _buildTrackingButton(),
              _buildHistoryCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        color: Colors.black.withOpacity(0.6),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Current Location", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: _getCurrentLocation,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow(Icons.location_on, _locationMessage),
                  const SizedBox(height: 6),
                  _infoRow(Icons.home, _address),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapCard() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: (_latitude == null || _longitude == null)
              ? const Center(child: Text('Waiting for location...', style: TextStyle(color: Colors.white)))
              : FlutterMap(
            mapController: _mapController,
            options: MapOptions(center: _currentPosition, zoom: 15),
            children: [
              TileLayer(
                urlTemplate:
                'https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=bDmTXFtHAVG0ucnGY9NC2sfCfAAafYtC',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(markers: _markers),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackingButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: ElevatedButton.icon(
        onPressed: _toggleTracking,
        icon: Icon(_isTracking ? Icons.stop : Icons.play_arrow),
        label: Text(_isTracking ? "Stop Tracking" : "Start Tracking"),
        style: ElevatedButton.styleFrom(
          backgroundColor: _isTracking ? Colors.redAccent : Colors.orange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  Widget _buildHistoryCard() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          color: Colors.black.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Location History", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Expanded(
                  child: _locationHistory.isEmpty
                      ? const Center(child: Text('No location history', style: TextStyle(color: Colors.grey)))
                      : ListView.builder(
                    itemCount: _locationHistory.length,
                    itemBuilder: (context, index) {
                      final pos = _locationHistory[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Text('${index + 1}', style: const TextStyle(color: Colors.black)),
                        ),
                        title: Text(
                          'Lat: ${pos.latitude.toStringAsFixed(6)}, Lng: ${pos.longitude.toStringAsFixed(6)}',
                          style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
                        ),
                        subtitle: Text(
                          'Altitude: ${pos.altitude.toStringAsFixed(2)}m, Speed: ${pos.speed.toStringAsFixed(2)} m/s',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(color: Colors.white))),
      ],
    );
  }
}
