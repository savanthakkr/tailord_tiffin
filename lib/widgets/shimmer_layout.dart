import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/config.dart';
import '../widgets/placeholders.dart';

class CommonShimmerLayout extends StatelessWidget {
  final bool hasBanner;
  // final Color baseColor,highLightColor;
  const CommonShimmerLayout({
    super.key,
    this.hasBanner = true,
    // required this.baseColor,
    // required this.highLightColor
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: appCtrl.appTheme.shimmerBase,
        highlightColor: appCtrl.appTheme.shimmerHighlight,
        enabled: true,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              if(hasBanner) const BannerPlaceholder(),
              const TitlePlaceholder(width: double.infinity),
              const SizedBox(height: 16.0),
              const ContentPlaceholder(
                lineType: ContentLineType.threeLines,
              ),
              const SizedBox(height: 16.0),
              const TitlePlaceholder(width: 200.0),
              const SizedBox(height: 16.0),
              const ContentPlaceholder(
                lineType: ContentLineType.twoLines,
              ),
              const SizedBox(height: 16.0),
              const TitlePlaceholder(width: 200.0),
              const SizedBox(height: 16.0),
              const ContentPlaceholder(
                lineType: ContentLineType.twoLines,
              ),
            ],
          ),
        )
    );
  }
}