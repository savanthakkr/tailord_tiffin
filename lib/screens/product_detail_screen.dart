import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/controllers/bottom/wish_controller.dart';
import 'package:tailoredtiffin/controllers/product_detail_controller.dart';
import 'package:tailoredtiffin/model/cart_model.dart';
import 'package:tailoredtiffin/widgets/empty_layout.dart';

import '../controllers/bottom/cart_controller.dart';
import '../controllers/bottom/home_controller.dart';
import '../utils/config.dart';
import '../widgets/cart_count_widget.dart';
import '../widgets/page_indicator.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  var productCtrl = Get.put(ProductDetailController());
  var cartCtrl = Get.find<CartController>();
  var wishCtrl = Get.find<WishController>();

  Future<bool> _onBackPressed() async{
    Get.find<HomeController>().onRefresh();
    // IntentUtils.fireIntent(context, const MobileVerifyScreen());
    Get.back();
    return false;
  }


  @override
  Widget build(BuildContext context) {
    // return PopScope(
    //     onPopInvokedWithResult: (didPop, result) {
    //       if (didPop) {
    //         return;
    //       }
    //       if (context.mounted) {
    //         _onBackPressed();
    //       }
    //     },
    //     child: GetBuilder<ProductDetailController>(
    //         builder: (ctrl) {
    //           return GetBuilder<CartController>(
    //             id: "cartList",
    //             builder: (cartController) {
    //               return GetBuilder<WishController>(
    //                 id: "wishList",
    //                 builder: (wishController) {
    //
    //                   // final isAddedToCart = cartCtrl.addedToCart(productCtrl.product);
    //                   // final cartElement = cartCtrl.getCartProduct(productCtrl.product);
    //
    //                   final isAddedToWishlist = wishCtrl.addedToWishlist(productCtrl.product);
    //
    //                   return Scaffold(
    //                     backgroundColor: appCtrl.appTheme.white,
    //                     appBar: CommonAppbar(
    //                       title: '',
    //                       backEnable: true,
    //                       centerTitle: true,
    //                       bgColor: appCtrl.appTheme.white,
    //                       leadingOnTap: () => _onBackPressed(),
    //                       actions: const [
    //                         CartCountWidget()
    //                       ],
    //                     ),
    //                     body: productCtrl.product != null
    //                       ? SingleChildScrollView(
    //                       padding: EdgeInsets.symmetric(
    //                           horizontal: 0,
    //                           vertical: Dimensions.heightSize
    //                       ),
    //                       child: Column(
    //                         crossAxisAlignment: crossStart,
    //                         children: [
    //
    //                           _bannerWidget(),
    //                           addVerticalSpace(Dimensions.heightSize),
    //
    //                           //page indicator
    //                           Row(
    //                             mainAxisAlignment: mainCenter,
    //                             crossAxisAlignment: crossEnd,
    //                             children: [
    //                               Obx(() => SingleChildScrollView(
    //                                 scrollDirection: Axis.horizontal,
    //                                 child: Row(
    //                                   children: [
    //                                     for (int i = 0; i < productCtrl.product!.images!.length; i++)
    //                                       PageIndicator(
    //                                         isActive: i == productCtrl.initialPage.value,
    //                                       )
    //                                   ],
    //                                 ),
    //                               )),
    //                             ],
    //                           ),
    //
    //                           addVerticalSpace(Dimensions.heightSize),
    //
    //                           //name
    //                           Row(
    //                             mainAxisAlignment: mainSpaceBet,
    //                             children: [
    //
    //                               Text(productCtrl.product!.productName!,
    //                                 style: AppCss.mulishSemiBold18.textColor(appCtrl.appTheme.primary),),
    //
    //                               InkWell(
    //                                 onTap: () {
    //                                   if(isAddedToWishlist)
    //                                     {
    //                                       final wishElement = wishCtrl.getWishProduct(productCtrl.product);
    //                                       wishCtrl.removeWishItem(wishId: wishElement!.wishlistId!);
    //                                     }
    //                                   else{
    //                                     wishCtrl.addProductToWishlist(productId: productCtrl.product!.productId!);
    //                                   }
    //                                 },
    //                                 child: SvgPicture.asset(
    //                                   isAddedToWishlist
    //                                       ? assets.heartFilled
    //                                       : assets.favSvg,
    //                                   height: 20,
    //                                   colorFilter: ColorFilter.mode(appCtrl.appTheme.primary,
    //                                       BlendMode.srcATop),
    //                                 ),
    //                               ),
    //
    //                             ],
    //                           ).paddingSymmetric(horizontal: Dimensions.widthSize),
    //
    //                           addVerticalSpace(Dimensions.heightSize*0.5),
    //
    //                           RatingBar.builder(
    //                             initialRating: productCtrl.product!.productReview != null
    //                                 ? double.parse(productCtrl.product!.productReview!)
    //                                 : 0,
    //                             minRating: 1,
    //                             direction: Axis.horizontal,
    //                             allowHalfRating: true,
    //                             itemCount: 5,
    //                             itemSize: 15,
    //                             ignoreGestures: true,
    //                             itemPadding: EdgeInsets.zero,
    //                             itemBuilder: (context, _) => Icon(
    //                               Icons.star_rounded,
    //                               size: Dimensions.iconSizeSmall,
    //                               color: appCtrl.appTheme.ratingYellow,
    //                             ), onRatingUpdate: (double value) {},
    //                           ).paddingSymmetric(horizontal: Dimensions.widthSize),
    //
    //                           addVerticalSpace(Dimensions.heightSize*0.5),
    //
    //                           //price & cart widget
    //                           Row(
    //                             mainAxisAlignment: mainSpaceBet,
    //                             children: [
    //
    //                               //price
    //                               Row(
    //                                 children: [
    //                                   Text('\u20b9${productCtrl.product!.productBasePrice}',
    //                                     style: AppCss.mulishSemiBold16.textColor(appCtrl.appTheme.secondaryText).lineThrough,),
    //                                   addHorizontalSpace(Dimensions.widthSize*0.5),
    //                                   Text('\u20b9${productCtrl.product!.productSalePrice}',
    //                                     style: AppCss.mulishSemiBold18.textColor(appCtrl.appTheme.primary),),
    //                                 ],
    //                               ),
    //
    //                               addHorizontalSpace(Dimensions.widthSize),
    //
    //                               //cart
    //                               if(isAddedToCart && cartElement!=null)Card(
    //                                 elevation: 0,
    //                                 color: appCtrl.appTheme.white,
    //                                 shape: RoundedRectangleBorder(
    //                                   borderRadius: BorderRadius.circular(Dimensions.radius),
    //                                   side: BorderSide(color: appCtrl.appTheme.borderColor)
    //                                 ),
    //                                 child: Row(
    //                                   mainAxisAlignment: mainCenter,
    //                                   children: [
    //                                     InkWell(
    //                                         onTap: () {
    //                                           int quantity = int.parse(cartElement.productQuantity ?? '0');
    //                                           quantity = quantity + 1;
    //                                           cartCtrl.updateProductQuantity(cartId: cartElement.cartId!, quantity: quantity);
    //                                         },
    //                                         child: Icon(Icons.add_rounded,color: appCtrl.appTheme.primary,)
    //                                     ),
    //
    //                                     addHorizontalSpace(Dimensions.widthSize),
    //
    //                                     Text('${cartElement.productQuantity}',
    //                                       style: AppCss.mulishSemiBold16.textColor(appCtrl.appTheme.hintColor),
    //                                     ),
    //
    //                                     addHorizontalSpace(Dimensions.widthSize),
    //
    //                                     InkWell(
    //                                         onTap: () {
    //                                           int quantity = int.parse(cartElement.productQuantity ?? '0');
    //
    //                                           if(quantity>1) {
    //                                             quantity = quantity - 1;
    //                                             cartCtrl.updateProductQuantity(
    //                                                 cartId: cartElement.cartId!,
    //                                                 quantity: quantity);
    //                                           }
    //                                           else{
    //                                             cartCtrl.removeCart(cartId: cartElement.cartId!);
    //                                             cartCtrl.onRefresh();
    //                                             productCtrl.update();
    //                                           }
    //                                         },
    //                                         child: Icon(Icons.remove_rounded,color: appCtrl.appTheme.primary,)
    //                                     ),
    //                                   ],
    //                                 ).paddingSymmetric(horizontal: Dimensions.widthSize,vertical: Dimensions.heightSize*0.5),
    //                               ),
    //                             ],
    //                           ).paddingSymmetric(horizontal: Dimensions.widthSize),
    //
    //                           Divider(
    //                             color: appCtrl.appTheme.borderColor,
    //                             thickness: 4,
    //                             height: Dimensions.heightSize,
    //                           ),
    //
    //                           ListView.builder(
    //                             shrinkWrap: true,
    //                               physics: const NeverScrollableScrollPhysics(),
    //                               padding: EdgeInsets.symmetric(horizontal: Dimensions.widthSize),
    //                               itemBuilder: (context, index) {
    //
    //                                 var attribute = productCtrl.product!.attributes![index];
    //
    //                                 return Column(
    //                                   mainAxisSize: mainMin,
    //                                   crossAxisAlignment: crossStart,
    //                                   children: [
    //                                     Text(attribute.attributeName ?? '',
    //                                       style: AppCss.mulishMedium14.textColor(appCtrl.appTheme.secondaryText),),
    //
    //                                     SingleChildScrollView(
    //                                       scrollDirection: Axis.horizontal,
    //                                       child: Row(
    //                                         children: [
    //                                           for(int i=0 ; i<attribute.values!.length; i++)
    //                                             Text(attribute.values![i],
    //                                               style: AppCss.mulishSemiBold14.textColor(appCtrl.appTheme.primary),),
    //                                         ],
    //                                       ),
    //                                     )
    //                                   ],
    //                                 );
    //                               },
    //                           itemCount: productCtrl.product!.attributes!.length,
    //                           ),
    //
    //                           Divider(
    //                             color: appCtrl.appTheme.borderColor,
    //                             thickness: 4,
    //                             height: Dimensions.heightSize,
    //                           ),
    //
    //                           Text('Description',
    //                             style: AppCss.mulishMedium12.textColor(appCtrl.appTheme.primary),
    //                           ).paddingSymmetric(horizontal: Dimensions.widthSize),
    //                           addVerticalSpace(Dimensions.heightSize*0.5),
    //                           Text(productCtrl.product!.productDescription ?? '',
    //                             style: AppCss.mulishSemiBold13.textColor(appCtrl.appTheme.secondaryText),
    //                           ).paddingSymmetric(horizontal: Dimensions.widthSize),
    //
    //                         ],
    //                       ),
    //                     )
    //                     : EmptyLayout(
    //                         image: assets.cartPng,
    //                         title: 'Product Not Found',
    //                         subtitle: 'The product is unavailable at this moment',
    //                         btnText: 'Go back',
    //                         onBtnTap: () => _onBackPressed(),
    //                     ),
    //                     bottomNavigationBar: PrimaryButtonWidget(
    //                         isLoading: cartCtrl.updatingCart,
    //                         onPressed: () {
    //                           if(isAddedToCart && cartElement!=null)
    //                           {
    //                             int quantity = int.parse(cartElement.productQuantity ?? '0');
    //                             quantity = quantity + 1;
    //                             cartCtrl.updateProductQuantity(cartId: cartElement.cartId!, quantity: quantity);
    //                           }
    //                           else{
    //                             // cartCtrl.addProductToCart(productId: productCtrl.product!.productId!);
    //                             // cartCtrl.onRefresh();
    //                             // productCtrl.update();
    //                           }
    //                         },
    //                         text: '+ Add To Cart'
    //                     ).marginSymmetric(horizontal: Dimensions.widthSize,vertical: Dimensions.heightSize),
    //                   );
    //                 }
    //               );
    //             }
    //           );
    //         }
    //     )
    // );
    return Container();
  }

  _bannerWidget() {
    return CarouselSlider(
      carouselController: productCtrl.controller,
      items: productCtrl.product!.images!.map((image) {
        if (image.isEmpty) {
          // Handle null thumbnail case
          return const Center(
            child: Text(
              'Image not found',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: double.infinity,
              color: appCtrl.appTheme.cardColor,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.widthSize,vertical: Dimensions.heightSize),
                child: Image.network(
                  '${ApiManager.imgUrl}$image',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(assets.smallLogo),
                ),
              ),
            );
          },
        );
      }).toList(),
      options: CarouselOptions(
        height: Get.height * 0.3,
        viewportFraction: 1.0,
        autoPlay: true,
        enlargeCenterPage: false,
        onPageChanged: (index, reason) => productCtrl.onBannerChanged(index, reason),
      ),
    );
  }
}
