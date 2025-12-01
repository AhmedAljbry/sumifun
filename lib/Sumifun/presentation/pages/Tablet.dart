import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sumfiun/Core/LocaleProvider.dart';

import 'package:sumfiun/Core/util/App_Color.dart';
import 'package:sumfiun/Core/util/App_Image.dart';
import 'package:sumfiun/Core/util/App_Stayles.dart';
import 'package:sumfiun/Core/util/App_String.dart';
import 'package:sumfiun/Sumifun/presentation/pages/Home2.dart';



import 'package:sumfiun/Sumifun/presentation/pages/RechargeScreen1.dart';
import 'package:sumfiun/Sumifun/presentation/pages/TabletRo.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/AppBar/LanguageIconButton.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/CustomFooter.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Details/Details.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Drawer/CustomDrawer.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Slider_Image/Animated_Images_Row.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Slider_Image/Check.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Slider_Image/Home_Image_Widget.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Slider_Image/Slider_Image.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Slider_Image/Slider_Image_Text.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/VerificationCard/Verification_Card.dart';

class Tablet extends StatelessWidget {
  Tablet({super.key});

  static final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  final List<Widget> pages =  [
    RechargeScreen1(),
    RechargeScreen1(),
    RechargeScreen1(),
    RechargeScreen1(),
    RechargeScreen1(),
  ];

  @override
  Widget build(BuildContext context) {
    // اتجاه الواجهة حسب اللغة الحالية
    final textDir = context.watch<LocaleProvider>().textDirection;

    // 🧩 النصوص المترجمة
    final detailsTitle      = AppStrings.t<String>(context, 'details_titles');
    final detailsBody       = AppStrings.t<String>(context, 'details_body');
    final productDesc       = AppStrings.t<String>(context, 'productDescription');
    final sliderTitles      = AppStrings.t<List<String>>(context, 'list_slider_title');
    final sliderDetails     = AppStrings.t<List<String>>(context, 'list_slider_details');
    final certTitle         = AppStrings.t<String>(context, 'certifcate_details_titles');
    final certBody          = AppStrings.t<String>(context, 'certifcate_details_body');

    return Directionality(
      textDirection: textDir,
      child: Scaffold(
        key: Tablet.scaffoldkey,
        appBar: AppBar(
          title: Center(
            child: Image(
              image: AssetImage(AppImage.Icon_Image),
              fit: BoxFit.scaleDown,
              height: 100,
            ),
          ),
          leading: IconButton(
            onPressed: () => scaffoldkey.currentState!.openDrawer(),
            icon: const Icon(Icons.menu, color: AppColor.primary),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) =>  RechargeScreen1()),
                );
              },
              icon: const Icon(Icons.verified_outlined, color: AppColor.primary),
            ),
            const SizedBox(width: 8),
            // (اختياري) زر تغيير اللغة السريع
            const LanguageIconButton(),
            const SizedBox(width: 8),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(2),
            child: Container(color: AppColor.primary, height: 2),
          ),
        ),
        drawer: const CustomDrawer(),

        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: HomeImageWidget()),

                SliverToBoxAdapter(
                  child: DetailsTablet(
                    title: detailsTitle,
                    details: detailsBody,
                    image: AppImage.detaiils_image,
                    onpressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Home2(),
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
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Center(
                            child: Text(
                              productDesc,
                              style: AppStyles.styleRegular16(context),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
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
                      title: sliderTitles,   // ✅ عناوين مترجمة
                      dic:   sliderDetails,  // ✅ تفاصيل مترجمة
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 30)),
                 SliverToBoxAdapter(child: AnimatedImagesRowTablet()),
                const SliverToBoxAdapter(child: SizedBox(height: 30)),

                SliverToBoxAdapter(
                  child: DetailsTablet(
                    title: certTitle,
                    details: certBody,
                    image: AppImage.certifcate_image,
                    onpressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Home2(),
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
