import 'package:flutter/material.dart';
import 'package:tailoredtiffin/screens/bottom/widget/support_body.dart';
import 'package:tailoredtiffin/screens/bottom/widget/support_header.dart';
import 'package:tailoredtiffin/utils/config.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [appCtrl.appTheme.deliveryBg, appCtrl.appTheme.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              addVerticalSpace(Dimensions.heightSize*2),
              const SupportHeader(),
              addVerticalSpace(Dimensions.heightSize*0.5),
              const Expanded(
                child: SupportBody(),
              )
            ],
          ),
        )
      ],
    );
  }
}
