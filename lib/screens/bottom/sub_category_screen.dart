import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/controllers/sub_cat_controller.dart';
import 'package:tailoredtiffin/utils/config.dart';
import 'package:tailoredtiffin/widgets/cart_count_widget.dart';
import 'package:tailoredtiffin/widgets/shimmer_layout.dart';

import '../products_screen.dart';

class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({super.key});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  var controller = Get.put(SubCatController());

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
      child: GetBuilder<SubCatController>(
        builder: (ctrl) {
          return Scaffold(
            backgroundColor: appCtrl.appTheme.white,
                appBar: CommonAppbar(
                  title: controller.selectedCategory != null ? controller.selectedCategory!.categoryName! : '',
                  backEnable: true,
                  centerTitle: true,
                  bgColor: appCtrl.appTheme.white,
                  leadingOnTap: () => _onBackPressed(),
                  actions: const [
                    CartCountWidget()
                  ],
                ),
                body:  ctrl.isLoading!
                    ? const CommonShimmerLayout(hasBanner: false,)
                    : Container(
                  margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemBuilder: (context, index) {
                      final item =  controller.subCategories[index];
                      return InkWell(
                        onTap: (){
                          Get.to(()=> const ProductsScreen(),arguments: {'type': 'Subcategory','products': null,'subcategory': controller.subCategories[index],'category': controller.selectedCategory});
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Background image
                              Image.asset(
                                "assets/pngs/logo_small.png",
                                fit: BoxFit.contain,
                              ),

                              // Overlay (dark blue-ish)
                              Container(
                                color: Colors.black.withOpacity(0.35),
                              ),

                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    item.subCategoryName!.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: AppCss.mulishSemiBold14.textColor(appCtrl.appTheme.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: controller.subCategories.length,
                  ),
                ),
              );
        }
      ),
    );
  }
}
