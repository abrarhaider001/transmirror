import 'package:flutter/material.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/utils/constants/image_strings.dart';
import 'package:transmirror/core/utils/constants/sizes.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: MyColors.primary,
        borderRadius: BorderRadius.circular(MySizes.borderRadius),
        image: const DecorationImage(
          image: AssetImage(MyImages.homeBannerBackgroundImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('One App. Every Service.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: MyColors.white)),
          SizedBox(height: 8),
          Text('Body From cleaning to repairs — book trusted professionals in minutes.', style: TextStyle(fontSize: 13, color: MyColors.lightGrey, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
