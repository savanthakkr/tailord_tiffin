import 'package:get/get.dart';
import '../app_theme/app_controller.dart';
import 'assets.dart';

export 'package:tailoredtiffin/app_theme/text_style_extensions.dart';
export 'package:tailoredtiffin/app_theme/app_css.dart';
export 'package:tailoredtiffin/utils/dimensions.dart';
export 'package:tailoredtiffin/widgets/appbar_common.dart';
export 'package:tailoredtiffin/widgets/primary_button.dart';
export 'package:tailoredtiffin/utils/size.dart';
export 'package:tailoredtiffin/utils/ui_utils.dart';
export 'package:tailoredtiffin/utils/prefs.dart';
export 'package:tailoredtiffin/utils/connection_utils.dart';
export 'package:tailoredtiffin/api/api_manager.dart';



// AppTheme appTheme = Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark ? ;
final appCtrl = Get.isRegistered<AppController>()
    ? Get.find<AppController>()
    : Get.put(AppController());

Assets assets = Assets();