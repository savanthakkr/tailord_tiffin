import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/controllers/products_controller.dart';
import 'package:tailoredtiffin/utils/config.dart';
import 'package:tailoredtiffin/widgets/cart_count_widget.dart';
import 'package:tailoredtiffin/widgets/product_widget.dart';

import '../model/category_model.dart';
import '../model/subcategory_model.dart';
import '../widgets/text_field_common.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {

  var productsCtrl = Get.put(ProductsController());

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
        child: GetBuilder<ProductsController>(
          builder: (ctrl) {
            return Scaffold(
              backgroundColor: appCtrl.appTheme.white,
              appBar: CommonAppbar(
                title: productsCtrl.productsType == "Subcategory" ? productsCtrl.selectedSubCategory!.subCategoryName! : productsCtrl.productsType ?? '',
                backEnable: true,
                centerTitle: true,
                bgColor: appCtrl.appTheme.white,
                leadingOnTap: () => _onBackPressed(),
                actions: const [
                  CartCountWidget()
                ],
              ),
              body: Column(
                children: [
                  topFilterBar(context),
                  // Expanded(
                  //   child: GridView.builder(
                  //     padding: EdgeInsets.symmetric(
                  //         horizontal: Dimensions.widthSize,
                  //         vertical: Dimensions.heightSize
                  //     ),
                  //     shrinkWrap: true,
                  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //       crossAxisCount: 2, // items per row
                  //       crossAxisSpacing: 8.0,
                  //       mainAxisSpacing: 8.0,
                  //       childAspectRatio: 0.75
                  //     ),
                  //     itemCount: productsCtrl.productsList.length,
                  //     itemBuilder: (BuildContext context, int index) {
                  //       return ProductWidget(product: productsCtrl.productsList[index],
                  //       imgHeight: 160,imgWidth: productsCtrl.mWidth*0.5,);
                  //     },
                  //   ),
                  // ),
                ],
              ),
            );
          }
        )
    );
  }

  Widget topFilterBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextFieldCommon(
              controller: productsCtrl.searchController,
              labelText: 'Search Product',
              hintText: 'Search Product',
              onChanged: (value){
                productsCtrl.searchProducts(value);
              },
            ),
          ),
          addHorizontalSpace(Dimensions.widthSize),
          InkWell(
            onTap: () => openPriceFilterSheet(context),
            child: Row(
              children: [
                Icon(Icons.filter_list, size: 20,color: appCtrl.appTheme.secondaryText,),
                addHorizontalSpace(Dimensions.widthSize*0.5),
                Text(
                  "Filters",
                  style: AppCss.mulishMedium14.textColor(appCtrl.appTheme.secondaryText),
                ),
              ],
            ),
          ),

          // Sorting button
          // InkWell(
          //   onTap: () => openSortingDialog(context),
          //   child: Row(
          //     children: [
          //       Text(
          //         "Sorting by",
          //         style:  AppCss.mulishMedium14.textColor(appCtrl.appTheme.secondaryText),
          //       ),
          //       addHorizontalSpace(Dimensions.widthSize*0.5),
          //       Icon(Icons.keyboard_arrow_down,color: appCtrl.appTheme.secondaryText),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  void openSortingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: appCtrl.appTheme.white,
          contentPadding: EdgeInsets.zero,
          elevation: 0,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _sortTile("Sale"),
              _sortTile("Top"),
              _sortTile("Newest"),
              _sortTile("Price: low to high"),
              _sortTile("Price: high to low"),
            ],
          ),
        );
      },
    );
  }

  Widget _sortTile(String title) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppCss.mulishMedium15.textColor(appCtrl.appTheme.textColor)),
            Icon(Icons.radio_button_off, size: 20,color: appCtrl.appTheme.textColor,)
          ],
        ),
      ),
    );
  }

  void openPriceFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.45,
          maxChildSize: 0.9,
          minChildSize: 0.32,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(Dimensions.defaultPaddingSize),
              decoration: BoxDecoration(
                color: appCtrl.appTheme.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.radius*2)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: _priceFilterContent(context),
              ),
            );
          },
        );
      },
    );
  }

  Widget _priceFilterContent(BuildContext context) {
    RangeValues priceRange = const RangeValues(100, 1000);

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: Dimensions.heightSize),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Text(
              "Category",
              style: AppCss.mulishSemiBold16
                  .textColor(appCtrl.appTheme.primary),
            ),
            addVerticalSpace(8),
            Wrap(
              spacing: 5,
              runSpacing: 0,
              children: productsCtrl.categories.map((cat) {
                final bool isSelected =
                    productsCtrl.selectedCategory == cat;
                return ChoiceChip(
                  label: Text(
                    cat.categoryName!,
                    style: AppCss.mulishLight12.textColor(
                      isSelected
                          ? appCtrl.appTheme.primary
                          : appCtrl.appTheme.textColor,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor:
                  appCtrl.appTheme.primary.withOpacity(0.15),
                  backgroundColor: Colors.transparent,
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: isSelected
                          ? appCtrl.appTheme.primary
                          : Colors.grey.shade300,
                    ),
                  ),
                  onSelected: (selected) {
                    setState(() {
                      productsCtrl.selectcategory(
                          selected ? cat : null);
                    });
                  },
                );
              }).toList(),
            ),
            if (productsCtrl.selectedCategory != null &&
                productsCtrl.subCategories.isNotEmpty) ...[
              addVerticalSpace(Dimensions.heightSize),
              Text(
                "Sub Category",
                style: AppCss.mulishSemiBold16
                    .textColor(appCtrl.appTheme.primary),
              ),
              addVerticalSpace(8),
              Wrap(
                spacing: 3,
                runSpacing: 0,
                children: productsCtrl.subCategories.map((sub) {
                  final bool isSelected =
                      productsCtrl.selectedSubCategory == sub;

                  return ChoiceChip(
                    label: Text(
                      sub.subCategoryName!,
                      style: AppCss.mulishLight12.textColor(
                        isSelected
                            ? appCtrl.appTheme.primary
                            : appCtrl.appTheme.textColor,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor:
                    appCtrl.appTheme.primary.withOpacity(0.15),
                    backgroundColor: Colors.transparent,
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: isSelected
                            ? appCtrl.appTheme.primary
                            : Colors.grey.shade300,
                      ),
                    ),
                    onSelected: (selected) {
                      setState(() {
                        productsCtrl.selectSubcategory(
                            selected ? sub : null);
                      });
                    },
                  );
                }).toList(),
              ),
            ],
            addVerticalSpace(Dimensions.heightSize),
            Text(
              "Price Range",
              style: AppCss.mulishSemiBold16
                  .textColor(appCtrl.appTheme.primary),
            ),
            addVerticalSpace(Dimensions.heightSize),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₹${priceRange.start.toInt()}",
                  style: AppCss.mulishMedium12
                      .textColor(appCtrl.appTheme.textColor),
                ),
                Text(
                  "₹${priceRange.end.toInt()}",
                  style: AppCss.mulishMedium12
                      .textColor(appCtrl.appTheme.textColor),
                ),
              ],
            ),
            RangeSlider(
              values: priceRange,
              min: 100,
              max: 10000,
              divisions: 50,
              activeColor: appCtrl.appTheme.primary,
              inactiveColor: appCtrl.appTheme.secondaryText,
              labels: RangeLabels(
                "₹${priceRange.start.toInt()}",
                "₹${priceRange.end.toInt()}",
              ),
              onChanged: (values) {
                setState(() {
                  priceRange = values;
                });
              },
            ),
            addVerticalSpace(Dimensions.heightSize * 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryButtonWidget(
                  width: MediaQuery.of(context).size.width*0.45,
                  onPressed: () {
                    Navigator.pop(context);
                    productsCtrl.getAllProduct();
                  },
                  text: "Cancel",
                ),
                addHorizontalSpace(Dimensions.widthSize*0.7),
                PrimaryButtonWidget(
                  width: MediaQuery.of(context).size.width*0.45,
                  onPressed: () {
                    Navigator.pop(context);
                    print("Data of price ${priceRange.start.toInt()} to ${priceRange.end.toInt()}");
                    productsCtrl.getFilterProducts(minPrice: priceRange.start.toInt(),maxPrice: priceRange.end.toInt());
                  },
                  text: "Apply Filter",
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
