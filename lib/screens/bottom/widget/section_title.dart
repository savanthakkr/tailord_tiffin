import 'package:flutter/material.dart';
import 'package:tailoredtiffin/utils/config.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: AppCss.mulishExtraBold20.textColor(appCtrl.appTheme.textColor));
  }
}