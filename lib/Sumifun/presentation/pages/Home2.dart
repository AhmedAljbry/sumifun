import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jovial_svg/jovial_svg.dart';

import 'package:sumfiun/Core/util/App_Image.dart';
import 'package:sumfiun/Core/util/App_String.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/ComparisonTable.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/CustomFooter.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/CustomLayout1/CustomContent.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/CustomLayout1/CustomLayout.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/CustomLayout1/CustomLayout1.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/CustomLayout1/HomeDic.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/CustomLayout1/SS.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/CustomLayout1/ss1.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/CustomText.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/FAQList.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Slider_Image/Check.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Slider_Image/Slider_Image.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Slider_Image/Slider_Image_Text.dart';

class Home2 extends StatefulWidget {
  const Home2({super.key});

  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> {

  @override
  Widget build(BuildContext context) {
    final sliderTitles  = AppStrings.tl(context, 'list_slider_title',   fallback: const []);
    final sliderDetails = AppStrings.tl(context, 'list_slider_details', fallback: const []);
    final bool isLarge = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 5),
                const SliderImage(imgList: AppImage.list_slider),
                const SizedBox(height: 30),

                // قسم المحتوى الرئيسي
                const SumifunJointOilSection(),
                const SizedBox(height: 30),

                // قائمة أفقية (مميّزات/خدمات)
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: SliderImageText(
                    imagelist: AppImage.list_slider,
                    title: sliderTitles,    // ✅ قوائم مترجمة وآمنة
                    dic: sliderDetails,     // ✅ قوائم مترجمة وآمنة
                  ),
                ),
                const SizedBox(height: 20),

                // قسم الضمان الذهبي
                HomeDic(
                  image: AppImage.detaiils_image,
                  titledic: AppStrings.t<String>(context, 'sumifun_guarantee_title'),
                  namedic: AppStrings.t<String>(context, 'sumifun_guarantee_text'),
                  color: const Color(0xFF0EA5E9), // لون البراند
                ),
                const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  // 🔽 يجلب النص المترجم تلقائيًا من AppStrings
                  AppStrings.ts(context, 'easy_use_title', fallback: 'سهل في الاستعمال'),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: isLarge ? 32 : 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
                const SizedBox(height: 20),

                // خطوات الاستخدام
                const SumifunUsageCarousel(),
                const SizedBox(height: 20),

                // تخطيطات مخصّصة
                const CustomLayout(),
                const SizedBox(height: 20),
                const CustomLayout1(),
                const SizedBox(height: 20),

                // جدول المقارنة
                ComparisonTable(),
                const SizedBox(height: 20),

                // نص مخصص/ختامي
                const Center(child: CustomText()),
                const SizedBox(height: 20),

                // الأسئلة الشائعة
                 FAQList(),
                const SizedBox(height: 20),

                // قسم التحقق
                const Check(),
                const SizedBox(height: 20),

                // الفوتر
                const CustomFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
