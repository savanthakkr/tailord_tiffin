import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/address_controller.dart';
import '../../model/address_model.dart';
import '../../utils/config.dart';
import 'add_address_screen.dart';
import 'edit_address_screen.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({super.key});

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
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
                  title: 'Saved Addresses',
                  backEnable: true,
                  centerTitle: true,
                  bgColor: appCtrl.appTheme.white,
                  leadingOnTap: () => _onBackPressed(),
                ),
                body: ListView.builder(
                  padding: EdgeInsets.only(top: Dimensions.heightSize),
                  itemCount: addressCtrl.addressList.length,
                  itemBuilder: (context, index) {
                    return _addressItem(addressCtrl.addressList[index]);
                  },
                ),
                bottomNavigationBar: Container(
                  padding: EdgeInsets.all(Dimensions.widthSize),
                  color: appCtrl.appTheme.white,
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        addressCtrl.clearAddressFields();
                        Get.to(() => const AddAddressScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appCtrl.appTheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimensions.radius),
                        ),
                      ),
                      icon: Icon(Icons.add,color: appCtrl.appTheme.white,),
                      label: Text("Add New Address",style: AppCss.mulishBold14.textColor(appCtrl.appTheme.white),),
                    ),
                  ),
                ),
                // floatingActionButton: FloatingActionButton.small(
                //   onPressed: () {
                //     addressCtrl.clearAddressFields();
                //     Get.to(()=> const AddAddressScreen());
                //   },
                //   backgroundColor: appCtrl.appTheme.primary,
                //   child: Icon(Icons.add_rounded,
                //     color: appCtrl.appTheme.white,
                //   ),
                // ),
              );
            }
        )
    );
  }


  Widget _addressItem(Address address) {
    return InkWell(
      onTap: (){
        addressCtrl.addressList.forEach((e) {
          e.isDefault = "0";
        });
        address.isDefault = "1";
        addressCtrl.update();
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Dimensions.widthSize,
          vertical: Dimensions.heightSize * 0.6,
        ),
        padding: EdgeInsets.all(Dimensions.widthSize),
        decoration: BoxDecoration(
          color: appCtrl.appTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: appCtrl.appTheme.borderColor,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 📍 Location Icon
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: appCtrl.appTheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on,
                color: appCtrl.appTheme.primary,
                size: 20,
              ),
            ),

            addHorizontalSpace(12),

            /// Address Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Title Row
                  Row(
                    children: [
                      Text(
                        address.addressTitle ?? "",
                        style: AppCss.mulishSemiBold16.textColor(
                            appCtrl.appTheme.primary),
                      ),

                      if (address.isDefault == "1") ...[
                        addHorizontalSpace(8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: appCtrl.appTheme.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "Default",
                            style: AppCss.mulishMedium12.textColor(
                                appCtrl.appTheme.primary),
                          ),
                        ),
                      ]
                    ],
                  ),

                  addVerticalSpace(6),

                  /// Full Address
                  Text(
                    "${address.fullAddress}, "
                        "${address.landmark}, "
                        "${address.city}, "
                        "${address.state} - ${address.pincode}",
                    style: AppCss.mulishMedium14.textColor(
                        appCtrl.appTheme.secondaryText),
                  ),

                ],
              ),
            ),

            /// Actions
            Row(
              children: [
                InkWell(
                  onTap: () {
                    addressCtrl.loadAddressForEdit(address);
                    Get.to(() => EditAddressScreen(
                      addressId: address.addressId!,
                    ));
                  },
                  child: Icon(
                    Icons.edit_outlined,
                    size: 22,
                    color: appCtrl.appTheme.secondaryText,
                  ),
                ),
                addHorizontalSpace(Dimensions.widthSize*0.5),

                InkWell(
                  onTap: () {
                    addressCtrl.showDeleteAddressDialog(address.addressId!);
                  },
                  child: Icon(
                    Icons.delete_outline_rounded,
                    size: 22,
                    color: appCtrl.appTheme.errorColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
