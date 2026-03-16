import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tailoredtiffin/model/address_model.dart';
import 'package:tailoredtiffin/model/address_resp_model.dart';
import 'package:tailoredtiffin/model/response_model.dart';

import '../screens/address/map_picker_screen.dart';
import '../utils/config.dart';
enum AddressType { home, work, other }

class AddressController extends GetxController{

  AddressType _addressType = AddressType.home;
  bool _isDefault = false;

  AddressType get addressType => _addressType;
  bool get isDefault => _isDefault;

  var nameController = TextEditingController();
  var addressController = TextEditingController();
  var landmarkController = TextEditingController();
  var stateController = TextEditingController();
  var cityController = TextEditingController();
  var pincodeController = TextEditingController();

  AutovalidateMode autoValidate = AutovalidateMode.disabled;
  GlobalKey<FormState> addGlobalKey = GlobalKey<FormState>();
  GlobalKey<FormState> editGlobalKey = GlobalKey<FormState>();
  bool isLoading=false,getLoading = false;
  String? authToken,userId;
  List<Address> addressList = <Address>[];
  double? latitude;
  double? longitude;
  Timer? _debounce;
  String strState="",strCity="",strPincode="";

  @override
  void onInit() {
    super.onInit();
    getPrefs();
    cityController.text = "";
    stateController.text = "";
  }

  void getPrefs()
  {
    authToken = Prefs.shared.getString(Prefs.authToken);
    userId = Prefs.shared.getString(Prefs.userId);
    print("token $authToken");
    getAddress();
  }

  void onRefresh() {
    getAddress();
  }

  void setAddressType(AddressType type) {
    _addressType = type;
    update();
  }

  void toggleDefault(bool value) {
    _isDefault = value;
    update();
  }

  getAddress(){
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        getLoading = true;
        update();

        try{
          final AddressModel model = await ApiManager.getAddressList(authToken: authToken!,);

          if(model.status == 'success' && model.data!=null) {

            addressList = model.data ?? [];

          }else{
            UIUtils.bottomToast(text: 'Error fetching Data', isError: true);
          }

          getLoading = false;
          update();
        }
        on Exception catch(_,e){
          getLoading = false;
          update();
        }
      }
      else {
        // No-Internet Case
        UIUtils.showInternetErrorToast();
      }
    });
  }

  Address? get defaultAddress {
    try {
      return addressList.firstWhere((e) => e.isDefault == '1');
    } catch (e) {
      return addressList.isNotEmpty ? addressList.first : null;
    }
  }

  addAddressMethod() {
    if(addGlobalKey.currentState!.validate())
    {
      ConnectionUtils.checkConnection().then((internet) async {
        if (internet) {
          isLoading = true;
          update();
          try{

            final ResponseModel responseModel = await ApiManager.addAddress(
                authToken: authToken!,
              title: addressTypeText,
              address: stateController.text+","+addressController.text,
              landmark: landmarkController.text,
              city: strCity,
              state: strState,
              pincode: strPincode,
                latitude: latitude ?? 0,
                longitude: longitude ?? 0,
              isDefault: isDefault ? 1 : 0
            );

            if(responseModel.status == 'success') {

              isLoading = false;
              update();
              clearAddressFields();
              onRefresh();
              Get.back();

            }else{
              autoValidate = AutovalidateMode.onUserInteraction;
              isLoading = false;
              update();
              UIUtils.bottomToast(text: responseModel.msg!, isError: true);
            }

          }
          on Exception catch(_,e){
            isLoading = false;
            update();
          }
        }
        else {
          // No-Internet Case
          UIUtils.showInternetErrorToast();
        }
      });
    }
    else{
      autoValidate = AutovalidateMode.onUserInteraction;
      update();
    }
  }

  void clearAddressFields() {
    nameController.clear();
    addressController.clear();
    landmarkController.clear();
    cityController.clear();
    stateController.clear();
    pincodeController.clear();
    strPincode = "";
    strState = "";
    strCity = "";
    AddressType.home;
    _isDefault = false;
    autoValidate = AutovalidateMode.disabled;
    update();
  }

  void loadAddressForEdit(Address address) {
    //todo name
    // nameController = TextEditingController(text: address.userAddress);
    addressController = TextEditingController(text: address.fullAddress);
    landmarkController = TextEditingController(text: address.landmark);
    // cityController = TextEditingController(text: address.state);
    // stateController = TextEditingController(text: address.state);
    // pincodeController = TextEditingController(text: address.pincode);

    strState = address.state!;
    strCity = address.city!;
    strPincode = address.pincode!;

    _isDefault = address.isDefault == '1' ? true : false;
    _addressType = address.addressTitle == 'Home' ? AddressType.home : address.addressTitle == 'Work' ? AddressType.work : AddressType.other;

    update();
  }

  updateAddressMethod(String addressId) {
    if(editGlobalKey.currentState!.validate())
    {
      ConnectionUtils.checkConnection().then((internet) async {
        if (internet) {
          isLoading = true;
          update();
          try{

            final ResponseModel responseModel = await ApiManager.updateAddress(
                authToken: authToken!,
                addressId: int.parse(addressId),
                address: stateController.text+","+addressController.text,
                landmark: landmarkController.text,
                city: strCity,
                state: strState,
                pincode: strPincode,
                isDefault: isDefault ? 1 : 0,
                title: addressTypeText,
            );

            debugPrint("update_address $addressId -- ${addressController.text}, ${landmarkController.text}");

            if(responseModel.status == 'success') {

              isLoading = false;
              update();
              onRefresh();

            }else{
              autoValidate = AutovalidateMode.onUserInteraction;
              isLoading = false;
              update();
              UIUtils.bottomToast(text: responseModel.msg!, isError: true);
            }

          }
          on Exception catch(_,e){
            isLoading = false;
            update();
          }
        }
        else {
          // No-Internet Case
          UIUtils.showInternetErrorToast();
        }
      });
    }
    else{
      autoValidate = AutovalidateMode.onUserInteraction;
      update();
    }
  }

  void showDeleteAddressDialog(String addressId) {
    Get.dialog(
      AlertDialog(
        title: Text(
          "Delete Address",
          style: AppCss.mulishSemiBold16.textColor(appCtrl.appTheme.primary),
        ),
        content: Text(
          "Are you sure you want to delete this address?",
          style: AppCss.mulishMedium13.textColor(appCtrl.appTheme.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "No",
              style: AppCss.mulishBold14.textColor(appCtrl.appTheme.textColor),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(appCtrl.appTheme.primary),
              foregroundColor: MaterialStateProperty.all(appCtrl.appTheme.white), // text color
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onPressed: () async {
              Get.back();
              deleteAddressMethod(addressId);
            },
            child: Text(
              "Yes",
              style: AppCss.mulishBold14.textColor(appCtrl.appTheme.white),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  deleteAddressMethod(String addressId) {
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        isLoading = true;
        update();
        try{

          final ResponseModel responseModel = await ApiManager.removeAddress(
              authToken: authToken!,
              addressId: int.parse(addressId),
          );

          if(responseModel.status == 'success') {

            isLoading = false;
            update();
            onRefresh();

          }else{
            autoValidate = AutovalidateMode.onUserInteraction;
            isLoading = false;
            update();
            UIUtils.bottomToast(text: responseModel.msg!, isError: true);
          }

        }
        on Exception catch(_,e){
          isLoading = false;
          update();
        }
      }
      else {
        // No-Internet Case
        UIUtils.showInternetErrorToast();
      }
    });
  }

  String get addressTypeText {
    switch (_addressType) {
      case AddressType.home:
        return "Home";
      case AddressType.work:
        return "Work";
      case AddressType.other:
        return "Other";
    }
  }

  Future<void> fetchLatLongFromAddress(String address) async {
    try {
      if (address.isEmpty) return;

      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        latitude = locations.first.latitude;
        longitude = locations.first.longitude;
        update();
      }
    } catch (e) {
      debugPrint("Manual geocode error: $e");
    }
  }

  void onAddressTyping(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 800), () {

      final fullAddress =
          "${addressController.text}, "
          "${cityController.text}, "
          "${stateController.text}, "
          "${pincodeController.text}";

      fetchLatLongFromAddress(fullAddress);
    });
  }

  Future<void> getCurrentLocation() async {

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      UIUtils.bottomToast(text: "Location service disabled", isError: true,);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      UIUtils.bottomToast(text: "Location permission permanently denied", isError: true,);
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    latitude = position.latitude;
    longitude = position.longitude;

    update();
  }

  Future<void> pickLocationFromMap() async {

    LatLng? result = await Get.to(() => const PickMapScreen());

    if (result != null) {
      latitude = result.latitude;
      longitude = result.longitude;

      await _getAddressFromLatLng();

      update();
    }
  }

  Future<void> _getAddressFromLatLng() async {

    List<Placemark> placemarks =
    await placemarkFromCoordinates(latitude!, longitude!);

    Placemark place = placemarks.first;

    addressController.text = "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}";

    cityController.text = place.subLocality ?? "";
    landmarkController.text = place.street ?? "";
    // landmarkController.text = place.subLocality ?? "";
    // pincodeController.text = place.postalCode ?? "";

    strState = place.administrativeArea ?? "";
    strCity = place.locality ?? "";
    strPincode = place.postalCode ?? "";

    update();
  }

}