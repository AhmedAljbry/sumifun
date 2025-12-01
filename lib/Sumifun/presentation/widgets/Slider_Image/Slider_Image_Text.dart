import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// الغلاف: يقرر نسخة الهاتف أو الديسكتوب حسب العرض
class SliderImageText extends StatelessWidget {
  const SliderImageText({
    super.key,
    required this.imagelist,
    required this.title,
    required this.dic,
  });

  final List<String> imagelist;
  final List<String> title;
  final List<String> dic;

  static const double _breakpoint = 600; // نفس منطقك: >600 يعتبر شاشة كبيرة

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w > _breakpoint) {
      return SliderImageTextDesktop(imagelist: imagelist, title: title, dic: dic);
    }
    return SliderImageTextPhone(imagelist: imagelist, title: title, dic: dic);
  }
}

/// ======================
/// نسخة الهاتف (عمودي)
/// ======================
class SliderImageTextPhone extends StatefulWidget {
  const SliderImageTextPhone({
    super.key,
    required this.imagelist,
    required this.title,
    required this.dic,
  });

  final List<String> imagelist;
  final List<String> title;
  final List<String> dic;

  @override
  State<SliderImageTextPhone> createState() => _SliderImageTextPhoneState();
}

class _SliderImageTextPhoneState extends State<SliderImageTextPhone> {
  int _currentIndex = 0;

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
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 400) return 14;
    if (screenWidth < 600) return 16;
    return 18;
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
        fontSize: fontSize ?? 18,
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
        fontSize: fontSize ?? 14,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.imagelist.isNotEmpty);
    assert(widget.title.length == widget.imagelist.length &&
        widget.dic.length == widget.imagelist.length,
    'title/dic length must match imagelist length');

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // الكاروسيل (هاتف)
          CarouselSlider(
            items: widget.imagelist.map((item) {
              return GestureDetector(
                onTap: () => _openFullScreenImage(context, item),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item,
                    fit: BoxFit.scaleDown,
                    width: double.infinity,
                    height: 200, // ارتفاع أقل للهواتف
                  ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
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
              enlargeFactor: 0.3,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),

          const SizedBox(height: 10),

          // العنوان والوصف (هاتف)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                defaultLargText(
                  txt: widget.title[_currentIndex],
                  color: Colors.black,
                  fontSize: getResponsiveTextSize(context),
                ),
                const SizedBox(height: 8),
                defaultSmailText(
                  txt: widget.dic[_currentIndex],
                  color: Colors.black,
                  fontSize: getResponsiveTextSize(context) - 2,
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // مؤشر الصفحات (يعتمد على _currentIndex)
          AnimatedSmoothIndicator(
            activeIndex: _currentIndex,
            count: widget.imagelist.length,
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
    );
  }
}

/// ======================
/// نسخة الديسكتوب/التابلت (أفقي)
/// ======================
class SliderImageTextDesktop extends StatefulWidget {
  const SliderImageTextDesktop({
    super.key,
    required this.imagelist,
    required this.title,
    required this.dic,
  });

  final List<String> imagelist;
  final List<String> title;
  final List<String> dic;

  @override
  State<SliderImageTextDesktop> createState() => _SliderImageTextDesktopState();
}

class _SliderImageTextDesktopState extends State<SliderImageTextDesktop> {
  int _currentIndex = 0;

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
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 400) return 14;
    if (screenWidth < 600) return 16;
    return 18;
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
        fontSize: fontSize ?? 18,
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
        fontSize: fontSize ?? 14,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.imagelist.isNotEmpty);
    assert(widget.title.length == widget.imagelist.length &&
        widget.dic.length == widget.imagelist.length,
    'title/dic length must match imagelist length');

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الكاروسيل (يسار)
          Expanded(
            flex: 2,
            child: CarouselSlider(
              items: widget.imagelist.map((item) {
                return GestureDetector(
                  onTap: () => _openFullScreenImage(context, item),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item,
                      fit: BoxFit.scaleDown,
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

          // النصوص (يمين)
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                defaultLargText(
                  txt: widget.title[_currentIndex],
                  color: Colors.black,
                  fontSize: getResponsiveTextSize(context),
                ),
                const SizedBox(height: 10),
                defaultSmailText(
                  txt: widget.dic[_currentIndex],
                  color: Colors.black,
                  fontSize: getResponsiveTextSize(context) - 2,
                ),

                const SizedBox(height: 16),

                // مؤشر الصفحات
                AnimatedSmoothIndicator(
                  activeIndex: _currentIndex,
                  count: widget.imagelist.length,
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
          ),
        ],
      ),
    );
  }
}
