import 'package:flutter/material.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/CustomLayout1/text.dart';

/// الغلاف: يقرر نسخة الهاتف أو الديسكتوب حسب العرض (700 كسر)
class HomeDic extends StatelessWidget {
  final String namedic;
  final String titledic;
  final String image;
  final Color? color;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const HomeDic({
    super.key,
    required this.namedic,
    required this.image,
    required this.titledic,
    this.color,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  static const double _breakpoint = 700;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktopOrTablet = width > _breakpoint;

    if (isDesktopOrTablet) {
      return HomeDicDesktop(
        namedic: namedic,
        titledic: titledic,
        image: image,
        color: color,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
      );
    }
    return HomeDicPhone(
      namedic: namedic,
      titledic: titledic,
      image: image,
      color: color,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
    );
  }
}

/// ======================
/// نسخة الهاتف (تم إصلاح الارتفاع!)
/// ======================
class HomeDicPhone extends StatelessWidget {
  final String namedic;
  final String titledic;
  final String image;
  final Color? color;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const HomeDicPhone({
    super.key,
    required this.namedic,
    required this.titledic,
    required this.image,
    this.color,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height; // نستخدمه لتحديد ارتفاع الوعاء
    final Color brand = color ?? const Color(0xFF0EA5E9);
    final borderRadius = BorderRadius.circular(24);

    final content = _ContentCard(
      titledic: titledic,
      namedic: namedic,
      brand: brand,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
    );

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        margin: const EdgeInsets.all(16),
        // 🔴 المهم: نعطي ارتفاعًا نهائيًا للـ Stack حتى داخل SliverToBoxAdapter
        child: SizedBox(
          height: h * .55, // غيّر النسبة لو حبّيت
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Stack(
              children: [
                // خلفية: صورة + تدرّج رأسي خفيف
                Positioned.fill(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _ImageWithOverlay(imageUrl: image),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(.20),
                              Colors.black.withOpacity(.05),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // إطار ناعم
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black.withOpacity(.06)),
                        borderRadius: borderRadius,
                      ),
                    ),
                  ),
                ),
                // المحتوى (بطاقة شفافة) — نثبّتها بأسفل الوعاء
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.95),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.white.withOpacity(.9)),
                        ),
                        child: content,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ======================
/// نسخة الديسكتوب/التابلت (كما كانت)
/// ======================
class HomeDicDesktop extends StatelessWidget {
  final String namedic;
  final String titledic;
  final String image;
  final Color? color;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const HomeDicDesktop({
    super.key,
    required this.namedic,
    required this.titledic,
    required this.image,
    this.color,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final Color brand = color ?? const Color(0xFF0EA5E9);
    final borderRadius = BorderRadius.circular(24);

    final content = _ContentCard(
      titledic: titledic,
      namedic: namedic,
      brand: brand,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
    );

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        height: height * .60,
        margin: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            children: [
              // الخلفية: نصف صورة + نصف تدرّج براند
              Positioned.fill(
                child: Row(
                  children: [
                    Expanded(flex: 1, child: _ImageWithOverlay(imageUrl: image)),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              brand.withOpacity(.10),
                              brand.withOpacity(.06),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // إطار ناعم
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(.06)),
                      borderRadius: borderRadius,
                    ),
                  ),
                ),
              ),
              // المحتوى: بطاقة بيضاء شفافة على جهة النص
              Positioned.fill(
                child: Row(
                  children: [
                    const Spacer(),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.92),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.06),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          border: Border.all(color: Colors.white.withOpacity(.8)),
                        ),
                        child: content,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ======================
/// العناصر المشتركة
/// ======================
class _ContentCard extends StatelessWidget {
  final String titledic;
  final String namedic;
  final Color brand;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const _ContentCard({
    required this.titledic,
    required this.namedic,
    required this.brand,
    required this.mainAxisAlignment,
    required this.crossAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktopOrTablet = width > 700;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          defaultLargText(
            txt: titledic,
            size: isDesktopOrTablet ? 32 : 24,
            color: Colors.black,
          ),
          const SizedBox(height: 10),
          defaultSmailText(
            txt: namedic,
            color: Colors.black,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {/* TODO */},
                icon: const Icon(Icons.verified_rounded),
                label: const Text('اطلبي الآن'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: brand,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                  textStyle: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () {/* TODO */},
                child: const Text('اعرفي سياسة الضمان'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImageWithOverlay extends StatelessWidget {
  final String imageUrl;
  const _ImageWithOverlay({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    ImageProvider provider;
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      provider = NetworkImage(imageUrl);
    } else {
      provider = AssetImage(imageUrl);
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Image(
          image: provider,
          fit: BoxFit.cover,
          loadingBuilder: (ctx, child, progress) {
            if (progress == null) return child;
            return Container(
              alignment: Alignment.center,
              color: const Color(0xFFF3F6F9),
              child: const CircularProgressIndicator(strokeWidth: 2.4),
            );
          },
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xFFF3F6F9),
            alignment: Alignment.center,
            child: const Icon(Icons.image_not_supported_outlined, size: 42),
          ),
        ),
        // تدرّج خفيف لدمج أجمل مع النص
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(.18),
                  Colors.transparent,
                ],
                begin: AlignmentDirectional.centerStart,
                end: AlignmentDirectional.centerEnd,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
