import 'package:flutter/material.dart';
import 'package:sumfiun/Core/util/App_String.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/CustomFooter.dart';

/// About Us page — clean, stable, and responsive
/// - Text is pulled ONLY from AppStrings.ts/tl
/// - Keys: about_title, about_body, privacy_brand (optional), cta_button (optional), footer_copyright
/// - RTL/LTR aware, responsive: Desktop / Tablet / Mobile
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  // ——— Breakpoints ———
  static const double _tabletMin = 720;   // >= tablet
  static const double _desktopMin = 1100; // >= desktop

  bool _isRtl(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return lang == 'ar' || Directionality.of(context) == TextDirection.rtl;
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = _isRtl(context);

    // Pull from AppStrings with safe fallbacks
    final title = AppStrings.ts(context, 'about_title', fallback: 'About Us');
    final body  = AppStrings.ts(context, 'about_body', fallback: _fallbackBody(context));
    final brand = AppStrings.ts(context, 'privacy_brand', fallback: 'Sumifun');
    final cta   = AppStrings.ts(context, 'cta_button', fallback: 'Chat with us now');

    final paragraphs = _splitParagraphs(body);

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;

              if (w >= _desktopMin) {
                return _buildDesktop(context, title, brand, cta, paragraphs, isRtl);
              } else if (w >= _tabletMin) {
                return _buildTablet(context, title, brand, cta, paragraphs, isRtl);
              } else {
                return _buildMobile(context, title, brand, cta, paragraphs, isRtl);
              }
            },
          ),
        ),
      ),
    );
  }

  // ——— Desktop Layout (2-column grid) ———
  Widget _buildDesktop(
      BuildContext context,
      String title,
      String brand,
      String cta,
      List<String> paragraphs,
      bool isRtl,
      ) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
          child: Column(
            children: [
              // Hero wide
              _HeroBannerDesktop(title: title, subtitle: brand),

              const SizedBox(height: 20),

              // Two columns: content + side panel
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: Main content
                  Expanded(
                    flex: 7,
                    child: Card(
                      elevation: 0.6,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(28, 28, 28, 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                _InfoChip(icon: Icons.verified_outlined, label: brand),
                                _InfoChip(icon: Icons.health_and_safety_outlined, label: brand),
                              ],
                            ),
                            const SizedBox(height: 16),
                            for (final p in paragraphs) ...[
                              SelectableText(
                                p,
                                style: theme.textTheme.titleMedium?.copyWith(height: 1.7),
                                textAlign: isRtl ? TextAlign.right : TextAlign.left,
                              ),
                              const SizedBox(height: 14),
                            ],
                            const SizedBox(height: 8),
                            Align(
                              alignment: isRtl ? Alignment.centerLeft : Alignment.centerRight,
                              child: FilledButton.icon(
                                onPressed: () {
                                  // Navigator.of(context).pushNamed('/support');
                                },
                                icon: const Icon(Icons.chat_bubble_outline),
                                label: Text(cta),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),

                  // Right: Side panel with image & highlights
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        _ImageCard(
                          imageAsset: 'assets/images/about.jpg',
                          alt: title,
                          aspectRatio: 16 / 10,
                        ),
                        const SizedBox(height: 16),
                        _HighlightsPanel(brand: brand),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _FooterNote(),
              const SizedBox(height: 8),

              const CustomFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // ——— Tablet Layout (stacked, wide hero) ———
  Widget _buildTablet(
      BuildContext context,
      String title,
      String brand,
      String cta,
      List<String> paragraphs,
      bool isRtl,
      ) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeroBlock(
                title: title,
                subtitle: brand,
                imageAsset: 'assets/images/about.jpg',
                alt: title,
                tall: true, // أقصر قليلًا لكن أعرض على التابلت
              ),
              const SizedBox(height: 16),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _InfoChip(icon: Icons.verified_outlined, label: brand),
                  _InfoChip(icon: Icons.health_and_safety_outlined, label: brand),
                ],
              ),
              const SizedBox(height: 12),

              Card(
                elevation: 0.5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final p in paragraphs) ...[
                        SelectableText(
                          p,
                          style: theme.textTheme.bodyLarge?.copyWith(height: 1.7),
                          textAlign: isRtl ? TextAlign.right : TextAlign.left,
                        ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
              _ImageCard(
                imageAsset: 'assets/images/about.jpg',
                alt: title,
                aspectRatio: 16 / 9,
              ),

              const SizedBox(height: 12),
              _HighlightsPanel(brand: brand),

              const SizedBox(height: 16),
              Align(
                alignment: isRtl ? Alignment.centerLeft : Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: Text(cta),
                ),
              ),

              const SizedBox(height: 24),
              _FooterNote(),
              const SizedBox(height: 8),
              const CustomFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // ——— Mobile Layout (single column, comfy spacing) ———
  Widget _buildMobile(
      BuildContext context,
      String title,
      String brand,
      String cta,
      List<String> paragraphs,
      bool isRtl,
      ) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HeroBlock(
            title: title,
            subtitle: brand,
            imageAsset: 'assets/images/about.jpg',
            alt: title,
            tall: false,
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(icon: Icons.verified_outlined, label: brand),
            ],
          ),
          const SizedBox(height: 10),

          Card(
            elevation: 0.4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final p in paragraphs) ...[
                    SelectableText(
                      p,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.65),
                      textAlign: isRtl ? TextAlign.right : TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),
          _ImageCard(
            imageAsset: 'assets/images/about.jpg',
            alt: title,
            aspectRatio: 16 / 10,
          ),

          const SizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.chat_bubble_outline),
              label: Text(cta),
            ),
          ),

          const SizedBox(height: 20),
          _FooterNote(),
          const SizedBox(height: 6),
          const CustomFooter(),
        ],
      ),
    );
  }

  // ——— Shared helpers ———
  List<String> _splitParagraphs(String body) {
    final raw = body.replaceAll('\r\n', '\n');
    final parts = raw.split(RegExp(r'\n\s*\n'));
    return parts.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  String _fallbackBody(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == 'ar') {
      return '''
تأسست بعناية — وصُممت من أجل العافية.

منذ انطلاقتنا، وضعت Sumifun صحة الإنسان وراحته في صميم كل ما نقوم به. نوفّر منتجات آمنة وفعّالة وسهلة الاستخدام تساعد الناس على التغلب على الآلام الجسدية وتحسين جودة حياتهم واستعادة الثقة والسعادة.

فلسفتنا بسيطة: الإنسان أولًا. نواصل الابتكار وتطوير منتجاتنا لتلبية احتياجات عملائنا المتجددة وتعزيز أسلوب حياة صحي ومستدام.
''';
    }
    if (lang == 'zh') {
      return '''
以关怀为本——为健康而生。

自成立以来，Sumifun 一直将个人健康与福祉置于核心。我们提供安全、有效、易用的产品，帮助人们减轻不适、提升生活质量、重拾自信与快乐。

我们的理念很简单：以人为本。我们持续创新，倡导积极、可持续的健康生活方式。
''';
    }
    return '''
Founded with care—built for wellness.

Since day one, Sumifun has put personal health and well-being at the heart of everything. We deliver safe, effective, easy-to-use products that relieve discomfort, improve quality of life, and restore confidence.

Our philosophy is simple: people first. We keep innovating to meet evolving needs and promote a sustainable, healthy lifestyle.
''';
  }
}

// ——— Desktop hero banner (subtle parallax feel with depth) ———
class _HeroBannerDesktop extends StatelessWidget {
  const _HeroBannerDesktop({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 16 / 5.2,
            child: Image.asset('assets/images/about.jpg', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black45, Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            left: 28,
            right: 28,
            bottom: 22,
            child: Semantics(
              label: title,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: .2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified_outlined, size: 20, color: Colors.white70),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                subtitle,
                                style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ——— Reused hero for tablet/mobile ———
class _HeroBlock extends StatelessWidget {
  const _HeroBlock({
    required this.title,
    required this.subtitle,
    required this.imageAsset,
    required this.alt,
    this.tall = false,
  });
  final String title;
  final String subtitle;
  final String imageAsset;
  final String alt;
  final bool tall;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: tall ? 16 / 6.5 : 16 / 9,
            child: Image.asset(imageAsset, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black38, Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Semantics(
              label: alt,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_outlined, size: 18, color: Colors.white70),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          subtitle,
                          style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ——— Image Card (shared) ———
class _ImageCard extends StatelessWidget {
  const _ImageCard({
    required this.imageAsset,
    required this.alt,
    this.aspectRatio = 16 / 9,
  });
  final String imageAsset;
  final String alt;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(imageAsset, fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.transparent, Colors.transparent],
                ),
              ),
            ),
            Positioned.fill(
              child: Semantics(label: alt, image: true, child: const SizedBox.shrink()),
            ),
          ],
        ),
      ),
    );
  }
}

// ——— Highlights / Facts panel ———
class _HighlightsPanel extends StatelessWidget {
  const _HighlightsPanel({required this.brand});
  final String brand;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0.6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              brand,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                _Badge(icon: Icons.science_outlined, text: 'Clinically-oriented'),
                _Badge(icon: Icons.favorite_outline, text: 'Well-being focus'),
                _Badge(icon: Icons.handshake_outlined, text: 'Customer-centric'),
                _Badge(icon: Icons.public_outlined, text: 'Global vision'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ——— Small pill badge used in highlights ———
class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceVariant,
      borderRadius: BorderRadius.circular(999),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(text, style: theme.textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}

// ——— InfoChip (shared) ———
class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceVariant,
      borderRadius: BorderRadius.circular(100),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(label, style: theme.textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}

// ——— Footer note (copyright from AppStrings) ———
class _FooterNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        AppStrings.ts(
          context,
          'footer_copyright',
          fallback:
          '© ${DateTime.now().year}, Sumifun Store — Authorized distributor of Sumifun healthcare products.',
        ),
        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        textAlign: TextAlign.center,
      ),
    );
  }
}
