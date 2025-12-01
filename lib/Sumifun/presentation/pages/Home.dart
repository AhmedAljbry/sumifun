import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sumfiun/Core/AdaptiveLayout.dart';
import 'package:sumfiun/Core/LocaleProvider.dart';

import 'package:sumfiun/Core/util/App_Image.dart';
import 'package:sumfiun/Core/util/App_Stayles.dart';
import 'package:sumfiun/Core/util/App_String.dart';
import 'package:sumfiun/Sumifun/presentation/pages/Home2.dart';
import 'package:sumfiun/Sumifun/presentation/pages/HomeTablet.dart';


import 'package:sumfiun/Sumifun/presentation/pages/UnderDevelopmentScreen.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/AppBar/AppBar_Desktop.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/CustomFooter.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Details/Details.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Details/Details1.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Slider_Image/Animated_Images_Row.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Slider_Image/Check.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Slider_Image/Home_Image_Widget.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Slider_Image/Slider_Image.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Slider_Image/Slider_Image_Text.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/VerificationCard/Verification_Card.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // اتجاه الواجهة حسب اللغة الحالية
    final textDir = context.watch<LocaleProvider>().textDirection;

    // 🧩 نصوص مترجمة (آمنة)
    final detailsTitle       = AppStrings.ts(context, 'details_titles', fallback: '');
    final detailsBody        = AppStrings.ts(context, 'details_body',   fallback: '');

    final productDescription = AppStrings.ts(context, 'productDescription', fallback: '');

    // 🧩 قوائم مترجمة (آمنة)
    final sliderTitles  = AppStrings.tl(context, 'list_slider_title',   fallback: const []);
    final sliderDetails = AppStrings.tl(context, 'list_slider_details', fallback: const []);

    final certTitle = AppStrings.ts(context, 'certifcate_details_titles', fallback: '');
    final certBody  = AppStrings.ts(context, 'certifcate_details_body',   fallback: '');

    return Directionality(
      textDirection: textDir,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                 SliverToBoxAdapter(child: AppbarDesktop()),

                const SliverToBoxAdapter(child: HomeImageWidget()),

                SliverToBoxAdapter(
                  child: Details(
                    title: detailsTitle,
                    details: detailsBody,
                    image: AppImage.detaiils_image,
                    onpressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdaptiveLayout(
                            mobileLayout: (context) =>  Hometabletr(),
                            tabletLayout: (context) =>  Hometabletr(),
                            desktopLayout: (context) =>  Home2(),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            productDescription,
                            style: AppStyles.styleSemiBold20(context),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // الصور فقط (لا تعتمد نصوص)
                        SliderImage(imgList: AppImage.list_slider_body),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 30)),
                 SliverToBoxAdapter(child: VerificationCard()),

                const SliverToBoxAdapter(child: SizedBox(height: 30)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: SliderImageText(
                      imagelist: AppImage.list_slider,
                      title: sliderTitles,    // ✅ قوائم مترجمة وآمنة
                      dic: sliderDetails,     // ✅ قوائم مترجمة وآمنة
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 30)),
                const SliverToBoxAdapter(child: Center(child: AnimatedImagesRow())),
                const SliverToBoxAdapter(child: SizedBox(height: 30)),

                SliverToBoxAdapter(
                  child: Details1(
                    title: certTitle,
                    details: certBody,
                    image: AppImage.certifcate_image,
                    onpressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdaptiveLayout(
                            mobileLayout: (context) =>  Hometabletr(),
                            tabletLayout: (context) =>  Hometabletr(),
                            desktopLayout: (context) =>  Home(),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                 SliverToBoxAdapter(child: Check()),

                const SliverToBoxAdapter(child: CustomFooter()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
