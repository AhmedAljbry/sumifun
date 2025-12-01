import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sumfiun/Core/util/App_String.dart';

/// Customer Service — responsive (Desktop / Tablet / Mobile)
/// - All text from AppStrings.ts/tl ONLY (safe fallbacks)
/// - Sections: Hero, Intro, Vision, Services, Channels, Hours, Quick Actions
/// - RTL aware; elegant cards; comfy spacing
class CustomerServicePage extends StatelessWidget {
  const CustomerServicePage({super.key});

  // —— Breakpoints ——
  static const double _tabletMin = 720;    // >= tablet
  static const double _desktopMin = 1120;  // >= desktop

  bool _isRtl(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return lang == 'ar' || Directionality.of(context) == TextDirection.rtl;
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = _isRtl(context);
    final title = AppStrings.ts(context, 'footer_support_title', fallback: 'Customer Service');

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(title), centerTitle: true),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, cons) {
              final w = cons.maxWidth;
              if (w >= _desktopMin) return _DesktopView();
              if (w >= _tabletMin)  return _TabletView();
              return _MobileView();
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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1320),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            children: [
              _HeroHeader(
                title: AppStrings.ts(context, 'support_title', fallback: 'Customer Service'),
                subtitle: AppStrings.ts(context, 'support_commitment_body', fallback: 'We are here to help you at every step.'),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left column (wider): Intro, Vision, Services
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: const [
                        _IntroCard(),
                        SizedBox(height: 12),
                        _VisionServicesGrid(twoColumns: true),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Right column (narrow): Channels, Hours, Quick actions
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: const [
                        _ChannelsCard(),
                        SizedBox(height: 12),
                        _HoursCard(),
                        SizedBox(height: 12),
                        _QuickActionsCard(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  AppStrings.ts(context, 'footer_copyright',
                    fallback: '© ${DateTime.now().year}, Sumifun Store — Authorized distributor of Sumifun healthcare products.',
                  ),
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
// Tablet View (stacked, 2-col grid for vision/services)
// =============================
class _TabletView extends StatelessWidget {
  const _TabletView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              _HeroHeaderTablet(),
              SizedBox(height: 14),
              _IntroCard(),
              SizedBox(height: 12),
              _VisionServicesGrid(twoColumns: true),
              SizedBox(height: 12),
              _ChannelsCard(),
              SizedBox(height: 12),
              _HoursCard(),
              SizedBox(height: 12),
              _QuickActionsCard(),
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
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _HeroHeaderTablet(),
          SizedBox(height: 12),
          _IntroCard(),
          SizedBox(height: 12),
          _VisionServicesGrid(twoColumns: false),
          SizedBox(height: 12),
          _ChannelsCard(),
          SizedBox(height: 12),
          _HoursCard(),
          SizedBox(height: 12),
          _QuickActionsCard(),
        ],
      ),
    );
  }
}

// =============================
// Shared Widgets
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
          // يمكن لاحقاً استبدالها بصورة غلاف ثابتة (Asset/Image)
          Container(
            height: 180,
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
                      Icon(Icons.support_agent, color: theme.colorScheme.onPrimaryContainer),
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

class _HeroHeaderTablet extends StatelessWidget {
  const _HeroHeaderTablet();
  @override
  Widget build(BuildContext context) {
    return _HeroHeader(
      title: AppStrings.ts(context, 'support_title', fallback: 'Customer Service'),
      subtitle: AppStrings.ts(context, 'support_commitment_body', fallback: 'We are here to help you at every step.'),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();

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
              AppStrings.ts(context, 'support_title', fallback: 'Customer Service'),
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.ts(context, 'support_intro', fallback: 'Our customer care team is ready to help.'),
            ),
          ],
        ),
      ),
    );
  }
}

class _VisionServicesGrid extends StatelessWidget {
  const _VisionServicesGrid({required this.twoColumns});
  final bool twoColumns;

  @override
  Widget build(BuildContext context) {
    final children = const [
      _VisionCard(),
      _ServicesCard(),
    ];
    if (!twoColumns) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          children[0],
          const SizedBox(height: 12),
          children[1],
        ],
      );
    }
    return LayoutBuilder(
      builder: (context, cons) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: children[0]),
            const SizedBox(width: 12),
            Expanded(child: children[1]),
          ],
        );
      },
    );
  }
}

class _VisionCard extends StatelessWidget {
  const _VisionCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bullets = AppStrings.tl(context, 'support_vision_points', fallback: const <String>[]);

    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.ts(context, 'support_vision_title', fallback: 'Our Vision'),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            if (bullets.isEmpty)
              Text(
                AppStrings.ts(context, 'support_vision_fallback',
                    fallback: 'We strive to deliver timely, caring, and effective support.'),
              )
            else
              for (final item in bullets) _Bullet(item: item),
          ],
        ),
      ),
    );
  }
}

class _ServicesCard extends StatelessWidget {
  const _ServicesCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bullets = AppStrings.tl(context, 'support_services_points', fallback: const <String>[]);

    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.ts(context, 'support_services_title', fallback: 'Our Services Include'),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            if (bullets.isEmpty)
              Text(
                AppStrings.ts(context, 'support_services_fallback',
                    fallback: 'Pre-sale consulting, after-sales support, order help, warranty guidance.'),
              )
            else
              for (final item in bullets) _Bullet(item: item),
          ],
        ),
      ),
    );
  }
}

class _ChannelsCard extends StatelessWidget {
  const _ChannelsCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final body   = AppStrings.ts(context, 'support_channels_body', fallback: '');
    final site   = AppStrings.ts(context, 'privacy_contact_site',  fallback: 'www.sumifun.net');
    final email  = AppStrings.ts(context, 'privacy_contact_email', fallback: 'support@sumifun.net');
    final whats  = AppStrings.ts(context, 'support_whatsapp',       fallback: '+86 123 456 7890');

    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.ts(context, 'support_channels_title', fallback: 'Contact Channels'),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            if (body.isNotEmpty) Text(body),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _ContactChip(icon: Icons.public_outlined, label: site),
                _ContactChip(icon: Icons.email_outlined,   label: email),
                _ContactChip(icon: Icons.chat,         label: whats),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HoursCard extends StatelessWidget {
  const _HoursCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hint = AppStrings.ts(context, 'support_channels_body', fallback: '');
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '🕒 ' + AppStrings.ts(context, 'support_working_hours_title', fallback: 'Working Hours'),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.ts(
                context,
                'support_working_hours_body',
                fallback: hint.contains('9:00')
                    ? 'Monday–Friday — 9:00 AM to 6:00 PM (local time).'
                    : 'Our team responds during business hours.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard();

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cta    = AppStrings.ts(context, 'cta_button',  fallback: 'Chat with us now');
    final verify = AppStrings.ts(context, 'verify_cta',  fallback: 'Verify Product Authenticity');
    final title  = AppStrings.ts(context, 'support_commitment_title', fallback: 'Our Commitment');
    final body   = AppStrings.ts(context, 'support_commitment_body',  fallback: 'We are here to help from purchase to after-sales.');

    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(body),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {/* Navigator.pushNamed(context, '/support'); */},
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: Text(cta),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {/* Navigator.pushNamed(context, '/verify'); */},
                    icon: const Icon(Icons.verified_outlined),
                    label: Text(verify),
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

class _ContactChip extends StatelessWidget {
  const _ContactChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

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

class _Bullet extends StatelessWidget {
  const _Bullet({required this.item});
  final String item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(top: 6), child: _Dot()),
          const SizedBox(width: 10),
          Expanded(child: Text(item, style: theme.textTheme.bodyLarge)),
        ],
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
