
import 'package:flutter/material.dart';
import 'package:tailoredtiffin/screens/bottom/widget/section_title.dart';
import 'package:tailoredtiffin/utils/config.dart';
import 'package:url_launcher/url_launcher.dart';

import 'contact_tile.dart';
import 'faq_tile.dart';

class SupportBody extends StatelessWidget {
  const SupportBody({super.key});


  Future<void> openWhatsApp(String phone) async {
    final Uri url = Uri.parse("https://wa.me/$phone");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> makePhoneCall(String phone) async {
    final Uri url = Uri.parse("tel:$phone");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> sendEmail(String email) async {
    final Uri url = Uri.parse("mailto:$email");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.widthSize*2),
      children: [
        addVerticalSpace(Dimensions.heightSize*0.5),
        const SectionTitle("Contact Support"),
        addVerticalSpace(Dimensions.heightSize),
        ContactTile(
          icon: Icons.chat_bubble_outline,
          bgColor: appCtrl.appTheme.paymentBg,
          iconColor: appCtrl.appTheme.paymentIcon,
          title: "Live Chat",
          subtitle: "Chat with our support team",
          actionText: "Start conversation",
        ),
        ContactTile(
          icon: Icons.perm_phone_msg_outlined,
          bgColor: appCtrl.appTheme.deliveryBg,
          iconColor: appCtrl.appTheme.deliveryIcon,
          title: "WhatsApp",
          subtitle: "Chat with us on WhatsApp",
          actionText: "+917069464691",
          onTap: () {
            openWhatsApp("917069464691");
          },
        ),
        ContactTile(
          icon: Icons.call_outlined,
          bgColor: appCtrl.appTheme.deliveryBg,
          iconColor: appCtrl.appTheme.deliveryIcon,
          title: "Call Us",
          subtitle: "Speak directly with our support team",
          actionText: "+917069464691",
          onTap: () {
            makePhoneCall("917069464691");
          },
        ),
        ContactTile(
          icon: Icons.email_outlined,
          bgColor: appCtrl.appTheme.logoutBg,
          iconColor: appCtrl.appTheme.logoutColor,
          title: "Email Support",
          subtitle: "Send us your queries via email",
          actionText: "info@tailoredtiffin.com",
          onTap: () {
            sendEmail("info@tailoredtiffin.com");
          },
        ),
        addVerticalSpace(Dimensions.heightSize*0.8),
        const SectionTitle("Quick Help"),
        addVerticalSpace(Dimensions.heightSize*0.5),

        FaqTile(
          title: "How to place an order?",
          subtitle: "Navigate to the Food tab, select your meals, and add them to cart.",
          image: assets.mobileOrder,
        ),

        FaqTile(
          title: "What are the delivery timings?",
          subtitle: "Lunch: 12:00–2:00 PM, Dinner: 7:00–9:00 PM",
          image: assets.deliveryTime,
        ),

        FaqTile(
          title: "What payment methods do you accept?",
          subtitle: "We accept cards, UPI and cash on delivery.",
          image: assets.paymentCard,
        ),
      ],
    );
  }
}