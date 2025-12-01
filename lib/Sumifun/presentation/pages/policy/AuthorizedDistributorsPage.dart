import 'package:flutter/material.dart';
import 'package:sumfiun/Core/util/App_String.dart';

/// Authorized Distributors — responsive (Desktop / Tablet / Mobile)
/// - All text from AppStrings.ts/tl ONLY, with safe fallbacks
/// - Sticky filters on wide screens, comfy stack on tablet/mobile
/// - RTL/LTR aware
class AuthorizedDistributorsPage extends StatefulWidget {
  const AuthorizedDistributorsPage({super.key});

  @override
  State<AuthorizedDistributorsPage> createState() =>
      _AuthorizedDistributorsPageState();
}

class _AuthorizedDistributorsPageState
    extends State<AuthorizedDistributorsPage> {
  // --------- State ---------
  String _query = '';
  String? _region;

  // --------- Breakpoints ---------
  static const double _tabletMin = 680;    // >= tablet
  static const double _desktopMin = 1120;  // >= desktop

  bool _isRtl(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return lang == 'ar' || Directionality.of(context) == TextDirection.rtl;
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = _isRtl(context);

    // i18n lists
    final countries = AppStrings.tl(
      context,
      'dist_countries',
      fallback: _fallbackCountries(context),
    );
    final regions = AppStrings.tl(
      context,
      'dist_regions',
      fallback: _fallbackRegions(context),
    );

    // filtering
    final filtered = countries.where((c) {
      final byQuery =
          _query.trim().isEmpty || c.toLowerCase().contains(_query.toLowerCase());
      final byRegion = _region == null || _countryRegion(c) == _region;
      return byQuery && byRegion;
    }).toList();

    final title = AppStrings.ts(
        context, 'footer_link_distributors', fallback: 'Authorized Distributors');

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
                return _buildDesktop(context, filtered, regions);
              } else if (w >= _tabletMin) {
                return _buildTablet(context, filtered, regions);
              } else {
                return _buildMobile(context, filtered, regions);
              }
            },
          ),
        ),
      ),
    );
  }

  // =========================
  // Desktop layout (split: filters sticky + grid)
  // =========================
  Widget _buildDesktop(
      BuildContext context, List<String> filtered, List<String> regions) {
    final theme = Theme.of(context);
    final headerTitle =
    AppStrings.ts(context, 'distributors_title', fallback: 'Authorized Distributors');
    final headerSubtitle = AppStrings.ts(
      context,
      'distributors_subtitle',
      fallback: AppStrings.ts(
        context,
        'distributors_intro',
        fallback:
        'We proudly work with trusted, authorized partners to ensure original Sumifun products reach you safely and easily.',
      ),
    );
    final listTitle = AppStrings.ts(
      context,
      'distributors_list_title',
      fallback: 'Available Countries',
    );

    // columns: 4 (desktop)
    const crossAxisCount = 4;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1360),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Sticky filters / info
              SizedBox(
                width: 340,
                child: _StickyColumn(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _HeroHeader(title: headerTitle, subtitle: headerSubtitle),
                      const SizedBox(height: 14),
                      _SearchBar(
                        hint: AppStrings.ts(
                            context, 'distributors_search_hint', fallback: 'Search country…'),
                        onChanged: (v) => setState(() => _query = v),
                      ),
                      const SizedBox(height: 10),
                      _RegionChips(
                        regions: regions,
                        selected: _region,
                        onSelected: (r) =>
                            setState(() => _region = r == _region ? null : r),
                      ),
                      const SizedBox(height: 16),
                      _WhyCard(),
                      const SizedBox(height: 12),
                      _ContactCard(),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),

              // Right: grid + title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      listTitle,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),
                    LayoutBuilder(
                      builder: (context, cons) {
                        // keep aspect ratio readable on wide screens
                        final width = cons.maxWidth;
                        final itemWidth =
                            (width - (12.0 * (crossAxisCount - 1))) / crossAxisCount;
                        final itemHeight = 100.0;
                        final aspect = itemWidth / itemHeight;

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: aspect,
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final name = filtered[index];
                            return _CountryTile(
                              flag: _flagEmoji(name),
                              name: name,
                              region: _countryRegion(name) ?? '-',
                              onTap: () => _openCountrySheet(context, name),
                            );
                          },
                        );
                      },
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

  // =========================
  // Tablet layout (stacked hero + filters + 2-column grid)
  // =========================
  Widget _buildTablet(
      BuildContext context, List<String> filtered, List<String> regions) {
    final theme = Theme.of(context);
    final headerTitle =
    AppStrings.ts(context, 'distributors_title', fallback: 'Authorized Distributors');
    final headerSubtitle = AppStrings.ts(
      context,
      'distributors_subtitle',
      fallback: AppStrings.ts(
        context,
        'distributors_intro',
        fallback:
        'We proudly work with trusted, authorized partners to ensure original Sumifun products reach you safely and easily.',
      ),
    );
    final listTitle = AppStrings.ts(
      context,
      'distributors_list_title',
      fallback: 'Available Countries',
    );

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1140),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeroHeader(title: headerTitle, subtitle: headerSubtitle),
              const SizedBox(height: 14),
              _SearchBar(
                hint: AppStrings.ts(
                    context, 'distributors_search_hint', fallback: 'Search country…'),
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: 10),
              _RegionChips(
                regions: regions,
                selected: _region,
                onSelected: (r) =>
                    setState(() => _region = r == _region ? null : r),
              ),
              const SizedBox(height: 14),
              _WhyCard(),
              const SizedBox(height: 16),

              Text(
                listTitle,
                style:
                theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // tablet
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 16 / 6,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final name = filtered[index];
                  return _CountryTile(
                    flag: _flagEmoji(name),
                    name: name,
                    region: _countryRegion(name) ?? '-',
                    onTap: () => _openCountrySheet(context, name),
                  );
                },
              ),

              const SizedBox(height: 18),
              _ContactCard(),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // Mobile layout (single column, comfy spacing)
  // =========================
  Widget _buildMobile(
      BuildContext context, List<String> filtered, List<String> regions) {
    final theme = Theme.of(context);
    final headerTitle =
    AppStrings.ts(context, 'distributors_title', fallback: 'Authorized Distributors');
    final headerSubtitle = AppStrings.ts(
      context,
      'distributors_subtitle',
      fallback: AppStrings.ts(
        context,
        'distributors_intro',
        fallback:
        'We proudly work with trusted, authorized partners to ensure original Sumifun products reach you safely and easily.',
      ),
    );
    final listTitle = AppStrings.ts(
      context,
      'distributors_list_title',
      fallback: 'Available Countries',
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HeroHeader(title: headerTitle, subtitle: headerSubtitle),
          const SizedBox(height: 12),
          _SearchBar(
            hint: AppStrings.ts(
                context, 'distributors_search_hint', fallback: 'Search country…'),
            onChanged: (v) => setState(() => _query = v),
          ),
          const SizedBox(height: 10),
          _RegionChips(
            regions: regions,
            selected: _region,
            onSelected: (r) => setState(() => _region = r == _region ? null : r),
          ),

          const SizedBox(height: 12),
          _WhyCard(),

          const SizedBox(height: 14),
          Text(
            listTitle,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),

          // 1 column on mobile
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final name = filtered[index];
              return _CountryTile(
                flag: _flagEmoji(name),
                name: name,
                region: _countryRegion(name) ?? '-',
                onTap: () => _openCountrySheet(context, name),
              );
            },
          ),

          const SizedBox(height: 18),
          _ContactCard(),
        ],
      ),
    );
  }

  // =========================
  // Bottom sheet with official channels
  // =========================
  void _openCountrySheet(BuildContext context, String country) {
    final title = AppStrings.ts(
        context, 'distributors_country_sheet_title', fallback: 'Official Channels');
    final verifyCta =
    AppStrings.ts(context, 'distributors_verify_cta', fallback: 'Verify distributor');
    final note = AppStrings.ts(
      context,
      'distributors_country_note',
      fallback:
      'Purchase only through our official store or the listed authorized partners for this country.',
    );

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('$title — $country',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(note),
              const SizedBox(height: 12),
              _OfficialChannels(),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.verified_outlined),
                label: Text(verifyCta),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================
  // Fallback data
  // =========================
  List<String> _fallbackCountries(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    switch (lang) {
      case 'ar':
        return [
          'الصين',
          'ألمانيا',
          'السعودية',
          'مصر',
          'اليمن',
          'إثيوبيا',
          'ماليزيا',
          'إندونيسيا',
          'تركيا'
        ];
      case 'zh':
        return [
          '中国',
          '德国',
          '沙特阿拉伯',
          '埃及',
          '也门',
          '埃塞俄比亚',
          '马来西亚',
          '印度尼西亚',
          '土耳其'
        ];
      default:
        return [
          'China',
          'Germany',
          'Saudi Arabia',
          'Egypt',
          'Yemen',
          'Ethiopia',
          'Malaysia',
          'Indonesia',
          'Turkey'
        ];
    }
  }

  List<String> _fallbackRegions(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    switch (lang) {
      case 'ar':
        return ['الكل', 'آسيا', 'الشرق الأوسط', 'أفريقيا', 'أوروبا'];
      case 'zh':
        return ['全部', '亚洲', '中东', '非洲', '欧洲'];
      default:
        return ['All', 'Asia', 'Middle East', 'Africa', 'Europe'];
    }
  }

  String? _countryRegion(String name) {
    final n = name.toLowerCase();
    if (n.contains('china') ||
        n.contains('الصين') ||
        n.contains('中国') ||
        n.contains('malaysia') ||
        n.contains('马来西亚') ||
        n.contains('indonesia') ||
        n.contains('印度尼西亚')) {
      return 'Asia';
    }
    if (n.contains('saudi') ||
        n.contains('السعود') ||
        n.contains('沙特') ||
        n.contains('yemen') ||
        n.contains('اليمن')) {
      return 'Middle East';
    }
    if (n.contains('egypt') || n.contains('مصر')) return 'Africa';
    if (n.contains('ethiopia') || n.contains('إثيوب') || n.contains('埃塞')) {
      return 'Africa';
    }
    if (n.contains('germany') ||
        n.contains('ألمانيا') ||
        n.contains('德国') ||
        n.contains('turkey') ||
        n.contains('تركيا') ||
        n.contains('土耳其')) {
      return 'Europe';
    }
    return null;
  }

  String _flagEmoji(String name) {
    final map = <String, String>{
      'china': '🇨🇳',
      'germany': '🇩🇪',
      'saudi': '🇸🇦',
      'egypt': '🇪🇬',
      'yemen': '🇾🇪',
      'ethiopia': '🇪🇹',
      'malaysia': '🇲🇾',
      'indonesia': '🇮🇩',
      'turkey': '🇹🇷',
      'الصين': '🇨🇳',
      'ألمانيا': '🇩🇪',
      'السعودية': '🇸🇦',
      'مصر': '🇪🇬',
      'اليمن': '🇾🇪',
      'إثيوبيا': '🇪🇹',
      'ماليزيا': '🇲🇾',
      'إندونيسيا': '🇮🇩',
      'تركيا': '🇹🇷',
      '中国': '🇨🇳',
      '德国': '🇩🇪',
      '沙特阿拉伯': '🇸🇦',
      '埃及': '🇪🇬',
      '也门': '🇾🇪',
      '埃塞俄比亚': '🇪🇹',
      '马来西亚': '🇲🇾',
      '印度尼西亚': '🇮🇩',
      '土耳其': '🇹🇷',
    };
    final key = name.toLowerCase();
    for (final e in map.entries) {
      if (key.contains(e.key.toLowerCase())) return e.value;
    }
    return '🌍';
  }
}

// =========================
// Reusable widgets
// =========================

class _StickyColumn extends StatelessWidget {
  const _StickyColumn({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Small helper to keep left column "sticky-like" on desktop within page scroll
    return LayoutBuilder(
      builder: (context, cons) {
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: child,
        );
      },
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
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
              Icon(Icons.verified_outlined,
                  color: theme.colorScheme.onPrimaryContainer),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  subtitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color:
                    theme.colorScheme.onPrimaryContainer.withOpacity(.95),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.hint, required this.onChanged});
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: theme.colorScheme.surfaceVariant.withOpacity(.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}

class _RegionChips extends StatelessWidget {
  const _RegionChips(
      {required this.regions, required this.selected, required this.onSelected});
  final List<String> regions;
  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final items = regions;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final r in items)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: ChoiceChip(
                label: Text(r),
                selected: selected == r ||
                    (selected == null &&
                        (r.toLowerCase() == 'all' ||
                            r == 'الكل' ||
                            r == '全部')),
                onSelected: (_) => onSelected(r),
              ),
            ),
        ],
      ),
    );
  }
}

class _CountryTile extends StatelessWidget {
  const _CountryTile(
      {required this.flag,
        required this.name,
        required this.region,
        required this.onTap});
  final String flag;
  final String name;
  final String region;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    region,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class _OfficialChannels extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final site =
    AppStrings.ts(context, 'privacy_contact_site', fallback: 'www.sumifun.net');
    final email = AppStrings.ts(
        context, 'privacy_contact_email', fallback: 'support@sumifun.net');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(children: [
          const Icon(Icons.public_outlined),
          const SizedBox(width: 8),
          Expanded(child: SelectableText(site))
        ]),
        const SizedBox(height: 8),
        Row(children: [
          const Icon(Icons.email_outlined),
          const SizedBox(width: 8),
          Expanded(child: SelectableText(email))
        ]),
      ],
    );
  }
}

class _WhyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = AppStrings.ts(
      context,
      'distributors_note_title',
      fallback: 'Why authorized distributors?',
    );
    final note = AppStrings.ts(
      context,
      'distributors_note',
      fallback:
      'To guarantee quality, protect customers from counterfeits, and enable local after-sales support, we only work with trusted authorized partners.',
    );
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(note),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final supportTitle =
    AppStrings.ts(context, 'support_title', fallback: 'Customer Service');
    final supportIntro = AppStrings.ts(
        context, 'support_intro', fallback: 'For any questions or issues, contact our team.');
    final cta = AppStrings.ts(context, 'cta_button', fallback: 'Chat with us');
    final verify = AppStrings.ts(context, 'verify_cta', fallback: 'Verify Product');

    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(supportTitle,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(supportIntro),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: Text(cta),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
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
