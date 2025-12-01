
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sumfiun/Core/util/App_Image.dart';

class SS extends StatefulWidget {
  const SS({super.key});

  @override
  State<SS> createState() => _SSState();
}

class _SSState extends State<SS> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  List<String> title = [
    "يحارب التقصف ويزيد شعرك نعومة وجمال",
    "يخفف من التساقط ويزيد في كثافة شعرك",
    "يطول شعرك بلا حدود"
  ];
  List<String> dic = [
    "أكثر من 50% من النساء يشتكون من تقصف الشعر وتساقطه بسبب كثرة استخدام مصفف الشعر والصبغات. الزيت الأفغاني يساعد في ترطيب الشعر بعمق وتقويته بفضل أحماض أوميغا، مما يقلل التقصف ويزيد شعرك نعومة وجمال.",
    "الزيت الافغاني غني بفيتامين E ومضادات الأكسدة اللي تدعم صحة فروة رأسك وتقوي جذوره بحيث تساعد في التقليل من تساقطه وتكثيفه.",
    "استخدمي الزيت الأفغاني بانتظام للمساعدة في تحفيز نمو شعرك وتغذيته بعمق بالفيتامينات الأساسية والمعادن اللي تعزز الدورة الدموية في فروة الرأس وتقوي البصيلات، مما يساعدك على تحقيق نمو صحي ودائم.",
  ];

  void _openFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text("صورة كاملة")),
          body: Center(
            child: PhotoView(
              imageProvider: NetworkImage(imageUrl),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
            ),
          ),
        ),
      ),
    );
  }

  double getResponsiveTextSize(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 400) {
      return 14; // حجم نص صغير للشاشات الصغيرة
    } else if (screenWidth < 600) {
      return 16; // حجم نص متوسط للشاشات المتوسطة
    } else {
      return 18; // حجم نص كبير للشاشات الكبيرة
    }
  }

  Widget defaultLargText({
    required String txt,
    required Color color,
    double? fontSize,
  }) {
    return Text(
      txt,
      style: TextStyle(
        color: color,
        fontSize: fontSize ?? 18, // حجم افتراضي
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget defaultSmailText({
    required String txt,
    required Color color,
    double? fontSize,
  }) {
    return Text(
      txt,
      style: TextStyle(
        color: color,
        fontSize: fontSize ?? 14, // حجم افتراضي
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Directionality(
      textDirection: TextDirection.rtl, // جعل النص من اليمين إلى اليسار
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isLargeScreen)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: CarouselSlider(
                    items: AppImage.list_slider.map((item) {
                      return GestureDetector(
                        onTap: () => _openFullScreenImage(context, item),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item,
                            fit: BoxFit.cover, // تغطية المساحة المتاحة
                            width: double.infinity,
                            height: 300,
                          ),
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
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
                      enlargeFactor: 0.3,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
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
                        txt: title[_currentIndex],
                        color: Colors.black,
                        fontSize: getResponsiveTextSize(context),
                      ),
                      const SizedBox(height: 10),
                      defaultSmailText(
                        txt: dic[_currentIndex],
                        color: Colors.black,
                        fontSize: getResponsiveTextSize(context) - 2,
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                CarouselSlider(
                  items: AppImage.list_slider.map((item) {
                    return GestureDetector(
                      onTap: () => _openFullScreenImage(context, item),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          item,
                          fit: BoxFit.cover, // تغطية المساحة المتاحة
                          width: double.infinity,
                          height: 200, // ارتفاع أقل للهواتف
                        ),
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 220, // ارتفاع أقل للهواتف
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.9,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
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
                        txt: title[_currentIndex],
                        color: Colors.black,
                        fontSize: getResponsiveTextSize(context),
                      ),
                      const SizedBox(height: 8),
                      defaultSmailText(
                        txt: dic[_currentIndex],
                        color: Colors.black,
                        fontSize: getResponsiveTextSize(context) - 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SmoothPageIndicator(
                  controller: _pageController,
                  count: AppImage.list_slider.length,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 6,
                    expansionFactor: 3,
                    activeDotColor: Colors.indigo,
                    dotColor: Colors.grey,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}