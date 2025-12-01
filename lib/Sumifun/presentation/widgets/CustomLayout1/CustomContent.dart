import 'package:flutter/material.dart';
import 'package:sumfiun/Core/util/App_Image.dart';
import 'package:sumfiun/Core/util/App_String.dart';

/// الغلاف: يقرر أي نسخة يستخدم (هاتف/ديسكتوب) دون تغيير المحتوى
class SumifunJointOilSection extends StatelessWidget {
  const SumifunJointOilSection({
    super.key,
    this.onBuy,
    this.onLearnMore,
    this.imageUrl, // لو ما انمرر، نستخدم قيمة AppImage
  });

  final VoidCallback? onBuy;
  final VoidCallback? onLearnMore;
  final String? imageUrl;

  static const _breakpoint = 800.0;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= _breakpoint) {
      return SumifunJointOilSectionDesktop(
        onBuy: onBuy,
        onLearnMore: onLearnMore,
        imageUrl: imageUrl,
      );
    }
    return SumifunJointOilSectionPhone(
      onBuy: onBuy,
      onLearnMore: onLearnMore,
      imageUrl: imageUrl,
    );
  }
}

/// ======================
/// نسخة الهاتف (عمودي)
/// ======================
class SumifunJointOilSectionPhone extends StatelessWidget {
  const SumifunJointOilSectionPhone({
    super.key,
    this.onBuy,
    this.onLearnMore,
    this.imageUrl,
  });

  final VoidCallback? onBuy;
  final VoidCallback? onLearnMore;
  final String? imageUrl;

  static const _maxWidth = 1100.0;
  static const _pad = 20.0;
  static const _gap = 16.0;
  static const _brand = Color(0xFF0EA5E9);

  @override
  Widget build(BuildContext context) {
    // مفتاح الصورة الافتراضي (تأكد من اسم المتغير الصحيح داخل AppImage)
    final resolvedImageUrl = imageUrl ?? AppImage.detaiils_image;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: _maxWidth),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: _CardFrame(
          child: Padding(
            padding: const EdgeInsets.all(_pad),
            child: Column(
              children: [
                _ImageBlock(
                  imageUrl: resolvedImageUrl,
                  brandColor: _brand,
                ),
                const SizedBox(height: _gap),
                _TextBlock(
                  // الcallbacks يجلبها _CtaRow من السلف
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
/// نسخة التابلت/الديسكتوب (أفقي)
/// ======================
class SumifunJointOilSectionDesktop extends StatelessWidget {
  const SumifunJointOilSectionDesktop({
    super.key,
    this.onBuy,
    this.onLearnMore,
    this.imageUrl,
  });

  final VoidCallback? onBuy;
  final VoidCallback? onLearnMore;
  final String? imageUrl;

  static const _maxWidth = 1100.0;
  static const _pad = 20.0;
  static const _brand = Color(0xFF0EA5E9);

  @override
  Widget build(BuildContext context) {
    final resolvedImageUrl = imageUrl ?? AppImage.detaiils_image;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: _maxWidth),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: _CardFrame(
          child: Padding(
            padding: const EdgeInsets.all(_pad),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _ImageBlock(
                    imageUrl: resolvedImageUrl,
                    brandColor: _brand,
                  ),
                ),
                const SizedBox(width: 24),
                const Expanded(child: _TextBlock()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ======================
/// العناصر المشتركة (بدون أي تغيير في المحتوى/التصميم)
/// ======================

class _CardFrame extends StatelessWidget {
  const _CardFrame({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF7FAFC), Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: const Color(0xFFE6EEF3)),
      ),
      child: child,
    );
  }
}

class _ImageBlock extends StatelessWidget {
  const _ImageBlock({
    required this.imageUrl,
    required this.brandColor,
  });

  final String imageUrl;
  final Color brandColor;

  ImageProvider _providerFrom(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return NetworkImage(url);
    }
    return AssetImage(url);
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = _providerFrom(imageUrl);

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // صورة المنتج
            Image(
              image: imageProvider,
              fit: BoxFit.cover,
              frameBuilder: (ctx, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded || frame != null) return child;
                return Container(
                  color: const Color(0xFFF0F4F8),
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(strokeWidth: 2.4),
                );
              },
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFF0F4F8),
                alignment: Alignment.center,
                child: const Icon(Icons.image_not_supported_outlined, size: 42),
              ),
              semanticLabel: AppStrings.t<String>(context, 'sumifun_joint_oil_title'),
            ),

            // بادج العلامة
            PositionedDirectional(
              top: 12,
              start: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: brandColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  AppStrings.t<String>(context, 'brand_sumifun'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .3,
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

class _TextBlock extends StatelessWidget {
  const _TextBlock();

  static const _brand = Color(0xFF0EA5E9);

  @override
  Widget build(BuildContext context) {
    final title   = AppStrings.t<String>(context, 'sumifun_joint_oil_title');
    final subtitle= AppStrings.t<String>(context, 'sumifun_joint_oil_subtitle');
    final desc    = AppStrings.t<String>(context, 'sumifun_joint_oil_desc');
    final using   = AppStrings.t<String>(context, 'sumifun_joint_oil_usage');
    final cta     = AppStrings.t<String>(context, 'cta_buy_now');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.start,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, height: 1.2),
        ),
        const SizedBox(height: 8),

        Text(
          subtitle,
          style: TextStyle(fontSize: 16, color: Colors.grey.shade700, height: 1.5),
        ),
        const SizedBox(height: 14),

        // فاصل
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, _brand.withOpacity(.25), Colors.transparent],
            ),
          ),
        ),
        const SizedBox(height: 14),

        Text(desc, style: const TextStyle(fontSize: 15.5, height: 1.7)),
        const SizedBox(height: 14),

        _BulletRow(icon: Icons.check_circle_rounded, text: AppStrings.t<String>(context, 'sumifun_joint_oil_b1')),
        _BulletRow(icon: Icons.check_circle_rounded, text: AppStrings.t<String>(context, 'sumifun_joint_oil_b2')),
        _BulletRow(icon: Icons.check_circle_rounded, text: AppStrings.t<String>(context, 'sumifun_joint_oil_b3')),
        _BulletRow(icon: Icons.check_circle_rounded, text: AppStrings.t<String>(context, 'sumifun_joint_oil_b4')),
        const SizedBox(height: 12),

        // طريقة الاستخدام
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFECFEFF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFBAE6FD)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, size: 22, color: Color(0xFF0369A1)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(using, style: const TextStyle(fontSize: 14.5, height: 1.7)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        _CtaRow(ctaText: cta),
      ],
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, size: 20, color: Color(0xFF0EA5E9)),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15.5, height: 1.6))),
        ],
      ),
    );
  }
}

/// صف الأزرار مع تمرير الأفعال من الـ parent عبر البحث عن السلف.
/// (نفس منطقك الأصلي بدون تغيير)
class _CtaRow extends StatelessWidget {
  const _CtaRow({required this.ctaText});
  final String ctaText;

  @override
  Widget build(BuildContext context) {
    // نبحث عن الـ parent للحصول على الكولباكس
    final parent = context.findAncestorWidgetOfExactType<SumifunJointOilSection>();

    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: parent?.onBuy,
          icon: const Icon(Icons.shopping_bag_outlined),
          label: Text(ctaText),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 0,
            backgroundColor: const Color(0xFF0EA5E9),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 12),
        TextButton(
          onPressed: parent?.onLearnMore,
          child: Text(
            AppStrings.t<String>(context, 'cta_learn_more'),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
