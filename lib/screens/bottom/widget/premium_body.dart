import 'package:flutter/material.dart';
import 'package:tailoredtiffin/screens/bottom/widget/section_title.dart';

import '../../../utils/dimensions.dart';
import '../../../utils/size.dart';
import 'common_info_card.dart';

class PremiumBody extends StatelessWidget {
  const PremiumBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.widthSize*2),
      children: [
        addVerticalSpace(Dimensions.heightSize*2),
        const SectionTitle("Premium Benefits"),
        addVerticalSpace(Dimensions.heightSize),
        const CommonInfoCard(
          icon: Icons.headphones_outlined,
          title: "Priority Support",
          subtitle: "Dedicated customer service with faster response times",
        ),
        const CommonInfoCard(
          icon: Icons.access_time,
          title: "On-Time Guarantee",
          subtitle: "Guaranteed delivery within promised time slots",
        ),
        const CommonInfoCard(
          icon: Icons.calendar_today_rounded,
          title: "Extended Order Window",
          subtitle: "Place orders up to 1 hour after cutoff time",
        ),
        const CommonInfoCard(
          icon: Icons.credit_card_rounded,
          title: "Flexible Billing",
          subtitle: "Set up post-payment billing cycles as per your convenience",
        ),
      ],
    );
  }
}
