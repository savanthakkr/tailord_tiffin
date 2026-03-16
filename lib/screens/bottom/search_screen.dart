import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/screens/bottom/sub_category_screen.dart';
import 'package:tailoredtiffin/utils/config.dart';
import 'package:tailoredtiffin/widgets/shimmer_layout.dart';

import '../../controllers/bottom/search_controller.dart';
import '../../widgets/text_field_common.dart';
import '../products_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var controller = Get.put(SearchProductController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchProductController>(
      builder: (ctrl) {
        return  ctrl.isLoading!
            ? const CommonShimmerLayout(hasBanner: false,)
            : Container(
              margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
              child: Column(
                children: [
                  addVerticalSpace(Dimensions.heightSize*0.5),
                  TextFieldCommon(
                    controller: ctrl.searchController,
                    labelText: 'Search Product',
                    hintText: 'Search Product',
                    isReadOnly: true,
                    onTap: (){
                      Get.to(()=> const ProductsScreen(),arguments: {'type': 'All Product','products': null});
                    },
                  ),
                  addVerticalSpace(Dimensions.heightSize),
                  Expanded(
                    child: MasonryGridView.count(
                      crossAxisCount: 2, // Number of columns
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      itemBuilder: (context, index) {
                        final item =  controller.categories[index];
                        return InkWell(
                          onTap: () {
                            Get.to(()=> const SubCategoryScreen(),arguments: {'category': item});
                          },
                          child: SizedBox(
                            height: (index % 5 + 2) * 50.0, // Example: varying heights
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

                                  // Text at center
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        item.categoryName!.toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: AppCss.mulishSemiBold14.textColor(appCtrl.appTheme.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: controller.categories.length,
                    ),
                  ),
                ],
              ),
            );
      }
    );
  }
}
