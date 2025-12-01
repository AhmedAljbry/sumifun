import 'package:flutter/material.dart';
import 'package:sumfiun/Core/util/App_String.dart';

class ComparisonTable extends StatelessWidget {
  const ComparisonTable({
    super.key,
    this.statusList,
    this.rows,
    this.chips,
  });

  // Design tokens
  static const double kRadius = 14;
  static const double kGap = 16;
  static const double _breakpoint = 820; // التحويل بين جدول/بطاقات

  final List<bool>? statusList;  // true = موجود في الأصلي
  final List<String>? rows;      // نصوص الصفوف
  final List<String>? chips;     // شارات سريعة أعلى الجدول

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // ======= نصوص مترجمة (fallbacks) =======
    final headerTitle   = AppStrings.ts(context, 'cmp_title',    fallback: 'المنتج الأصلي');
    final headerBody    = AppStrings.ts(context, 'cmp_body',     fallback:
    'يتوفر داخل السعودية عبر متجرنا الرسمي فقط. خارج السعودية يمكن الحصول عليه من متجرنا الرسمي أو عبر وكلائنا المعتمدين.');
    final chipsTexts    = chips ?? AppStrings.tl(context, 'cmp_chips', fallback: const ['أصلي 100%','وكلاء معتمدون','ضمان استرجاع']);
    final colCompare    = AppStrings.ts(context, 'cmp_col_compare',  fallback: 'المقارنة');
    final colOriginal   = AppStrings.ts(context, 'cmp_col_original', fallback: 'الأصلي');
    final colFake       = AppStrings.ts(context, 'cmp_col_fake',     fallback: 'المقلد');
    final rowsTexts     = rows ?? AppStrings.tl(context, 'cmp_rows',  fallback: const [
      'نفس شكل العبوة','آمن على الشعر','طبيعي 100%','مصرح رسميًا','ضمان استرجاع','نتائج سريعة',
    ]);
    final ttOriginalYes = AppStrings.ts(context, 'cmp_tt_original_yes', fallback: 'موجود في المنتج الأصلي');
    final ttOriginalNo  = AppStrings.ts(context, 'cmp_tt_original_no',  fallback: 'غير موجود في المنتج الأصلي');
    final ttFakeYes     = AppStrings.ts(context, 'cmp_tt_fake_yes',     fallback: 'موجود في المنتج المقلد');
    final ttFakeNo      = AppStrings.ts(context, 'cmp_tt_fake_no',      fallback: 'غير موجود في المنتج المقلد');

    final List<bool> statuses = (statusList ?? List<bool>.filled(rowsTexts.length, true))
        .take(rowsTexts.length).toList();

    final Color cardBg   = isDark ? const Color(0xFF101317) : Colors.white;
    final Color cardLine = isDark ? const Color(0xFF2A2F36) : const Color(0xFFE6EEF3);
    final Color headBg   = isDark ? const Color(0xFF13212A) : const Color(0xFFEAF7FF);
    final Color zebra1   = isDark ? const Color(0x141EA7E6) : const Color(0x11BAE6FD);
    final Color zebra2   = Colors.transparent;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= _breakpoint;
          final double fontSizeTitle = isWide ? 22 : 20;
          final double fontSizeText  = isWide ? 15.5 : 14.0;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Padding(
                padding: const EdgeInsets.all(kGap),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ===== بطاقة مقدمة =====
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(kRadius),
                        border: Border.all(color: cardLine),
                        boxShadow: [
                          if (!isDark)
                            BoxShadow(
                              color: Colors.black.withOpacity(.06),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            headerTitle,
                            style: TextStyle(
                              fontSize: fontSizeTitle,
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.onSurface,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            headerBody,
                            style: TextStyle(
                              fontSize: fontSizeText,
                              color: theme.colorScheme.onSurface.withOpacity(.85),
                              height: 1.7,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final chip in chipsTexts) _ChipBadge(text: chip),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ===== عرض الجدول أو البطاقات حسب العرض =====
                    isWide
                        ? _TableView(
                      cardBg: cardBg,
                      cardLine: cardLine,
                      headBg: headBg,
                      zebra1: zebra1,
                      zebra2: zebra2,
                      colCompare: colCompare,
                      colOriginal: colOriginal,
                      colFake: colFake,
                      rowsTexts: rowsTexts,
                      statuses: statuses,
                      fontSizeText: fontSizeText,
                      ttOriginalYes: ttOriginalYes,
                      ttOriginalNo: ttOriginalNo,
                      ttFakeYes: ttFakeYes,
                      ttFakeNo: ttFakeNo,
                    )
                        : _CardsView(
                      cardBg: cardBg,
                      cardLine: cardLine,
                      rowsTexts: rowsTexts,
                      statuses: statuses,
                      ttOriginalYes: ttOriginalYes,
                      ttOriginalNo: ttOriginalNo,
                      ttFakeYes: ttFakeYes,
                      ttFakeNo: ttFakeNo,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ===================== جدول للشاشات الواسعة =====================
class _TableView extends StatelessWidget {
  const _TableView({
    required this.cardBg,
    required this.cardLine,
    required this.headBg,
    required this.zebra1,
    required this.zebra2,
    required this.colCompare,
    required this.colOriginal,
    required this.colFake,
    required this.rowsTexts,
    required this.statuses,
    required this.fontSizeText,
    required this.ttOriginalYes,
    required this.ttOriginalNo,
    required this.ttFakeYes,
    required this.ttFakeNo,
  });

  final Color cardBg, cardLine, headBg, zebra1, zebra2;
  final String colCompare, colOriginal, colFake;
  final List<String> rowsTexts;
  final List<bool> statuses;
  final double fontSizeText;
  final String ttOriginalYes, ttOriginalNo, ttFakeYes, ttFakeNo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // جدول داخل سكرول أفقي لتلافي مشكلات القياسات
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(ComparisonTable.kRadius),
        border: Border.all(color: cardLine),
        boxShadow: [
          if (Theme.of(context).brightness != Brightness.dark)
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ComparisonTable.kRadius),
        child: LayoutBuilder(
          builder: (ctx, cons) {
            final double tableWidth =
            (cons.maxWidth - 2 * ComparisonTable.kGap).clamp(720.0, double.infinity);
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: tableWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // رأس الجدول
                    Container(
                      decoration: BoxDecoration(
                        color: headBg,
                        border: Border(bottom: BorderSide(color: cardLine)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: _HeaderCell(label: colCompare, icon: Icons.analytics_outlined),
                          ),
                          Expanded(
                            flex: 2,
                            child: _HeaderCell(label: colOriginal, icon: Icons.verified_rounded),
                          ),
                          Expanded(
                            flex: 2,
                            child: _HeaderCell(label: colFake, icon: Icons.report_gmailerrorred_rounded),
                          ),
                        ],
                      ),
                    ),

                    // صفوف
                    ...List.generate(rowsTexts.length, (i) {
                      final text   = rowsTexts[i];
                      final status = i < statuses.length ? statuses[i] : true;
                      final rowColor = i.isEven ? zebra1 : zebra2;

                      return Container(
                        color: rowColor,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: _BodyCell(
                                child: Text(
                                  text,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: fontSizeText,
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: _BodyCell(
                                child: Center(
                                  child: Tooltip(
                                    message: status ? ttOriginalYes : ttOriginalNo,
                                    waitDuration: const Duration(milliseconds: 350),
                                    child: Icon(
                                      status ? Icons.check_circle_rounded : Icons.cancel_rounded,
                                      color: status ? const Color(0xFF16A34A) : const Color(0xFFE11D48),
                                      size: 26,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: _BodyCell(
                                child: Center(
                                  child: Tooltip(
                                    message: !status ? ttFakeYes : ttFakeNo,
                                    waitDuration: const Duration(milliseconds: 350),
                                    child: Icon(
                                      !status ? Icons.check_circle_rounded : Icons.cancel_rounded,
                                      color: !status ? const Color(0xFF16A34A) : const Color(0xFFE11D48),
                                      size: 26,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// ===================== بطاقات للشاشات الصغيرة =====================
class _CardsView extends StatelessWidget {
  const _CardsView({
    required this.cardBg,
    required this.cardLine,
    required this.rowsTexts,
    required this.statuses,
    required this.ttOriginalYes,
    required this.ttOriginalNo,
    required this.ttFakeYes,
    required this.ttFakeNo,
  });

  final Color cardBg, cardLine;
  final List<String> rowsTexts;
  final List<bool> statuses;
  final String ttOriginalYes, ttOriginalNo, ttFakeYes, ttFakeNo;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: List.generate(rowsTexts.length, (i) {
        final text   = rowsTexts[i];
        final status = i < statuses.length ? statuses[i] : true;

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(ComparisonTable.kRadius),
            border: Border.all(color: cardLine),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, height: 1.6),
                ),
              ),
              const SizedBox(width: 10),
              _DotIcon(isPositive: status, tooltip: status ? ttOriginalYes : ttOriginalNo),
              const SizedBox(width: 10),
              _DotIcon(isPositive: !status, tooltip: !status ? ttFakeYes : ttFakeNo),
            ],
          ),
        );
      }),
    );
  }
}

// ======= خلايا الجدول =======

class _HeaderCell extends StatelessWidget {
  final String label;
  final IconData? icon;
  const _HeaderCell({required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: theme.colorScheme.onSurface.withOpacity(.8)),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface.withOpacity(.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _BodyCell extends StatelessWidget {
  final Widget child;
  const _BodyCell({required this.child});

  @override
  Widget build(BuildContext context) {
    final Color line = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2A2F36)
        : const Color(0xFFE6EEF3);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: line)),
      ),
      child: child,
    );
  }
}

// أيقونة مُصغّرة للبطاقات (موبايل)
class _DotIcon extends StatelessWidget {
  final bool isPositive;
  final String tooltip;
  const _DotIcon({required this.isPositive, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    const Color ok  = Color(0xFF16A34A);
    const Color bad = Color(0xFFE11D48);
    final icon  = isPositive ? Icons.check_circle_rounded : Icons.cancel_rounded;
    final color = isPositive ? ok : bad;
    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 350),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

// شارة صغيرة
class _ChipBadge extends StatelessWidget {
  final String text;
  const _ChipBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B2230) : const Color(0xFFEAF7FF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isDark ? const Color(0xFF163245) : const Color(0xFFBAE6FD),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified_rounded, size: 16, color: Color(0xFF0EA5E9)),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(.9),
            ),
          ),
        ],
      ),
    );
  }
}
