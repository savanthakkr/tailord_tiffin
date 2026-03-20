import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/controllers/bottom/home_controller.dart';
import 'package:tailoredtiffin/screens/products_screen.dart';
import 'package:tailoredtiffin/utils/config.dart';
import 'package:tailoredtiffin/widgets/product_widget.dart';

import '../../widgets/page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var homeCtrl = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (ctrl) {
        return ctrl.isLoading! ? Center(child: CircularProgressIndicator(color: appCtrl.appTheme.primary,),) : Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE6F4E6), // #e6f4e6
                Color(0xFFFDE4E6), // #fde4e6
                Color(0xFFFFFFFF), // #ffffff
              ],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.symmetric(
              vertical: Dimensions.heightSize,
              horizontal: Dimensions.widthSize
            ),
            children: [
              _bannerWidget(),
              addVerticalSpace(Dimensions.heightSize),
              // Row(
              //   mainAxisAlignment: mainCenter,
              //   crossAxisAlignment: crossEnd,
              //   children: [
              //     Obx(() => SingleChildScrollView(
              //       scrollDirection: Axis.horizontal,
              //       child: Row(
              //         children: [
              //           for (int i = 0; i < homeCtrl.images.length; i++)
              //             PageIndicator(
              //               isActive: i == homeCtrl.initialPage.value,
              //             )
              //         ],
              //       ),
              //     )),
              //   ],
              // ),//page indicator
              // addVerticalSpace(Dimensions.heightSize),
              // _titleWidget(title: 'All Meals', onTap: (){
              //   // Get.to(()=> const ProductsScreen(),arguments: {'type': 'AllMeals','products': homeCtrl.bestSellerList});
              // }),
              GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.widthSizeCard),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: homeCtrl.allMealList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,           // 2 items per row
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.82,      // adjust for card height
                ),
                itemBuilder: (context, index) {
                  return ProductWidget(
                    product: homeCtrl.allMealList[index],
                    subjiList: homeCtrl.allSubjiList,
                    breadList: homeCtrl.allBreadList,
                    specialItemList: homeCtrl.allSpecialItem,
                  );
                },
              ),
            ],
          ),
        );
      }
    );
  }

  _bannerWidget() {
    return CarouselSlider(
      carouselController: homeCtrl.controller,
      items: homeCtrl.images.map((image) {
        if (image.isEmpty) {
          return const Center(
            child: Text(
              'Image not found',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return Builder(
          builder: (BuildContext context) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12), // 🔹 banner radius
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.zero,
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            );
          },
        );
      }).toList(),
      options: CarouselOptions(
        height: Get.height * 0.2,
        viewportFraction: 1.0,
        autoPlay: true,
        enlargeCenterPage: false,
        onPageChanged: (index, reason) =>
            homeCtrl.onBannerChanged(index, reason),
      ),
    );
  }

  _titleWidget({required String title,required GestureTapCallback onTap})
  {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: mainSpaceBet,
        children: [
          Expanded(
            flex: 7,
              child: Text(title,
                style: AppCss.mulishSemiBold15.textColor(appCtrl.appTheme.textColor),)
          ),
          Text('view all',
            style: AppCss.mulishLight12.textColor(appCtrl.appTheme.textColor),),
          addHorizontalSpace(Dimensions.widthSize*0.5),
          SvgPicture.asset(
              assets.nextSvg,
            colorFilter: ColorFilter.mode(appCtrl.appTheme.textColor, BlendMode.srcATop),
          )
        ],
      ).marginOnly(bottom: Dimensions.heightSize),
    );
  }
}
