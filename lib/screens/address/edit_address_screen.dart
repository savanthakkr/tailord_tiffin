import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/address_controller.dart';
import '../../utils/config.dart';
import '../../utils/validation_utils.dart';
import '../../widgets/text_field_common.dart';

class EditAddressScreen extends StatefulWidget {
  final String addressId;
  const EditAddressScreen({super.key, required this.addressId});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
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
                  title: 'Your Addresses',
                  backEnable: true,
                  centerTitle: true,
                  bgColor: appCtrl.appTheme.white,
                  leadingOnTap: () => _onBackPressed(),
                ),
                body: Form(
                  key: addressCtrl.editGlobalKey,
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.widthSize*2.5,
                        vertical: Dimensions.heightSize
                    ),
                    children: [
                      Text(
                        "Edit Address",
                        style: AppCss.mulishMedium14.textColor(appCtrl.appTheme.secondaryText),
                      ),
                      addVerticalSpace(Dimensions.heightSize*1.5),
                      TextFieldCommon(
                        controller: addressCtrl.stateController,
                        labelText: 'Block and No',
                        hintText: 'Block and no',
                        validator: (value) => nameValidator(value,"Enter Bloc No"),
                        onChanged: (value) {
                          addressCtrl.onAddressTyping(value);
                        },
                      ),
                      addVerticalSpace(Dimensions.heightSize*1.5),
                      //landmark
                      TextFieldCommon(
                        controller: addressCtrl.landmarkController,
                        labelText: 'Building Name',
                        hintText: 'Building name',
                        validator: (value) => nameValidator(value,"Enter Building Name"),),
                      addVerticalSpace(Dimensions.heightSize*1.5),
                      TextFieldCommon(
                        controller: addressCtrl.cityController,
                        labelText: 'Area Name',
                        hintText: 'Area Name',
                        validator: (value) => nameValidator(value,"Enter Area Name"),
                      ),
                      addVerticalSpace(Dimensions.heightSize*1.5),
                      TextFieldCommon(
                        controller: addressCtrl.addressController,
                        labelText: 'Google Map Links(optional)',
                        hintText: 'Google Map Links(optional)',
                        isReadOnly: true,
                        onTap: ctrl.pickLocationFromMap,
                      ),
                      addVerticalSpace(Dimensions.heightSize*1.5),
                      Text(
                        "Add Address Label",
                        style: AppCss.mulishMedium14.textColor(appCtrl.appTheme.secondaryText),
                      ),
                      addVerticalSpace(Dimensions.heightSize*0.5),
                      addressTypeSelector(
                        selected: ctrl.addressType,
                        onChanged: ctrl.setAddressType,
                      ),

                      addVerticalSpace(Dimensions.heightSize*1.5),

                      //address
                      // TextFieldCommon(
                      //   controller: addressCtrl.addressController,
                      //   labelText: 'address'.toUpperCase(),
                      //   textCapitalization: TextCapitalization.words,
                      //   hintText: 'Xyz colony',
                      //   validator: (value) => nameValidator(value,"Enter Building Name"),),
                      //
                      // addVerticalSpace(Dimensions.heightSize*1.5),
                      //
                      // // //landmark
                      // // TextFieldCommon(
                      // //   controller: addressCtrl.landmarkController,
                      // //   labelText: 'landmark'.toUpperCase(),
                      // //   textCapitalization: TextCapitalization.words,
                      // //   hintText: 'opp. abc / near abc',
                      // //   validator: (value) => nameValidator(value,"Enter Building Name"),),
                      //
                      // addVerticalSpace(Dimensions.heightSize*1.5),
                      //
                      // TextFieldCommon(
                      //   controller: addressCtrl.stateController,
                      //   textCapitalization: TextCapitalization.words,
                      //   labelText: 'State'.toUpperCase(),
                      //   hintText: 'Gujarat',
                      //   validator: (value) => nameValidator(value,"Enter Building Name"),
                      // ),
                      //
                      // addVerticalSpace(Dimensions.heightSize*1.5),
                      //
                      // TextFieldCommon(
                      //   controller: addressCtrl.cityController,
                      //   textCapitalization: TextCapitalization.words,
                      //   labelText: 'city'.toUpperCase(),
                      //   hintText: 'Vadodara',
                      //   validator: (value) => nameValidator(value,"Enter Building Name"),
                      // ),
                      //
                      // addVerticalSpace(Dimensions.heightSize*1.5),
                      //
                      // TextFieldCommon(
                      //   controller: addressCtrl.pincodeController,
                      //   keyboardType: TextInputType.number,
                      //   labelText: 'pincode'.toUpperCase(),
                      //   hintText: '390 001',
                      //   validator: (value) => nameValidator(value,"Enter Building Name"),
                      // ),
                      //
                      // CheckboxListTile(
                      //   contentPadding: EdgeInsets.zero,
                      //   title: Text("Set as default address",style: AppCss.mulishSemiBold12.textColor(appCtrl.appTheme.secondaryText)),
                      //   value: ctrl.isDefault,
                      //   activeColor: appCtrl.appTheme.primary,
                      //   onChanged: (value) =>
                      //       ctrl.toggleDefault(value ?? false),
                      //   controlAffinity: ListTileControlAffinity.leading,
                      // ),
                      addVerticalSpace(Dimensions.heightSize*1.5),

                      PrimaryButtonWidget(
                        text: 'Save Changes',
                        backgroundColor: appCtrl.appTheme.logoutColor,
                        isLoading: addressCtrl.isLoading,
                        onPressed: () {
                          addressCtrl.updateAddressMethod(widget.addressId);
                        },
                      ),

                    ],
                  ),
                ),
              );
            }
        )
    );
  }

  Widget addressTypeSelector({
    required AddressType selected,
    required Function(AddressType) onChanged,
  }) {
    Widget buildItem(String title, AddressType type) {
      bool isSelected = selected == type;

      return GestureDetector(
        onTap: () => onChanged(type),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? appCtrl.appTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: appCtrl.appTheme.primary,
            ),
          ),
          child: Text(
            title,
            style: AppCss.mulishMedium14.textColor(
              isSelected ? Colors.white : appCtrl.appTheme.primary,
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildItem("Home", AddressType.home),
        const SizedBox(width: 10),
        buildItem("Work", AddressType.work),
        const SizedBox(width: 10),
        buildItem("Other", AddressType.other),
      ],
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
