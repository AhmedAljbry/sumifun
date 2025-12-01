import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:photo_view/photo_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/CustomLayout1/text.dart';
import 'package:sumfiun/Core/util/App_String.dart';

/// Carousel + نصوص خطوة بخطوة (RTL) لشرح طريقة الاستخدام
class SumifunUsageCarousel extends StatefulWidget {
  const SumifunUsageCarousel({super.key});

  @override
  State<SumifunUsageCarousel> createState() => _SumifunUsageCarouselState();
}

class _SumifunUsageCarouselState extends State<SumifunUsageCarousel> {
  // ✅ الكنترولر الصحيح من الحزمة مع بادئة آمنة
  final CarouselSliderController carouselController = CarouselSliderController();

  int _currentIndex = 0;

  // تأكد من إضافة هذه الأصول إلى pubspec.yaml تحت flutter -> assets
  final List<String> _images = const [
    "assets/images/1.png",
    "assets/images/2.png",
    "assets/images/3.png",
    "assets/images/4.png",
    "assets/images/5.png",
  ];

  // 🔽 سنجلب العناوين والأوصاف من AppStrings داخل build مع fallback
  static const List<String> _fallbackTitles = [
    "1- فتح العبوة",
    "2- وضع كمية مناسبة",
    "3- التدليك بلطف",
    "4- الامتصاص والشعور بالراحة",
    "5- استرخِ واستمتع بالراحة",
  ];

  static const List<String> _fallbackDescriptions = [
    "قم بفتح غطاء الأنبوب وإزالة السدادة الصغيرة من الفوهة قبل الاستخدام لأول مرة.",
    "ضع كمية صغيرة من مرهم Sumifun Meniscus Pain Relief مباشرة على المنطقة المصابة، مثل الركبة أو المفصل المؤلم.",
    "قم بتدليك المرهم بحركات دائرية خفيفة حتى يمتصّه الجلد تمامًا، مما يساعد على تنشيط الدورة الدموية وتخفيف الألم.",
    "اترك المرهم حتى يمتصه الجلد تمامًا، لتشعر بالدفء والراحة الفورية في المفصل المصاب.",
    "بعد امتصاص المرهم بالكامل، استرخِ ودع تركيبته العشبية الفعّالة تعمل بعمق لتخفيف الألم واستعادة الراحة الطبيعية للمفصل.",
  ];

  double _responsiveTextSize(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w < 400) return 14;
    if (w < 600) return 16;
    return 18;
  }

  void _openFullScreenImage(BuildContext context, String pathOrUrl) {
    final ImageProvider provider =
    pathOrUrl.startsWith('http') ? NetworkImage(pathOrUrl) : AssetImage(pathOrUrl) as ImageProvider;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text("صورة كاملة")),
          body: Center(
            child: PhotoView(
              imageProvider: provider,
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageWidget(String pathOrUrl, {double? height}) {
    final isNetwork = pathOrUrl.startsWith('http');
    final image = isNetwork
        ? Image.network(
      pathOrUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: height,
      errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image_outlined)),
      loadingBuilder: (ctx, child, progress) =>
      progress == null ? child : const Center(child: CircularProgressIndicator(strokeWidth: 2.2)),
    )
        : Image.asset(
      pathOrUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: height,
      errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image_outlined)),
    );

    return GestureDetector(
      onTap: () => _openFullScreenImage(context, pathOrUrl),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: image,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLarge = MediaQuery.of(context).size.width > 600;
    final textSize = _responsiveTextSize(context);

    // ✅ قوائم مترجمة (إن توفّرت) وإلا نستخدم الـ fallback
    final List<String> titles =
    AppStrings.tl(context, 'usage_steps_titles', fallback: _fallbackTitles);
    final List<String> descriptions =
    AppStrings.tl(context, 'usage_steps_desc', fallback: _fallbackDescriptions);

    // حماية من عدم تطابق الأطوال
    final count = [
      _images.length,
      titles.length,
      descriptions.length,
    ].reduce((a, b) => a < b ? a : b);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isLarge)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: cs.CarouselSlider.builder(
                    carouselController: carouselController,
                    itemCount: count,
                    itemBuilder: (context, index, realIdx) =>
                        _imageWidget(_images[index], height: 300),
                    options: cs.CarouselOptions(
                      height: 320,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.28,
                      onPageChanged: (index, reason) {
                        setState(() => _currentIndex = index);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      defaultLargText(
                        txt: titles[_currentIndex],
                        color: Colors.black,
                        size: textSize,
                      ),
                      const SizedBox(height: 10),
                      defaultSmailText(
                        txt: descriptions[_currentIndex],
                        color: Colors.black,
                        size: textSize - 2,
                      ),
                      const SizedBox(height: 16),
                      // مؤشر متزامن مع الكاروسيل
                      Center(
                        child: AnimatedSmoothIndicator(
                          activeIndex: _currentIndex,
                          count: count,
                          effect: const ExpandingDotsEffect(
                            dotHeight: 8,
                            dotWidth: 8,
                            spacing: 6,
                            expansionFactor: 3,
                            activeDotColor: Colors.indigo,
                            dotColor: Colors.grey,
                          ),
                          onDotClicked: (i) {
                            carouselController.animateToPage(i);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                cs.CarouselSlider.builder(
                  carouselController: carouselController,
                  itemCount: count,
                  itemBuilder: (context, index, realIdx) =>
                      _imageWidget(_images[index], height: 200),
                  options: cs.CarouselOptions(
                    height: 220,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.9,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.28,
                    onPageChanged: (index, reason) {
                      setState(() => _currentIndex = index);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      defaultLargText(
                        txt: titles[_currentIndex],
                        color: Colors.black,
                        size: textSize,
                      ),
                      const SizedBox(height: 8),
                      defaultSmailText(
                        txt: descriptions[_currentIndex],
                        color: Colors.black,
                        size: textSize - 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedSmoothIndicator(
                  activeIndex: _currentIndex,
                  count: count,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 6,
                    expansionFactor: 3,
                    activeDotColor: Colors.indigo,
                    dotColor: Colors.grey,
                  ),
                  onDotClicked: (i) {
                    carouselController.animateToPage(i);
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
