import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/controllers/bottom/bottom_bar_controller.dart';
import 'package:tailoredtiffin/model/wish_list_model.dart';
import 'package:tailoredtiffin/utils/config.dart';
import 'package:tailoredtiffin/widgets/empty_layout.dart';
import 'package:tailoredtiffin/widgets/rounded_icon.dart';
import 'package:tailoredtiffin/widgets/shimmer_layout.dart';

import '../../controllers/bottom/wish_controller.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  var wishCtrl = Get.put(WishController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WishController>(
      id: 'wishList',
      builder: (context) {
        return wishCtrl.isLoading
            ? const CommonShimmerLayout(hasBanner: false,)
            : wishCtrl.wishList.isNotEmpty
              ? ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.widthSize,
                      vertical: Dimensions.heightSize
                    ),
                      itemCount: wishCtrl.wishList.length,
                      itemBuilder: (context, index) {
                       return _productItem(wishCtrl.wishList[index]);
                      },
                    separatorBuilder: (context, index) => _divider(),
                  )
              : EmptyLayout(
                  image: assets.cartPng,
                  title: 'Your Wishlist is empty!',
                  subtitle: 'Looks like you haven\'t chosen\nthe items you like.',
                  btnText: 'Shop Now',
                  onBtnTap: () {
                    Get.find<BottomBarController>().onBottomTap(0);
                  },
              );
      }
    );
  }

  _divider()
  {
    return Divider(
      color: appCtrl.appTheme.hintColor,
      thickness: 0.5,
      height: Dimensions.heightSize,
    );
  }

  Widget _productItem(WishElement product) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: crossStart,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius),
            ),
            color: appCtrl.appTheme.cardColor,
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              '${ApiManager.imgUrl}${product.productImage}',
              height: 100,width: 100,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) => Image.asset(assets.smallLogo,height: 100,width: 100),
            ),
          ),
          addHorizontalSpace(Dimensions.widthSize),
          Expanded(
            child: Column(
              crossAxisAlignment: crossStart,
              children: [
                Text(product.productName!,
                  style: AppCss.mulishMedium15.textColor(appCtrl.appTheme.secondaryText),),
                Text('\u20b9${product.productSalePrice}',
                  style: AppCss.mulishSemiBold15.textColor(appCtrl.appTheme.primary),),
                addVerticalSpace(Dimensions.heightSize*0.5),
                // RatingBar.builder(
                //   initialRating: product.rating ?? 0,
                //   minRating: 1,
                //   direction: Axis.horizontal,
                //   allowHalfRating: true,
                //   itemCount: 5,
                //   itemSize: 20,
                //   ignoreGestures: true,
                //   itemPadding: EdgeInsets.zero,
                //   itemBuilder: (context, _) => Icon(
                //     Icons.star_rounded,
                //     size: Dimensions.iconSizeSmall,
                //     color: appCtrl.appTheme.ratingYellow,
                //   ), onRatingUpdate: (double value) {},
                // ),
              ],
            ),
          ),
          addHorizontalSpace(Dimensions.widthSize),
          Column(
            mainAxisAlignment: mainSpaceBet,
            children: [
              InkWell(
                onTap: (){
                  wishCtrl.removeWishItem(wishId: product.wishlistId!);
                },
                child: SvgPicture.asset(assets.heartFilled,
                  height: 20,
                  colorFilter: ColorFilter.mode(appCtrl.appTheme.errorColor, BlendMode.srcATop),),
              ),
              addVerticalSpace(Dimensions.heightSize),
              RoundedIconWidget(
                  color: appCtrl.appTheme.primary,
                  iconColor: appCtrl.appTheme.white,
                  svgAsset: assets.bagSvg)
            ],
          )
        ],
      ),
    );
  }
}
