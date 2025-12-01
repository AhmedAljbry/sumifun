import 'package:flutter/material.dart';
import 'package:sumfiun/Core/util/App_String.dart';

class CustomLayout1 extends StatelessWidget {
  const CustomLayout1({super.key});

  // الهوية البصرية
  static const Color kBrand     = Color(0xFF0EA5E9);   // أزرق Sumifun (اختياري)
  static const Color kGold      = Color(0xFFA09632);   // الذهبي المستخدم لديك
  static const Color kCardBg    = Colors.white;
  static const Color kBorder    = Color(0xFFE6EEF3);
  static const double kRadiusLg = 20;
  static const double kRadiusMd = 14;
  static const double kGap      = 16;
  static const double kMaxW     = 1200;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: kMaxW),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 800;
            return Padding(
              padding: const EdgeInsets.all(kGap),
              child: isWide ? const _WideLayout() : const _NarrowLayout(),
            );
          },
        ),
      ),
    );
  }
}

/// تخطيط الشاشة العريضة (تابلت/ديسكتوب)
class _WideLayout extends StatelessWidget {
  const _WideLayout();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return SizedBox(
      height: h * 0.5, // ارتفاع متوازن
      child: const Row(
        children: [
          Expanded(flex: 2, child: _ImagePane()),
          SizedBox(width: CustomLayout1.kGap),
          Expanded(flex: 2, child: _InfoCard(isCompact: false)),
        ],
      ),
    );
  }
}

/// تخطيط الشاشة الضيقة (موبايل)
class _NarrowLayout extends StatelessWidget {
  const _NarrowLayout();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _ImagePane(aspectRatio: 4 / 3, radius: CustomLayout1.kRadiusMd),
        SizedBox(height: CustomLayout1.kGap),
        _InfoCard(isCompact: true),
      ],
    );
  }
}

/// لوحة الصورة مع تدرّج وبادج
class _ImagePane extends StatelessWidget {
  final double aspectRatio;
  final double radius;

  const _ImagePane({
    super.key,
    this.aspectRatio = 16 / 9,
    this.radius = CustomLayout1.kRadiusLg,
  });

  /// غيّر المسار أو اجعله رابطًا شبكيًا إن شئت
  static const String _imgPath = 'assets/images/h2.png';

  @override
  Widget build(BuildContext context) {
    final badge = AppStrings.ts(context, 'authorized_badge', fallback: 'Authorized');

    // دعم Asset/Network تلقائيًا
    final bool isNetwork = _imgPath.startsWith('http');
    final ImageProvider provider =
    isNetwork ? NetworkImage(_imgPath) : AssetImage(_imgPath) as ImageProvider;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image(
              image: provider,
              fit: BoxFit.cover,
              semanticLabel: AppStrings.ts(context, 'authorized_image_alt', fallback: 'صورة واجهة Sumifun'),
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFF3F6F9),
                alignment: Alignment.center,
                child: const Icon(Icons.image_not_supported_outlined, size: 44),
              ),
            ),
            // تدرّج لتعزيز القراءة
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(.28),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            // بادج "مصرّح"
            PositionedDirectional(
              top: 12,
              start: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: CustomLayout1.kGold.withOpacity(.95),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.14),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_rounded, color: Colors.white, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      badge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// بطاقة المعلومات
class _InfoCard extends StatelessWidget {
  final bool isCompact;
  const _InfoCard({required this.isCompact});

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontSize: isCompact ? 22 : 26,
      fontWeight: FontWeight.w800,
      height: 1.2,
      color: Colors.white, // لإظهار تباين واضح على الخلفية الذهبية
      shadows: [
        Shadow(color: Colors.black.withOpacity(.08), blurRadius: 2, offset: const Offset(0, .5)),
      ],
    );
    final bodyStyle = TextStyle(
      fontSize: isCompact ? 14.5 : 16,
      height: 1.7,
      color: Colors.white.withOpacity(.92),
    );
    final smallStyle = TextStyle(
      fontSize: isCompact ? 12.5 : 13.5,
      height: 1.6,
      color: Colors.white.withOpacity(.88),
    );

    // 🧩 نصوص مترجمة
    final title    = AppStrings.ts(context, 'authorized_title',    fallback: 'Authorized');
    final body     = AppStrings.ts(context, 'authorized_body',     fallback: '');
    final bullets  = AppStrings.tl(context, 'authorized_bullets',  fallback: const <String>[]);
    final footnote = AppStrings.ts(context, 'authorized_note',     fallback: '');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CustomLayout1.kGold, // الذهبي
        borderRadius: BorderRadius.circular(CustomLayout1.kRadiusLg),
        border: Border.all(color: CustomLayout1.kBorder.withOpacity(.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.10),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Directionality( // ضمان محاذاة عربية لو وُجد تغيير خارجي
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: titleStyle, textAlign: TextAlign.right),
            if (body.trim().isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(body, style: bodyStyle, textAlign: TextAlign.right),
            ],
            if (bullets.isNotEmpty) ...[
              const SizedBox(height: 14),
              for (final b in bullets) _Bullet(text: b, compact: isCompact),
            ],
            if (footnote.trim().isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(footnote, style: smallStyle, textAlign: TextAlign.right),
            ],
          ],
        ),
      ),
    );
  }
}

/// عنصر نقطة بقائمة
class _Bullet extends StatelessWidget {
  final String text;
  final bool compact;
  const _Bullet({required this.text, required this.compact});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: compact ? 6 : 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: compact ? 13.5 : 14.5,
                height: 1.6,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.check_circle_rounded, size: 20, color: Colors.white),
        ],
      ),
    );
  }
}
