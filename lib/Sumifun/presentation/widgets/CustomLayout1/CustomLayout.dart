import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sumfiun/Core/util/App_String.dart';
import 'package:sumfiun/Core/LocaleProvider.dart';

/// قسم واجهة Sumifun (نسخة آلام المفاصل والعظام بلون ذهبي أنيق)
class CustomLayout extends StatelessWidget {
  const CustomLayout({
    super.key,
    this.imagePath = 'assets/images/h1.png',
    this.brandColor = const Color(0xFFA09632), // ذهبي رئيسي
    this.brandBg = const Color(0xFFFAF7E8),    // خلفية فاتحة ناعمة
  });

  /// يمكن تمرير صورة أصول أو رابط شبكة
  final String imagePath;

  /// ألوان وهوية Sumifun (قابلة للتهيئة)
  final Color brandColor;
  final Color brandBg;

  // قيم تصميم ثابتة
  static const double _radiusLg = 20;
  static const double _radiusMd = 16;
  static const double _gap = 16;
  static const double _containerMaxWidth = 1200;
  static const double _wideBreakpoint = 800;

  @override
  Widget build(BuildContext context) {
    final textDir = context.watch<LocaleProvider>().textDirection;

    return Directionality(
      textDirection: textDir,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _containerMaxWidth),
          child: Padding(
            padding: const EdgeInsets.all(_gap),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > _wideBreakpoint;
                return isWide
                    ? _WideLayout(
                  imagePath: imagePath,
                  brandColor: brandColor,
                  brandBg: brandBg,
                )
                    : _NarrowLayout(
                  imagePath: imagePath,
                  brandColor: brandColor,
                  brandBg: brandBg,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// 🖥️ تخطيط الشاشة العريضة (تابلت / ديسكتوب)
class _WideLayout extends StatelessWidget {
  const _WideLayout({
    required this.imagePath,
    required this.brandColor,
    required this.brandBg,
  });

  final String imagePath;
  final Color brandColor;
  final Color brandBg;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _ImagePane(
            imagePath: imagePath,
            aspectRatio: 16 / 9,
            radius: CustomLayout._radiusLg,
            brandColor: brandColor,
          ),
        ),
        const SizedBox(width: CustomLayout._gap),
        Expanded(
          flex: 2,
          child: _InfoCard(
            isCompact: false,
            brandColor: brandColor,
            brandBg: brandBg,
          ),
        ),
      ],
    );
  }
}

/// 📱 تخطيط الشاشة الضيقة (موبايل)
class _NarrowLayout extends StatelessWidget {
  const _NarrowLayout({
    required this.imagePath,
    required this.brandColor,
    required this.brandBg,
  });

  final String imagePath;
  final Color brandColor;
  final Color brandBg;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ImagePane(
          imagePath: imagePath,
          aspectRatio: 4 / 3,
          radius: CustomLayout._radiusMd,
          brandColor: brandColor,
        ),
        const SizedBox(height: CustomLayout._gap),
        SizedBox(
          width: w * 0.95,
          child: _InfoCard(
            isCompact: true,
            brandColor: brandColor,
            brandBg: brandBg,
          ),
        ),
      ],
    );
  }
}

/// 🖼️ لوحة الصورة مع التدرج الذهبي والشعار
class _ImagePane extends StatelessWidget {
  const _ImagePane({
    super.key,
    required this.imagePath,
    required this.brandColor,
    this.aspectRatio = 16 / 9,
    this.radius = CustomLayout._radiusLg,
  });

  final String imagePath;
  final Color brandColor;
  final double aspectRatio;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final bool isNetwork = imagePath.startsWith('http');
    final ImageProvider provider =
    isNetwork ? NetworkImage(imagePath) : AssetImage(imagePath) as ImageProvider;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // الصورة (تدعم Network/Asset)
            Image(
              image: provider,
              fit: BoxFit.cover,
              semanticLabel: AppStrings.ts(context, 'sumifun_image_alt', fallback: 'صورة منتج Sumifun'),
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFF3F6F9),
                alignment: Alignment.center,
                child: const Icon(Icons.image_not_supported_outlined, size: 44),
              ),
              // لو أردت: يمكنك إضافة loadingBuilder لشبكة فقط
            ),

            // طبقة تدرّج خفيف
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(.25),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),

            // بادج الشعار
            PositionedDirectional(
              top: 12,
              start: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: brandColor,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.12),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Text(
                  'Sumifun',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🧴 بطاقة المعلومات (وصف المنتج + المزايا + طريقة الاستخدام)
class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.isCompact,
    required this.brandColor,
    required this.brandBg,
  });

  final bool isCompact;
  final Color brandColor;
  final Color brandBg;

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontSize: isCompact ? 22 : 26,
      fontWeight: FontWeight.w800,
      height: 1.2,
      color: const Color(0xFF3E3A1B),
    );
    final bodyStyle = TextStyle(
      fontSize: isCompact ? 14.5 : 16,
      height: 1.7,
      color: const Color(0xFF4B4B4B),
    );

    final title = AppStrings.ts(context, 'sumifun_title',
        fallback: 'Sumifun – الزيت الطبيعي لآلام المفاصل والعظام');
    final body = AppStrings.ts(context, 'sumifun_body',
        fallback:
        'تركيبة علاجية بخلاصة الأعشاب الطبيعية، سريعة الامتصاص لتخفيف آلام الركبة والظهر والرقبة، وتهدئة الالتهاب وتحسين مرونة المفاصل والحركة اليومية.');
    final bullets = AppStrings.tl(context, 'sumifun_bullets', fallback: const [
      'يخفف الالتهاب ويهدّئ الألم بسرعة.',
      'يساعد على تحسين مرونة وحركة المفاصل.',
      'مكونات طبيعية 100% وسريعة الامتصاص.',
    ]);
    final howTo = AppStrings.ts(context, 'sumifun_howto',
        fallback:
        'طريقة الاستخدام: ضع كمية مناسبة على المنطقة المصابة ودلك بلطف من 2 إلى 3 دقائق حتى الامتصاص. استخدمه مرتين يوميًا صباحًا ومساءً.');
    final guarantee = AppStrings.ts(context, 'sumifun_gold_guarantee',
        fallback: 'ضمان Sumifun الذهبي');

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: brandBg,
        borderRadius: BorderRadius.circular(CustomLayout._radiusLg),
        border: Border.all(color: const Color(0xFFE6DFA5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleStyle),
          const SizedBox(height: 8),
          Text(body, style: bodyStyle),
          const SizedBox(height: 12),

          for (final b in bullets) _Bullet(text: b, compact: isCompact, color: brandColor),

          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(CustomLayout._radiusMd),
              border: Border.all(color: const Color(0xFFE8E2B0)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 20, color: brandColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    howTo,
                    style: bodyStyle.copyWith(
                      fontSize: isCompact ? 13.5 : 14.5,
                      color: const Color(0xFF4B4B4B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              guarantee,
              style: TextStyle(
                fontSize: isCompact ? 14 : 16,
                fontWeight: FontWeight.bold,
                color: brandColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ✅ عنصر النقطة (ميزة)
class _Bullet extends StatelessWidget {
  const _Bullet({
    required this.text,
    required this.compact,
    required this.color,
  });

  final String text;
  final bool compact;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: compact ? 6 : 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_rounded, size: 20, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: compact ? 14.5 : 15.5,
                height: 1.6,
                color: const Color(0xFF3E3A1B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
