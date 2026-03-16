import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailoredtiffin/controllers/wallet_controller.dart';
import 'package:tailoredtiffin/model/wallet_model.dart';

import '../utils/config.dart';
import '../widgets/empty_layout.dart';
import '../widgets/shimmer_layout.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {

  var walletCtrl = Get.put(WalletController());

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
        child: GetBuilder<WalletController>(
          builder: (controller) {
            return Scaffold(
              backgroundColor: appCtrl.appTheme.white,
              appBar: CommonAppbar(
                title: 'Wallet',
                backEnable: true,
                centerTitle: true,
                bgColor: appCtrl.appTheme.white,
                leadingOnTap: () => _onBackPressed(),
              ),
              body: walletCtrl.isLoading!
                  ? const CommonShimmerLayout()
                  : walletCtrl.walletList.isNotEmpty
                  ? ListView(
                padding: EdgeInsets.symmetric(
                    vertical: Dimensions.heightSize,horizontal: Dimensions.widthSize
                ),
                children: [
                  Container(
                    height: 100,
                    padding: EdgeInsets.symmetric(
                        vertical: Dimensions.heightSize,horizontal: Dimensions.widthSize
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius),
                      color: appCtrl.appTheme.primary,
                    ),
                    child: Column(
                      crossAxisAlignment: crossStart,
                      mainAxisAlignment: mainCenter,
                      children: [
                        Text('Balance',style: AppCss.mulishSemiBold15.textColor(appCtrl.appTheme.white),),
                        Row(
                          children: [
                            Expanded(
                                child: Text("\u20b9 ${walletCtrl.totalAmount}",style: AppCss.mulishBold16.textColor(appCtrl.appTheme.white),)),
                            PrimaryButtonWidget(
                              onPressed: (){
                                if(double.parse(walletCtrl.totalAmount) > 0){
                                  walletCtrl.payWallet();
                                }
                              },
                              text: 'Pay Now',
                              smallButton: true,
                              width: 110,
                              textColor: appCtrl.appTheme.primary,
                              backgroundColor: appCtrl.appTheme.white,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  addVerticalSpace(Dimensions.heightSize),
                  Text(
                    "All Transaction",
                    style: AppCss.mulishBold16.textColor(appCtrl.appTheme.primary),
                  ),
                  addVerticalSpace(Dimensions.heightSize*0.5),
                  for(int i=0 ; i<walletCtrl.walletList.length ; i++)
                    _transactionItem(walletCtrl.walletList[i]),
                ],
              ) : EmptyLayout(
                image: assets.orderFailurePng,
                title: 'Sorry! Data not found!!',
                subtitle: 'Something went wrong! Please try again later',
                btnText: 'Try Again',
                onBtnTap: () => walletCtrl.getWalletHistory()
                ,),
              // bottomNavigationBar: PrimaryButtonWidget(
              //     onPressed:() => orderCtrl.placeOrderMethod(),
              //     text: 'Proceed to checkout'
              // ).marginSymmetric(horizontal: Dimensions.widthSize,vertical: Dimensions.heightSize),
            );
          },
        )
    );
  }

  Widget _transactionItem(Transaction transaction) {
    return IntrinsicHeight(
      child: Container(
        margin: EdgeInsets.only(bottom: Dimensions.heightSize*0.5),
        padding: EdgeInsets.symmetric(vertical: Dimensions.heightSize,horizontal: Dimensions.widthSize),
        decoration: BoxDecoration(
          color: appCtrl.appTheme.cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radius),
          border: Border.all(color: appCtrl.appTheme.primaryYellow)
        ),
        child: Column(
          crossAxisAlignment: crossStart,
          mainAxisAlignment: mainCenter,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text("# ${transaction.walletTxnId}",
                    style: AppCss.mulishMedium15.textColor(appCtrl.appTheme.secondaryText),),
                ),
                Text(
                  transaction.type!.toLowerCase() == "debit" ? '+ \u20b9${transaction.amount}' :'- \u20b9${transaction.amount}',
                  style: AppCss.mulishSemiBold14.textColor(appCtrl.appTheme.primary),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
