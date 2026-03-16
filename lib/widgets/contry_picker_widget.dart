import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

import '../utils/config.dart';

class ContryPickerWidget extends StatelessWidget {
  final ValueChanged<CountryCode>? onChanged;
  final ValueChanged<CountryCode?>? onInit;

  const ContryPickerWidget({super.key,
    required this.onChanged,
    required this.onInit
  });

  @override
  Widget build(BuildContext context) {
    var onCountryChanged;
    return CountryCodePicker(
      onChanged: onCountryChanged,
      onInit: onInit,
      textStyle: AppCss.mulishMedium14.textColor(appCtrl.appTheme.black),
      padding: const EdgeInsets.all(0),
      showFlag: true,
      enabled: false,
      initialSelection: '+91',
      showCountryOnly: true,
      showOnlyCountryWhenClosed: false,
      showFlagMain: true,
      alignLeft: false,
      dialogBackgroundColor: appCtrl.appTheme.white,
      // backgroundColor: appCtrl.appTheme.white,
      dialogTextStyle: AppCss.mulishMedium12.textColor(appCtrl.appTheme.secondaryText),
      headerTextStyle: AppCss.mulishSemiBold15.textColor(appCtrl.appTheme.black),

    );
  }
}
