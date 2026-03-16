import 'package:get/get_utils/src/get_utils/get_utils.dart';

String? emailValidator(String? value) {
  if (value != null && !GetUtils.isEmail(value)) {
    return "Please enter a valid email address";
  }
  return null;
}

String? nameValidator(String? value) {
  if (value != null && value.length < 3) {
    return "Invalid First Name";
  }
  return null;
}

String? promoValidator(String? value) {
  if (value != null && value.length < 3) {
    return "Invalid Promocode";
  }
  return null;
}


String? phoneValidator(String? value) {
  if (value != null && !GetUtils.isPhoneNumber(value)) {
    return "Please enter valid phone number";
  } else {
    return null;
  }
}

String? passwordValidator(String? password) {
  String? _errorMessage = '';

  if (password!=null && password.length <6) {
    _errorMessage += 'Password must be longer than 6 characters.\n';
  }

  /*
  // Contains at least one uppercase letter
  if (!password!.contains(RegExp(r'[A-Z]'))) {
    _errorMessage += '• Uppercase letter is missing.\n';
  }

  // Contains at least one lowercase letter
  if (!password.contains(RegExp(r'[a-z]'))) {
    _errorMessage += '• Lowercase letter is missing.\n';
  }

  // Contains at least one digit
  if (!password.contains(RegExp(r'[0-9]'))) {
    _errorMessage += '• Digit is missing.\n';
  }

  // Contains at least one special character
  if (!password.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
    _errorMessage += '• Special character is missing.\n';
  }

   */

  if(_errorMessage.isNotEmpty){
    return _errorMessage;
  }
  return null;
}
