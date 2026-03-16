import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/controllers/profile_controller.dart';
import 'package:tailoredtiffin/screens/address/address_list_screen.dart';
import 'package:tailoredtiffin/screens/auth/change_password_screen.dart';
import 'package:tailoredtiffin/screens/edit_profile_screen.dart';
import 'package:tailoredtiffin/screens/order_history_screen.dart';
import 'package:tailoredtiffin/screens/wallet_screen.dart';

import '../../app_theme/theme_service.dart';
import '../../controllers/address_controller.dart';
import '../../utils/config.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var prCtrl = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (ctrl) {
        return ListView(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.widthSize,
            vertical: Dimensions.heightSize
          ),
          children: [
            addVerticalSpace(Dimensions.heightSize),
            Text(prCtrl.userName ?? '',
              textAlign: TextAlign.start,
              style: AppCss.mulishSemiBold18.textColor(appCtrl.appTheme.primary).letterSpace(0.5),),
            Text('+91 ${prCtrl.userPhone}',
              textAlign: TextAlign.start,
              style: AppCss.mulishRegular14.textColor(appCtrl.appTheme.secondaryText),),
            addVerticalSpace(Dimensions.heightSize*1.5),
            _divider(),
            _buildItemWidget(
                onTap: () {
                  Get.to(()=> const EditProfileScreen());
                },
                title: 'Personal info',
                svgIcon: assets.userSvg),
            _divider(),
            _buildItemWidget(
                onTap: () {
                  final ctrl = Get.find<AddressController>();
                  ctrl.clearAddressFields();
                  Get.to(()=> const AddressListScreen());
                },
                title: 'Saved Addresses',
                svgIcon: assets.mapPinSvg),
            _divider(),
            _buildItemWidget(
                onTap: () {
                  Get.to(()=> const WalletScreen());
                },
                title: 'User Wallet',
                svgIcon: assets.walletSvg),
            _divider(),
            _buildItemWidget(
                onTap: () {
                  Get.to(()=> const ChangePasswordScreen());
                },
                title: 'Change Password',
                svgIcon: assets.passwordSvg),
            _divider(),
            _buildItemWidget(
                onTap: () {
                  prCtrl.showLogoutDialog();
                },
                title: 'Sign out',
                svgIcon: assets.logoutSvg),
            _divider(),
            _buildItemWidget(
                onTap: () {

                },
                color: appCtrl.appTheme.errorColor,
                title: 'Delete account',
                svgIcon: assets.cancelSvg),
            // _buildItemWidget(
            //     onTap: () {
            //       var value = !ThemeService().isDarkMode;
            //       debugPrint('isDarkMode : $value');
            //       appCtrl.storage.write(Prefs.isDark, value);
            //       // appCtrl.isTheme = value;
            //       appCtrl.isTheme = value;
            //
            //       appCtrl.update();
            //       ThemeService().switchTheme(appCtrl.isTheme);
            //       Get.forceAppUpdate();
            //     },
            //     title: EnumLocal.appTheme.name.tr,
            //     svgIcon: assets.themeSvg),
            // _divider(),
          ],
        );
      }
    );
  }

  _divider()
  {
    return Divider(
      color: appCtrl.appTheme.hintColor,
      thickness: 0.5,
      height: Dimensions.heightSize,
    );
  }

  _buildItemWidget({required GestureTapCallback onTap,required String title, Color? color,required String svgIcon}){
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
          horizontal: Dimensions.widthSize*0.5,
          vertical: 0
      ),
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color ?? appCtrl.appTheme.borderColor)
        ),
        padding: EdgeInsets.all(Dimensions.defaultPaddingSize),
        child: SvgPicture.asset(svgIcon,
          height: 20,width: 20,
          colorFilter: ColorFilter.mode(
              color ?? appCtrl.appTheme.secondaryText, BlendMode.srcATop),),
      ),
      title: Text(title,
        style: AppCss.mulishMedium16.textColor(
            color ?? appCtrl.appTheme.primary),),
      trailing: (title.toLowerCase().contains('sign') || title.toLowerCase().contains('delete'))
       ? const SizedBox.shrink()
      : Icon(Icons.keyboard_arrow_right_rounded,color: color ?? appCtrl.appTheme.secondaryText,),
    );
  }

}
