
import 'package:get/get.dart';
import 'package:tailoredtiffin/model/category_model.dart';
import 'package:tailoredtiffin/model/subcategory_model.dart';

import '../../api/api_manager.dart';
import '../../utils/connection_utils.dart';
import '../../utils/prefs.dart';
import '../../utils/ui_utils.dart';

class SubCatController extends GetxController{
  double mHeight=0,mWidth=0;
  String? authToken,userId;
  bool? isLoading = false;
  AllCategory? selectedCategory;
  List<Subcategory> subCategories = <Subcategory>[];

  @override
  void onReady() {
    super.onReady();
    mHeight = Get.size.height;
    mWidth = Get.size.width;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getPrefs();
  }

  void getPrefs()
  {
    authToken = Prefs.shared.getString(Prefs.authToken);
    userId = Prefs.shared.getString(Prefs.userId);
    selectedCategory = Get.arguments['category'];
    getSubCategory();
    print("Token $authToken");
  }

  void onRefresh() {
    getSubCategory();
  }


  getSubCategory(){
    ConnectionUtils.checkConnection().then((internet) async {
      if (internet) {
        isLoading = true;
        update();

        try{
          final SubcategoryModel model = await ApiManager.getSubCategory(
              catId: selectedCategory!.categoryId!,authToken: authToken!);

          if(model.status == 'success' && model.data!=null) {

            subCategories = model.data! ?? [];

          }else{
            UIUtils.bottomToast(text: 'Error fetching Data', isError: true);
          }

          isLoading = false;
          update();
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

}

