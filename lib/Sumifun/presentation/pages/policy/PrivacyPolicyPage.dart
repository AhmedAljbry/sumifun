import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sumfiun/Core/util/App_String.dart';

/// Privacy Policy — responsive (Desktop / Tablet / Mobile)
/// - All text from AppStrings.ts/tl (no hard-coded copy)
/// - RTL/LTR aware
/// - Clean cards + bullets + meta chips
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
    final title = AppStrings.ts(context, 'privacy_title', fallback: 'Privacy Policy');

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          elevation: 0.5,
        ),
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
    final effectiveLabel = AppStrings.ts(context, 'privacy_effective_label', fallback: 'Effective');
    final effectiveDate  = AppStrings.ts(context, 'privacy_effective_date',  fallback: '—');
    final brandLabel     = AppStrings.ts(context, 'privacy_brand_label',     fallback: 'Brand');
    final brand          = AppStrings.ts(context, 'privacy_brand',           fallback: 'Sumifun');

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            children: [
              _HeroHeader(
                title: AppStrings.ts(context, 'privacy_title', fallback: 'Privacy Policy'),
                subtitle: brand,
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: Main content (wider)
                  const Expanded(flex: 7, child: _PolicyBody()),
                  const SizedBox(width: 20),
                  // Right: Meta/Contact (narrow)
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _InfoChip(label: effectiveLabel, value: effectiveDate, icon: Icons.event),
                            _InfoChip(label: brandLabel,     value: brand,        icon: Icons.local_hospital_outlined),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const _ContactCard(),
                        const SizedBox(height: 12),
                        const _QuickCopyCard(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  '© ${DateTime.now().year} — ${AppStrings.ts(context, "privacy_brand", fallback: "Sumifun")}',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
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
    final effectiveLabel = AppStrings.ts(context, 'privacy_effective_label', fallback: 'Effective');
    final effectiveDate  = AppStrings.ts(context, 'privacy_effective_date',  fallback: '—');
    final brandLabel     = AppStrings.ts(context, 'privacy_brand_label',     fallback: 'Brand');
    final brand          = AppStrings.ts(context, 'privacy_brand',           fallback: 'Sumifun');

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
                title: AppStrings.ts(context, 'privacy_title', fallback: 'Privacy Policy'),
                subtitle: brand,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _InfoChip(label: effectiveLabel, value: effectiveDate, icon: Icons.event),
                  _InfoChip(label: brandLabel,     value: brand,        icon: Icons.local_hospital_outlined),
                ],
              ),
              const SizedBox(height: 12),
              const _PolicyBody(),
              const SizedBox(height: 12),
              const _ContactCard(),
              const SizedBox(height: 12),
              const _QuickCopyCard(),
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
    final brand = AppStrings.ts(context, 'privacy_brand', fallback: 'Sumifun');

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HeroHeader(
            title: AppStrings.ts(context, 'privacy_title', fallback: 'Privacy Policy'),
            subtitle: brand,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(
                label: AppStrings.ts(context, 'privacy_effective_label', fallback: 'Effective'),
                value: AppStrings.ts(context, 'privacy_effective_date', fallback: '—'),
                icon: Icons.event,
              ),
              _InfoChip(
                label: AppStrings.ts(context, 'privacy_brand_label', fallback: 'Brand'),
                value: brand,
                icon: Icons.local_hospital_outlined,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _PolicyBody(),
          const SizedBox(height: 12),
          const _ContactCard(),
          const SizedBox(height: 12),
          const _QuickCopyCard(),
          const SizedBox(height: 8),
          Center(
            child: Text('© ${DateTime.now().year} — $brand'),
          ),
        ],
      ),
    );
  }
}

// =============================
// Policy Body (shared)
// =============================
class _PolicyBody extends StatelessWidget {
  const _PolicyBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = AppStrings.ts(context, 'privacy_title');
    final effectiveLabel = AppStrings.ts(context, 'privacy_effective_label');
    final effectiveDate  = AppStrings.ts(context, 'privacy_effective_date');
    final brandLabel     = AppStrings.ts(context, 'privacy_brand_label');
    final brand          = AppStrings.ts(context, 'privacy_brand');
    final intro          = AppStrings.ts(context, 'privacy_intro');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Intro + meta chips (small)
        _SectionCard(
          headline: title,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SelectableText(intro, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: [
                  if (effectiveLabel.isNotEmpty && effectiveDate.isNotEmpty)
                    _InfoChip(label: effectiveLabel, value: effectiveDate, icon: Icons.event),
                  if (brandLabel.isNotEmpty && brand.isNotEmpty)
                    _InfoChip(label: brandLabel, value: brand, icon: Icons.local_hospital_outlined),
                ],
              ),
            ],
          ),
        ),

        // 1) Information We Collect
        _SectionCard(
          headline: AppStrings.ts(context, 'privacy_s1_title'),
          padding: const EdgeInsets.fromLTRB(16,16,16,8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SectionIntro(keyName: 'privacy_s1_intro'),
              const SizedBox(height: 8),
              const _Bullets(listKey: 'privacy_s1_points'),
            ],
          ),
        ),

        // 2) How We Use Information
        _SectionCard(
          headline: AppStrings.ts(context, 'privacy_s2_title'),
          child: const _Bullets(listKey: 'privacy_s2_points'),
        ),

        // 3) Data Security
        _SectionCard(
          headline: AppStrings.ts(context, 'privacy_s3_title'),
          child: SelectableText(AppStrings.ts(context, 'privacy_s3_body')),
        ),

        // 4) Sharing Information
        _SectionCard(
          headline: AppStrings.ts(context, 'privacy_s4_title'),
          padding: const EdgeInsets.fromLTRB(16,16,16,8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              _SectionIntro(keyName: 'privacy_s4_intro'),
              SizedBox(height: 8),
              _Bullets(listKey: 'privacy_s4_points'),
            ],
          ),
        ),

        // 5) Cookies
        _SectionCard(
          headline: AppStrings.ts(context, 'privacy_s5_title'),
          child: SelectableText(AppStrings.ts(context, 'privacy_s5_body')),
        ),

        // 6) Your Rights + contact
        _SectionCard(
          headline: AppStrings.ts(context, 'privacy_s6_title'),
          padding: const EdgeInsets.fromLTRB(16,16,16,8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Bullets(listKey: 'privacy_s6_points'),
              const SizedBox(height: 12),
              Text(
                AppStrings.ts(context, 'privacy_s6_contact_hint'),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              const _ContactRow(emailKey: 'privacy_contact_email', siteKey: 'privacy_contact_site'),
            ],
          ),
        ),

        // 7) Changes
        _SectionCard(
          headline: AppStrings.ts(context, 'privacy_s7_title'),
          child: SelectableText(AppStrings.ts(context, 'privacy_s7_body')),
        ),

        // 8) Contact
        _SectionCard(
          headline: AppStrings.ts(context, 'privacy_s8_title'),
          child: SelectableText(AppStrings.ts(context, 'privacy_s8_body')),
        ),
      ],
    );
  }
}

// =============================
// Shared UI pieces
// =============================
class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primaryContainer;
    final onColor = theme.colorScheme.onPrimaryContainer;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Container(
            height: 180,
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
                  Text(title, style: theme.textTheme.headlineSmall?.copyWith(
                    color: onColor, fontWeight: FontWeight.w800,
                  )),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_user_outlined, color: onColor),
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.headline, required this.child, this.padding});
  final String headline;
  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
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

class _SectionIntro extends StatelessWidget {
  const _SectionIntro({required this.keyName});
  final String keyName;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      AppStrings.ts(context, keyName),
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}

class _Bullets extends StatelessWidget {
  const _Bullets({required this.listKey});
  final String listKey;

  @override
  Widget build(BuildContext context) {
    final items = AppStrings.tl(context, listKey, fallback: const <String>[]);
    final theme = Theme.of(context);
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
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

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.emailKey, required this.siteKey});
  final String emailKey;
  final String siteKey;

  @override
  Widget build(BuildContext context) {
    final email = AppStrings.ts(context, emailKey, fallback: 'support@sumifun.net');
    final site  = AppStrings.ts(context, siteKey,  fallback: 'www.sumifun.net');
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _CopyChip(label: email, icon: Icons.email_outlined),
        _CopyChip(label: site,  icon: Icons.public_outlined),
      ],
    );
  }
}

class _CopyChip extends StatelessWidget {
  const _CopyChip({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ActionChip(
      avatar: Icon(icon, size: 18, color: theme.colorScheme.onSecondaryContainer),
      label: Text(label, overflow: TextOverflow.ellipsis),
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: label));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_snackBarText(context))),
          );
        }
      },
      shape: StadiumBorder(side: BorderSide(color: theme.colorScheme.outlineVariant)),
      backgroundColor: theme.colorScheme.secondaryContainer.withOpacity(.25),
    );
  }

  String _snackBarText(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    switch (lang) {
      case 'ar':
        return 'تم النسخ إلى الحافظة';
      case 'zh':
        return '已复制到剪贴板';
      default:
        return 'Copied to clipboard';
    }
  }
}

// Right column cards (desktop/tablet)
class _ContactCard extends StatelessWidget {
  const _ContactCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.ts(context, 'privacy_s6_title', fallback: 'Your Rights & Contact'),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const _ContactRow(emailKey: 'privacy_contact_email', siteKey: 'privacy_contact_site'),
          ],
        ),
      ),
    );
  }
}

class _QuickCopyCard extends StatelessWidget {
  const _QuickCopyCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = AppStrings.ts(context, 'privacy_brand', fallback: 'Sumifun');
    final date  = AppStrings.ts(context, 'privacy_effective_date', fallback: '');

    final summary = [
      AppStrings.ts(context, 'privacy_title', fallback: 'Privacy Policy'),
      if (brand.isNotEmpty) brand,
      if (date.isNotEmpty) date,
    ].where((e) => e.trim().isNotEmpty).join(' — ');

    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.copy_all_outlined),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                summary,
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: summary));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(_snackBarText(context))),
                  );
                }
              },
              child: Text(AppStrings.ts(context, 'common_copy', fallback: 'Copy')),
            ),
          ],
        ),
      ),
    );
  }

  String _snackBarText(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    switch (lang) {
      case 'ar':
        return 'تم النسخ إلى الحافظة';
      case 'zh':
        return '已复制到剪贴板';
      default:
        return 'Copied to clipboard';
    }
  }
}
