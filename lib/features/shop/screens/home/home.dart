import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lhstore/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:lhstore/common/widgets/custom_shapes/containers/search_container.dart';

import 'package:lhstore/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:lhstore/features/shop/screens/home/widgets/promo_slider.dart';
import 'package:lhstore/features/shop/screens/search.dart';
import 'package:lhstore/utils/constants/image_strings.dart';
import 'package:lhstore/utils/constants/sizes.dart';
import 'package:lhstore/utils/helpers/helpers_fuctions.dart';
import 'package:lhstore/features/shop/screens/home/widgets/card_carousel.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = LHHelperFunction.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            LHPrimaryHeaderContainer(
                child: Column(
              children: [
                LHHomeAppBar(),
                SizedBox(
                  height: LHSize.spaceBtwSections,
                ),
                LHSearchContainer(
                  text: 'Search in Store',
                  onTap: () {
                    Get.to(LHSearchScreen());
                  },
                ),
                SizedBox(
                  height: LHSize.spaceBtwItems,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: LHSize.defaultSpace, right: LHSize.defaultSpace),
                  child: Column(
                    children: [
                      LHPromoSlider(
                        banners: [
                          LHImages.slider1,
                          LHImages.slider2,
                          LHImages.slider3,
                          LHImages.slider4,
                          LHImages.slider5,
                          LHImages.slider6,
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
         Padding(
  padding: EdgeInsets.all(LHSize.defaultSpace),
  child: Column(
    children: [
      Container(
        height: 400, // Set a specific height for the CardCarousel
        child: CardCarousel(),
      ),
    ],
  ),
),

          ],
        ),
      ),
    );
  }
}
