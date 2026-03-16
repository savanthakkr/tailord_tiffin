import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/address_controller.dart';
import '../../utils/config.dart';
import '../../utils/validation_utils.dart';
import '../../widgets/text_field_common.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  var addressCtrl = Get.find<AddressController>();

  Future<bool> _onBackPressed() async{
    // IntentUtils.fireIntent(context, const MobileVerifyScreen());
    Get.back();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          }
          if (context.mounted) {
            _onBackPressed();
          }
        },
        child: GetBuilder<AddressController>(
            builder: (ctrl) {
              return Scaffold(
                backgroundColor: appCtrl.appTheme.white,
                appBar: CommonAppbar(
                  title: 'Add Address',
                  backEnable: true,
                  centerTitle: true,
                  bgColor: appCtrl.appTheme.white,
                  leadingOnTap: () => _onBackPressed(),
                ),
                body: Form(
                  key: addressCtrl.addGlobalKey,
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.widthSize,
                        vertical: Dimensions.heightSize
                    ),
                    children: [

                      Text(
                        "Address Type",
                        style: AppCss.mulishSemiBold12.textColor(appCtrl.appTheme.secondaryText),
                      ),
                      addVerticalSpace(Dimensions.heightSize*0.5),
                      Row(
                        children: [
                          _radioTile(
                            title: "Home",
                            value: AddressType.home,
                            groupValue: ctrl.addressType,
                            onChanged: ctrl.setAddressType,
                          ),
                          _radioTile(
                            title: "Work",
                            value: AddressType.work,
                            groupValue: ctrl.addressType,
                            onChanged: ctrl.setAddressType,
                          ),
                          _radioTile(
                            title: "Other",
                            value: AddressType.other,
                            groupValue: ctrl.addressType,
                            onChanged: ctrl.setAddressType,
                          ),
                        ],
                      ),

                      addVerticalSpace(Dimensions.heightSize*1.5),

                      //address
                      TextFieldCommon(
                        controller: addressCtrl.addressController,
                        labelText: 'ADDRESS',
                        hintText: 'Xyz colony',
                        validator: (value) => nameValidator(value),
                        onChanged: (value) {
                          addressCtrl.onAddressTyping(value);
                        },
                      ),


                      addVerticalSpace(Dimensions.heightSize*1.5),

                      //landmark
                      TextFieldCommon(
                        controller: addressCtrl.landmarkController,
                        labelText: 'landmark'.toUpperCase(),
                        hintText: 'opp. abc / near abc',
                        validator: (value) => nameValidator(value),),

                      addVerticalSpace(Dimensions.heightSize*1.5),

                      TextFieldCommon(
                        controller: addressCtrl.stateController,
                        labelText: 'State'.toUpperCase(),
                        hintText: 'Gujarat',
                        validator: (value) => nameValidator(value),
                      ),

                      addVerticalSpace(Dimensions.heightSize*1.5),

                      TextFieldCommon(
                        controller: addressCtrl.cityController,
                        labelText: 'city'.toUpperCase(),
                        hintText: 'Vadodara',
                        validator: (value) => nameValidator(value),
                      ),

                      addVerticalSpace(Dimensions.heightSize*1.5),

                      TextFieldCommon(
                        controller: addressCtrl.pincodeController,
                        keyboardType: TextInputType.number,
                        labelText: 'pincode'.toUpperCase(),
                        hintText: '390 001',
                        validator: (value) => nameValidator(value),
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text("Set as default address",style: AppCss.mulishSemiBold12.textColor(appCtrl.appTheme.secondaryText)),
                        value: ctrl.isDefault,
                        activeColor: appCtrl.appTheme.primary,
                        onChanged: (value) =>
                            ctrl.toggleDefault(value ?? false),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      addVerticalSpace(Dimensions.heightSize*1.5),
                      Row(
                        children: [
                          //
                          // Expanded(
                          //   child: OutlinedButton.icon(
                          //     icon: const Icon(Icons.my_location),
                          //     label: const Text("Current Location"),
                          //     onPressed: () => ctrl.getCurrentLocation(),
                          //   ),
                          // ),
                          //
                          // const SizedBox(width: 10),

                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.map),
                              label: const Text("Pick From Map"),
                              onPressed: () => ctrl.pickLocationFromMap(),
                            ),
                          ),

                        ],
                      ),

                      if (ctrl.latitude != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            "Selected Address: ${ctrl.addressController.text}",
                            style: const TextStyle(fontSize: 13,fontWeight: FontWeight.w500),
                          ),
                        ),
                      addVerticalSpace(Dimensions.heightSize*1.5),
                      PrimaryButtonWidget(
                        text: 'Add Address',
                        isLoading: addressCtrl.isLoading,
                        onPressed: () => addressCtrl.addAddressMethod(),
                      ),

                    ],
                  ),
                ),
              );
            }
        )
    );
  }

  Widget _radioTile({
    required String title,
    required AddressType value,
    required AddressType groupValue,
    required Function(AddressType) onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<AddressType>(
          value: value,
          activeColor: appCtrl.appTheme.primary,
          groupValue: groupValue,
          onChanged: (val) => onChanged(val!),
        ),
        Text(title,style: AppCss.mulishSemiBold12.textColor(appCtrl.appTheme.textColor)),
      ],
    );
  }
}
