import 'package:flutter/material.dart';
import 'package:sumfiun/Core/util/App_String.dart';

/// Terms & Conditions — responsive (Desktop / Tablet / Mobile)
/// - All copy from AppStrings.ts/tl (ar/en/zh) with safe fallbacks
/// - RTL/LTR aware
/// - Reusable widgets (cards, bullets, chips)
class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  // Breakpoints
  static const double _tabletMin = 720;    // >= tablet
  static const double _desktopMin = 1120;  // >= desktop

  bool _isRtl(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return lang == 'ar' || Directionality.of(context) == TextDirection.rtl;
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = _isRtl(context);
    final title = AppStrings.ts(context, 'terms_title', fallback: 'Terms & Conditions');

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(title), centerTitle: true),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, cons) {
              final w = cons.maxWidth;
              if (w >= _desktopMin) return const _DesktopView();
              if (w >= _tabletMin)  return const _TabletView();
              return const _MobileView();
            },
          ),
        ),
      ),
    );
  }
}

// =============================
// Desktop View (two columns)
// =============================
class _DesktopView extends StatelessWidget {
  const _DesktopView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveLabel = AppStrings.ts(context, 'terms_effective_label', fallback: 'Effective');
    final effectiveDate  = AppStrings.ts(context, 'terms_effective_date',  fallback: '—');
    final brandLabel     = AppStrings.ts(context, 'terms_brand_label',     fallback: 'Brand');
    final brand          = AppStrings.ts(context, 'terms_brand',           fallback: 'Sumifun');

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            children: [
              _HeroHeader(
                title: AppStrings.ts(context, 'terms_title', fallback: 'Terms & Conditions'),
                subtitle: brand,
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: main content
                  const Expanded(flex: 7, child: _TermsBody()),
                  const SizedBox(width: 20),
                  // Right: meta + quick contact
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          spacing: 10, runSpacing: 10,
                          children: [
                            _InfoChip(label: effectiveLabel, value: effectiveDate, icon: Icons.event),
                            _InfoChip(label: brandLabel,     value: brand,        icon: Icons.business_outlined),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const _ContactCard(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  '© ${DateTime.now().year} — $brand',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================
// Tablet View (stacked)
// =============================
class _TabletView extends StatelessWidget {
  const _TabletView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveLabel = AppStrings.ts(context, 'terms_effective_label', fallback: 'Effective');
    final effectiveDate  = AppStrings.ts(context, 'terms_effective_date',  fallback: '—');
    final brandLabel     = AppStrings.ts(context, 'terms_brand_label',     fallback: 'Brand');
    final brand          = AppStrings.ts(context, 'terms_brand',           fallback: 'Sumifun');

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeroHeader(
                title: AppStrings.ts(context, 'terms_title', fallback: 'Terms & Conditions'),
                subtitle: brand,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10, runSpacing: 10,
                children: [
                  _InfoChip(label: effectiveLabel, value: effectiveDate, icon: Icons.event),
                  _InfoChip(label: brandLabel,     value: brand,        icon: Icons.business_outlined),
                ],
              ),
              const SizedBox(height: 12),
              const _TermsBody(),
              const SizedBox(height: 12),
              const _ContactCard(),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================
// Mobile View (single column)
// =============================
class _MobileView extends StatelessWidget {
  const _MobileView();

  @override
  Widget build(BuildContext context) {
    final brand = AppStrings.ts(context, 'terms_brand', fallback: 'Sumifun');

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HeroHeader(
            title: AppStrings.ts(context, 'terms_title', fallback: 'Terms & Conditions'),
            subtitle: brand,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: [
              _InfoChip(
                label: AppStrings.ts(context, 'terms_effective_label', fallback: 'Effective'),
                value: AppStrings.ts(context, 'terms_effective_date',  fallback: '—'),
                icon: Icons.event,
              ),
              _InfoChip(
                label: AppStrings.ts(context, 'terms_brand_label', fallback: 'Brand'),
                value: brand,
                icon: Icons.business_outlined,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _TermsBody(),
          const SizedBox(height: 12),
          const _ContactCard(),
          const SizedBox(height: 8),
          Center(child: Text('© ${DateTime.now().year} — $brand')),
        ],
      ),
    );
  }
}

// =============================
// Shared body
// =============================
class _TermsBody extends StatelessWidget {
  const _TermsBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        _IntroCard(),

        // Sections 1..10 (mix of text + bullets)
        _SectionText(titleKey: 'terms_s1_title',  bodyKey: 'terms_s1_body'),
        _SectionBullets(titleKey: 'terms_s2_title', listKey: 'terms_s2_points'),
        _SectionBullets(titleKey: 'terms_s3_title', listKey: 'terms_s3_points'),
        _SectionBullets(titleKey: 'terms_s4_title', listKey: 'terms_s4_points'),
        _SectionBullets(titleKey: 'terms_s5_title', listKey: 'terms_s5_points'),
        _SectionText(titleKey: 'terms_s6_title',  bodyKey: 'terms_s6_body'),
        _SectionText(titleKey: 'terms_s7_title',  bodyKey: 'terms_s7_body'),
        _SectionText(titleKey: 'terms_s8_title',  bodyKey: 'terms_s8_body'),
        _SectionText(titleKey: 'terms_s9_title',  bodyKey: 'terms_s9_body'),
        _SectionText(titleKey: 'terms_s10_title', bodyKey: 'terms_s10_body'),

        // Contact (s11)
        _ContactSectionCard(),
      ],
    );
  }
}

// =============================
// Reusable widgets
// =============================
class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme   = Theme.of(context);
    final color   = theme.colorScheme.primaryContainer;
    final onColor = theme.colorScheme.onPrimaryContainer;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Container(
            height: 170,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(.85)],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800, color: onColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.gavel_outlined, color: onColor),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          subtitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: onColor.withOpacity(.95),
                          ),
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

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _SectionCard(
      headline: AppStrings.ts(context, 'terms_title', fallback: 'Terms & Conditions'),
      child: SelectableText(
        AppStrings.ts(
          context,
          'terms_intro',
          fallback: 'Welcome to our website. By using it you agree to the following terms.',
        ),
        style: theme.textTheme.bodyLarge,
      ),
    );
  }
}

class _SectionText extends StatelessWidget {
  const _SectionText({required this.titleKey, required this.bodyKey});
  final String titleKey;
  final String bodyKey;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      headline: AppStrings.ts(context, titleKey),
      child: SelectableText(AppStrings.ts(context, bodyKey)),
    );
  }
}

class _SectionBullets extends StatelessWidget {
  const _SectionBullets({required this.titleKey, required this.listKey});
  final String titleKey;
  final String listKey;

  @override
  Widget build(BuildContext context) {
    final items = AppStrings.tl(context, listKey, fallback: const <String>[]);
    final theme = Theme.of(context);
    if (items.isEmpty) return const SizedBox.shrink();

    return _SectionCard(
      headline: AppStrings.ts(context, titleKey),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final item in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(padding: EdgeInsets.only(top: 6), child: _Dot()),
                  const SizedBox(width: 10),
                  Expanded(child: SelectableText(item, style: theme.textTheme.bodyLarge)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.headline, required this.child});
  final String headline;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              headline,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

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
            Text(
              '$label: ',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(value, style: theme.textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }
}

// Contact (Section 11) inside the main body
class _ContactSectionCard extends StatelessWidget {
  const _ContactSectionCard();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      headline: AppStrings.ts(context, 'terms_s11_title', fallback: 'Contact Us'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SelectableText(AppStrings.ts(context, 'terms_s11_body', fallback: '')),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: [
              _ContactChip(icon: Icons.public_outlined, label: AppStrings.ts(context, 'terms_contact_site',  fallback: 'www.sumifun.net')),
              _ContactChip(icon: Icons.email_outlined,  label: AppStrings.ts(context, 'terms_contact_email', fallback: 'support@sumifun.net')),
            ],
          ),
        ],
      ),
    );
  }
}

// Right column contact card (for desktop/tablet)
class _ContactCard extends StatelessWidget {
  const _ContactCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final site  = AppStrings.ts(context, 'terms_contact_site',  fallback: 'www.sumifun.net');
    final email = AppStrings.ts(context, 'terms_contact_email', fallback: 'support@sumifun.net');

    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.ts(context, 'terms_contact_title', fallback: 'Contact'),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: [
                _ContactChip(icon: Icons.public_outlined, label: site),
                _ContactChip(icon: Icons.email_outlined,  label: email),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactChip extends StatelessWidget {
  const _ContactChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InputChip(
      avatar: Icon(icon, size: 18, color: theme.colorScheme.onSecondaryContainer),
      label: Text(label, overflow: TextOverflow.ellipsis),
      onPressed: () {/* optionally open or copy */},
      selected: false,
    );
  }
}
