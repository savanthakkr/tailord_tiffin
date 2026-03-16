import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/order_model.dart';

class DeliveryRouteMapScreen extends StatefulWidget {
  final List<OrderData> orders;

  const DeliveryRouteMapScreen({super.key, required this.orders});

  @override
  State<DeliveryRouteMapScreen> createState() => _DeliveryRouteMapScreenState();
}

class _DeliveryRouteMapScreenState extends State<DeliveryRouteMapScreen> {

  GoogleMapController? mapController;
  LatLng? currentLocation;

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {

    Position position = await Geolocator.getCurrentPosition();

    currentLocation = LatLng(position.latitude, position.longitude);

    buildMarkers();
  }

  void buildMarkers() {

    if (currentLocation == null) return;

    markers.add(
      Marker(
        markerId: MarkerId("driver"),
        position: currentLocation!,
        infoWindow: InfoWindow(title: "Driver Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    for (var order in widget.orders) {

      if (order.schedules != null && order.schedules!.isNotEmpty) {

        double lat = double.parse(order.schedules!.first.latitude!);
        double lng = double.parse(order.schedules!.first.longitude!);

        markers.add(
          Marker(
            markerId: MarkerId(order.orderId!),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: "Order ${order.orderId}"),
          ),
        );
      }
    }

    buildPolyline();
  }

  void buildPolyline() {

    List<LatLng> routePoints = [];

    routePoints.add(currentLocation!);

    for (var order in widget.orders) {

      if (order.schedules != null && order.schedules!.isNotEmpty) {

        double lat = double.parse(order.schedules!.first.latitude!);
        double lng = double.parse(order.schedules!.first.longitude!);

        routePoints.add(LatLng(lat, lng));
      }
    }

    polylines.add(
      Polyline(
        polylineId: PolylineId("delivery_route"),
        points: routePoints,
        width: 5,
        color: Colors.blue,
      ),
    );

    setState(() {});
  }

  Future<void> startNavigation() async {

    if (currentLocation == null) return;

    List<String> waypoints = [];

    for (var order in widget.orders) {
      if (order.schedules != null && order.schedules!.isNotEmpty) {

        String lat = order.schedules!.first.latitude!;
        String lng = order.schedules!.first.longitude!;

        waypoints.add("$lat,$lng");
      }
    }

    if (waypoints.isEmpty) return;

    String origin =
        "${currentLocation!.latitude},${currentLocation!.longitude}";

    String destination = waypoints.last;

    String waypointString = waypoints.length > 1
        ? waypoints.sublist(0, waypoints.length - 1).join("|")
        : "";

    String url =
        "https://www.google.com/maps/dir/?api=1"
        "&origin=$origin"
        "&destination=$destination"
        "&waypoints=$waypointString"
        "&travelmode=driving";

    Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Delivery Route")),

      body: currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: currentLocation!,
          zoom: 13,
        ),
        markers: markers,
        polylines: polylines,
        myLocationEnabled: true,
        onMapCreated: (controller) {
          mapController = controller;
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: startNavigation,
        icon: Icon(Icons.navigation),
        label: Text("Start Delivery"),
      ),
    );
  }
}