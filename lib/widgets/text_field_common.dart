import 'package:flutter/material.dart';

import '../utils/config.dart';

class TextFieldCommon extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final Widget? suffixIcon, prefixIcon;
  final Color? fillColor,focusedBorderColor;
  final bool obscureText,isReadOnly;
  final InputBorder? border;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final int? maxLength,minLines,maxLines;
  final TextCapitalization? textCapitalization;
  final AutovalidateMode autoValidateMode;
  final VoidCallback? onTap;

  const TextFieldCommon(
      {super.key,
      this.hintText,
      this.labelText,
      this.validator,
      this.controller,
      this.suffixIcon,
      this.prefixIcon,
      this.border,
      this.obscureText = false,
      this.isReadOnly = false,
      this.fillColor,
      this.focusedBorderColor,
      this.keyboardType,
      this.focusNode,
      this.onChanged,
      this.maxLength,this.minLines, this.maxLines,
      this.textCapitalization,
      this.autoValidateMode = AutovalidateMode.disabled,
      this.onTap,
      });

  @override
  Widget build(BuildContext context) {
    // Text field common
    return TextFormField(
      maxLines: maxLines,
      focusNode: focusNode,
      style: AppCss.mulishSemiBold14.textColor(appCtrl.appTheme.textColor),
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        controller: controller,
        onChanged: onChanged,
        minLines: minLines,
        maxLength: maxLength,
        autovalidateMode: autoValidateMode,
        cursorColor: focusedBorderColor ?? appCtrl.appTheme.primary,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        readOnly: isReadOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: labelText,
            floatingLabelBehavior: labelText != null ? FloatingLabelBehavior.always : FloatingLabelBehavior.never ,
            floatingLabelStyle: AppCss.mulishSemiBold12
                .textColor(focusedBorderColor ?? appCtrl.appTheme.primary),
            fillColor: fillColor ?? appCtrl.appTheme.textFieldColor,
            filled: labelText != null ? false : true,
            focusedBorder: OutlineInputBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(Dimensions.radius)),
                borderSide: BorderSide(width: 0.8,
                    color: focusedBorderColor ?? appCtrl.appTheme.borderColor,
                    style: BorderStyle.solid)),
            enabledBorder: border ??
                OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(Dimensions.radius)),
                    borderSide: BorderSide(width: 0.8,
                        color: appCtrl.appTheme.borderColor,
                        style: BorderStyle.solid)),
            border:  border ??
                OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(Dimensions.radius)),
                    borderSide: BorderSide(width: 0.8,
                        color: appCtrl.appTheme.borderColor,
                        style: BorderStyle.solid)),
            contentPadding: EdgeInsets.symmetric(
                horizontal: Dimensions.widthSize*0.8, vertical: Dimensions.heightSize*1.3),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            errorStyle: AppCss.mulishRegular12.textColor(appCtrl.appTheme.errorColor),
            hintStyle: AppCss.mulishLight14.textColor(appCtrl.appTheme.hintColor),
            labelStyle: AppCss.mulishSemiBold12.textColor(appCtrl.appTheme.secondaryText),
            hintText: hintText
        )
    );
  }
}
