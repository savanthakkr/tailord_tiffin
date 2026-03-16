import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../../utils/config.dart';
import '../../widgets/appbar_common.dart';

class PickMapScreen extends StatefulWidget {
  const PickMapScreen({super.key});

  @override
  State<PickMapScreen> createState() => _PickMapScreenState();
}

class _PickMapScreenState extends State<PickMapScreen> {

  final String googleApiKey = "AIzaSyBt6Xd9sSZXYZr8t_tQTFYUaIeRnHKXJ90";

  GoogleMapController? mapController;
  LatLng? selectedLatLng;
  Set<Marker> markers = {};

  TextEditingController searchCtrl = TextEditingController();
  List placesList = [];

  // -----------------------------------
  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  // -----------------------------------
  // CURRENT LOCATION
  Future<void> _loadCurrentLocation() async {

    await Geolocator.requestPermission();

    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    selectedLatLng = LatLng(pos.latitude, pos.longitude);

    markers = {
      Marker(
        markerId: const MarkerId("me"),
        position: selectedLatLng!,
      )
    };

    setState(() {});
  }

  // -----------------------------------
  // AUTOCOMPLETE SEARCH
  Future<void> searchPlace(String input) async {

    if (input.isEmpty) {
      setState(() => placesList = []);
      return;
    }

    String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json"
        "?input=$input"
        "&key=$googleApiKey";

    var res = await http.get(Uri.parse(url));
    var json = jsonDecode(res.body);

    if (json["status"] == "OK") {
      setState(() {
        placesList = json["predictions"];
      });
    }
  }

  // -----------------------------------
  // GET LAT LNG FROM PLACE ID
  Future<void> selectPlace(String placeId) async {

    String url =
        "https://maps.googleapis.com/maps/api/place/details/json"
        "?place_id=$placeId"
        "&key=$googleApiKey";

    var res = await http.get(Uri.parse(url));
    var json = jsonDecode(res.body);

    if (json["status"] == "OK") {

      var loc = json["result"]["geometry"]["location"];

      LatLng newPos = LatLng(loc["lat"], loc["lng"]);

      setState(() {
        selectedLatLng = newPos;
        placesList = [];
        searchCtrl.clear();

        markers = {
          Marker(
            markerId: const MarkerId("selected"),
            position: newPos,
          )
        };
      });

      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(newPos, 16),
      );
    }
  }
  Future<bool> _onBackPressed() async {
    Get.back();
    return false;
  }

  // -----------------------------------
  @override
  Widget build(BuildContext context) {

    if (selectedLatLng == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: appCtrl.appTheme.white,
      appBar: CommonAppbar(
        title: 'Pick Location',
        backEnable: true,
        centerTitle: true,
        bgColor: appCtrl.appTheme.white,
        leadingOnTap: () => _onBackPressed(),
      ),
      body: Stack(
        children: [

          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: selectedLatLng!,
              zoom: 16,
            ),

            myLocationEnabled: true,
            myLocationButtonEnabled: true,

            onMapCreated: (c) => mapController = c,

            onTap: (latLng) {
              setState(() {
                selectedLatLng = latLng;
                markers = {
                  Marker(
                    markerId: const MarkerId("tap"),
                    position: latLng,
                  )
                };
              });
            },

            markers: markers,
          ),

          // ---------------- SEARCH BAR ----------------
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Column(
              children: [

                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(8),
                  child: TextField(
                    controller: searchCtrl,
                    onChanged: searchPlace,
                    decoration: const InputDecoration(
                      hintText: "Search flat, shop, area...",
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(14),
                    ),
                  ),
                ),

                if (placesList.isNotEmpty)
                  Container(
                    color: Colors.white,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: placesList.length,
                      itemBuilder: (c, i) {

                        return ListTile(
                          title: Text(
                            placesList[i]["description"],
                          ),
                          onTap: () => selectPlace(
                            placesList[i]["place_id"],
                          ),
                        );
                      },
                    ),
                  ),

              ],
            ),
          ),

          // ---------------- CONFIRM ----------------
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: ElevatedButton(
              onPressed: () {
                Get.back(result: selectedLatLng);
              },
              child: const Text("Confirm Location"),
            ),
          ),

        ],
      ),
    );
  }
}
