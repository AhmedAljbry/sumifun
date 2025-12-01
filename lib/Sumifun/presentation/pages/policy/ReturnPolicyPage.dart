import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sumfiun/Core/util/App_String.dart';

/// Return & Exchange Policy — responsive (Desktop / Tablet / Mobile)
/// - All content via AppStrings.ts/tl (ar/en/zh) with safe fallbacks
/// - RTL/LTR aware
/// - Sections: Intro, Eligibility, Conditions, Steps, Refunds, Exceptions, Proof, Contact
class ReturnPolicyPage extends StatelessWidget {
  const ReturnPolicyPage({super.key});

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
    final title = AppStrings.ts(context, 'return_title', fallback: 'Return & Exchange Policy');

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
    final effLabel = AppStrings.ts(context, 'return_effective_label', fallback: 'Effective Date');
    final effDate  = AppStrings.ts(context, 'return_effective_date',  fallback: '—');
    final brand    = AppStrings.ts(context, 'privacy_brand',          fallback: 'Sumifun');

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            children: [
              _HeroHeader(
                title: AppStrings.ts(context, 'return_title', fallback: 'Return & Exchange Policy'),
                subtitle: '$effLabel: $effDate',
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: main content
                  const Expanded(flex: 7, child: _ReturnBody()),
                  const SizedBox(width: 20),
                  // Right: meta + quick actions
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          spacing: 10, runSpacing: 10,
                          children: [
                            _InfoChip(
                              icon: Icons.local_hospital_outlined,
                              label: AppStrings.ts(context, 'privacy_brand_label', fallback: 'Brand'),
                              value: brand,
                            ),
                            _InfoChip(
                              icon: Icons.event,
                              label: effLabel,
                              value: effDate,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const _ContactSection(), // نفس القسم لكن موضوع في العمود الجانبي
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
    final effLabel = AppStrings.ts(context, 'return_effective_label', fallback: 'Effective Date');
    final effDate  = AppStrings.ts(context, 'return_effective_date',  fallback: '—');
    final brand    = AppStrings.ts(context, 'privacy_brand',          fallback: 'Sumifun');

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
                title: AppStrings.ts(context, 'return_title', fallback: 'Return & Exchange Policy'),
                subtitle: '$effLabel: $effDate',
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10, runSpacing: 10,
                children: [
                  _InfoChip(
                    icon: Icons.local_hospital_outlined,
                    label: AppStrings.ts(context, 'privacy_brand_label', fallback: 'Brand'),
                    value: brand,
                  ),
                  _InfoChip(icon: Icons.event, label: effLabel, value: effDate),
                ],
              ),
              const SizedBox(height: 12),
              const _ReturnBody(),
              const SizedBox(height: 12),
              const _ContactSection(),
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
    final brand   = AppStrings.ts(context, 'privacy_brand',          fallback: 'Sumifun');
    final effDate = AppStrings.ts(context, 'return_effective_date',  fallback: '—');
    final effLbl  = AppStrings.ts(context, 'return_effective_label', fallback: 'Effective Date');

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HeroHeader(
            title: AppStrings.ts(context, 'return_title', fallback: 'Return & Exchange Policy'),
            subtitle: '$effLbl: $effDate',
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: [
              _InfoChip(
                icon: Icons.local_hospital_outlined,
                label: AppStrings.ts(context, 'privacy_brand_label', fallback: 'Brand'),
                value: brand,
              ),
              _InfoChip(icon: Icons.event, label: effLbl, value: effDate),
            ],
          ),
          const SizedBox(height: 12),
          const _ReturnBody(),
          const SizedBox(height: 12),
          const _ContactSection(),
          const SizedBox(height: 8),
          Center(child: Text('© ${DateTime.now().year} — $brand')),
        ],
      ),
    );
  }
}

// =============================
// Shared body builder
// =============================
class _ReturnBody extends StatelessWidget {
  const _ReturnBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Intro
        _SectionCard(
          headline: AppStrings.ts(context, 'return_intro_title', fallback: 'Overview'),
          child: SelectableText(
            AppStrings.ts(
              context,
              'return_intro',
              fallback:
              'We aim to make returns and exchanges simple and fair. Please review the conditions and steps below.',
            ),
            style: theme.textTheme.bodyLarge,
          ),
        ),

        // Eligibility
        _SectionBullets(
          titleKey: 'return_s1_title',
          listKey:  'return_s1_points',
          fallbackTitle: 'Eligibility',
          fallbackBullets: const [
            'Item must be unused and in original packaging.',
            'Return request within the stated window (e.g., 7–14 days).',
            'Receipt/order number required.',
          ],
        ),

        // Conditions
        _SectionBullets(
          titleKey: 'return_s2_title',
          listKey:  'return_s2_points',
          fallbackTitle: 'Conditions',
          fallbackBullets: const [
            'All accessories and gifts must be included.',
            'Product must be free of damage, stains, or wear.',
            'Health/skin-contact items require safety seals intact.',
          ],
        ),

        // Steps (timeline-like)
        _SectionSteps(
          titleKey: 'return_steps_title',
          stepsKey: 'return_steps_points',
          fallbackTitle: 'How to Start a Return',
          fallbackSteps: const [
            'Contact support with your order number and reason.',
            'Receive confirmation and shipping instructions.',
            'Ship the product securely; keep the tracking receipt.',
            'We inspect the item upon arrival and notify you of approval.',
          ],
        ),

        // Refunds
        _SectionBullets(
          titleKey: 'return_refund_title',
          listKey:  'return_refund_points',
          fallbackTitle: 'Refunds',
          fallbackBullets: const [
            'Approved refunds are issued to the original payment method.',
            'Processing times vary by bank/payment provider.',
            'Shipping fees are non-refundable unless due to our error.',
          ],
        ),

        // Exceptions
        _SectionBullets(
          titleKey: 'return_exceptions_title',
          listKey:  'return_exceptions_points',
          fallbackTitle: 'Exceptions',
          fallbackBullets: const [
            'Opened personal-care items may not be returnable for health reasons.',
            'Custom/bulk orders are subject to special terms.',
          ],
        ),

        // Proof
        _SectionBullets(
          titleKey: 'return_proof_title',
          listKey:  'return_proof_points',
          fallbackTitle: 'Proof & Documentation',
          fallbackBullets: const [
            'Provide photos/videos for damaged/incorrect items before shipping back.',
            'Keep your courier receipt and tracking number.',
          ],
        ),
      ],
    );
  }
}

// =============================
// Shared UI widgets
// =============================
class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.primaryContainer.withOpacity(.85),
                ],
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
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.assignment_return_outlined,
                          color: theme.colorScheme.onPrimaryContainer),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          subtitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer.withOpacity(.95),
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

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

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
            Text(headline, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _SectionBullets extends StatelessWidget {
  const _SectionBullets({
    required this.titleKey,
    required this.listKey,
    this.fallbackTitle,
    this.fallbackBullets = const <String>[],
  });
  final String titleKey;
  final String listKey;
  final String? fallbackTitle;
  final List<String> fallbackBullets;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = AppStrings.ts(context, titleKey, fallback: fallbackTitle ?? '');
    final items = AppStrings.tl(context, listKey, fallback: fallbackBullets);

    return _SectionCard(
      headline: title,
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

class _SectionSteps extends StatelessWidget {
  const _SectionSteps({
    required this.titleKey,
    required this.stepsKey,
    this.fallbackTitle,
    this.fallbackSteps = const <String>[],
  });
  final String titleKey;
  final String stepsKey;
  final String? fallbackTitle;
  final List<String> fallbackSteps;

  @override
  Widget build(BuildContext context) {
    final title = AppStrings.ts(context, titleKey, fallback: fallbackTitle ?? '');
    final steps = AppStrings.tl(context, stepsKey, fallback: fallbackSteps);

    return _SectionCard(
      headline: title,
      child: Column(
        children: [
          for (int i = 0; i < steps.length; i++) _StepTile(index: i + 1, text: steps[i]),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({required this.index, required this.text});
  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepBadge(index: index),
          const SizedBox(width: 12),
          Expanded(child: SelectableText(text, style: theme.textTheme.bodyLarge)),
        ],
      ),
    );
  }
}

class _StepBadge extends StatelessWidget {
  const _StepBadge({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 28, height: 28, alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        '$index',
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold,
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

class _ContactSection extends StatelessWidget {
  const _ContactSection();

  @override
  Widget build(BuildContext context) {
    final theme     = Theme.of(context);
    final ctaStart  = AppStrings.ts(context, 'return_cta_start',  fallback: 'Start a Return');
    final ctaVerify = AppStrings.ts(context, 'return_cta_verify', fallback: 'Verify Product Authenticity');

    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(AppStrings.ts(context, 'support_title', fallback: 'Customer Service'),
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(AppStrings.ts(context, 'support_intro', fallback: 'For any questions or issues, contact our team.')),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {/* Navigator.pushNamed(context, '/returns/start'); */},
                    icon: const Icon(Icons.assignment_return),
                    label: Text(ctaStart),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {/* Navigator.pushNamed(context, '/verify'); */},
                    icon: const Icon(Icons.verified_outlined),
                    label: Text(ctaVerify),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
