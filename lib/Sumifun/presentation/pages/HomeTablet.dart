import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sumfiun/Core/LocaleProvider.dart';

import 'package:sumfiun/Core/util/App_Image.dart';
import 'package:sumfiun/Core/util/App_String.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/CustomLayout1/CustomContent.dart';

import 'package:sumfiun/Sumifun/presentation/widgets/Slider_Image/Slider_Image.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Slider_Image/Slider_Image_Text.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/CustomLayout1/CustomLayout.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/CustomLayout1/CustomLayout1.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/CustomLayout1/HomeDic.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Details/Details.dart'; // لو تحتاجه لاحقًا
import 'package:sumfiun/Sumifun/presentation/widgets/Slider_Image/Animated_Images_Row.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Slider_Image/Check.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/VerificationCard/Verification_Card.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/ComparisonTable.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/FAQList.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/CustomText.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/CustomFooter.dart';

import '../widgets/CustomLayout1/ss1.dart';

class Hometabletr extends StatelessWidget {
  Hometabletr({super.key});

  static final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final textDir   = context.watch<LocaleProvider>().textDirection;
    final isLarge   = MediaQuery.of(context).size.width > 600;

    // صور السلايدر
    const images = AppImage.list_slider;

    // عناوين/تفاصيل السلايدر (لو رجعت فاضية، نولّد عناصر افتراضية بطول الصور)
    final titlesRaw  = AppStrings.tl(context, 'list_slider_title',   fallback: const []);
    final detailsRaw = AppStrings.tl(context, 'list_slider_details', fallback: const []);

    List<String> titles  = titlesRaw.isNotEmpty
        ? titlesRaw
        : List.generate(images.length, (i) => 'العنصر ${i + 1}');
    List<String> details = detailsRaw.isNotEmpty
        ? detailsRaw
        : List.generate(images.length, (i) => 'وصف موجز للعنصر ${i + 1}');

    // توحيد الأطوال (حماية)
    final int minLen = [images.length, titles.length, details.length].reduce((a, b) => a < b ? a : b);
    titles  = titles.take(minLen).toList();
    details = details.take(minLen).toList();
    final imagelist = images.take(minLen).toList();

    return Directionality(
      textDirection: textDir,
      child: Scaffold(
        key: Hometabletr.scaffoldkey,
        // اختياري: AppBar/Drawer هنا
        // drawer: const CustomDrawer(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: SliderImage(imgList: AppImage.list_slider)),
                const SliverToBoxAdapter(child: SizedBox(height: 30)),

                const SliverToBoxAdapter(child: SumifunJointOilSection()),
                const SliverToBoxAdapter(child: SizedBox(height: 30)),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: SliderImageText(
                      imagelist: imagelist,
                      title: titles,
                      dic: details,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                SliverToBoxAdapter(
                  child: HomeDic(
                    image: AppImage.detaiils_image,
                    titledic: AppStrings.t<String>(context, 'sumifun_guarantee_title'),
                    namedic: AppStrings.t<String>(context, 'sumifun_guarantee_text'),
                    color: const Color(0xFF0EA5E9),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      AppStrings.ts(context, 'easy_use_title', fallback: 'سهل في الاستعمال'),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: isLarge ? 32 : 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                const SliverToBoxAdapter(child: SumifunUsageCarousel()),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                const SliverToBoxAdapter(child: CustomLayout()),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                const SliverToBoxAdapter(child: CustomLayout1()),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                const SliverToBoxAdapter(child: ComparisonTable()),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                const SliverToBoxAdapter(child: Center(child: CustomText())),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                const SliverToBoxAdapter(child: FAQList()),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                const SliverToBoxAdapter(child: Check()),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                const SliverToBoxAdapter(child: CustomFooter()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
