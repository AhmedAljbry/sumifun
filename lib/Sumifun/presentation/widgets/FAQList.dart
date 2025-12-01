import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sumfiun/Core/util/App_String.dart';

class FAQList extends StatefulWidget {
  const FAQList({super.key});

  @override
  State<FAQList> createState() => _FAQListState();
}

class _FAQListState extends State<FAQList> with RestorationMixin {
  static const double kRadius = 14;

  // مفاتيح الأسئلة/الإجابات (نقرأ قيمها من AppStrings)
  static const List<String> _qKeys = [
    'sf_faq_q1',
    'sf_faq_q2',
    'sf_faq_q3',
    'sf_faq_q4',
    'sf_faq_q5',
  ];
  static const List<String> _aKeys = [
    'sf_faq_a1',
    'sf_faq_a2',
    'sf_faq_a3',
    'sf_faq_a4',
    'sf_faq_a5',
  ];

  // ✅ استعادة الحالة: أي سؤال كان مفتوحًا
  final RestorableIntN _expandedIndex = RestorableIntN(null);

  @override
  String? get restorationId => 'faq_list_restoration_key';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_expandedIndex, 'expanded_index');
  }

  @override
  void dispose() {
    _expandedIndex.dispose();
    super.dispose();
  }

  void _toggle(int index) {
    setState(() {
      _expandedIndex.value = (_expandedIndex.value == index) ? null : index;
      HapticFeedback.selectionClick();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLarge = MediaQuery.of(context).size.width > 700;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color cardBg  = isDark ? const Color(0xFF101317) : Colors.white;
    final Color cardLine= isDark ? const Color(0xFF2A2F36) : const Color(0xFFE6EEF3);
    final Color chipBg  = isDark ? const Color(0xFF0B2230) : const Color(0xFFEAF7FF);

    // اتجاه الواجهة حسب اللغة الحالية
    final textDir = Directionality.of(context);

    // نجلب النصوص المترجمة مع fallback عربي آمن
    final List<String> titles = List<String>.generate(
      _qKeys.length,
          (i) => AppStrings.ts(context, _qKeys[i], fallback: [
        'لماذا أختار Sumifun لآلام المفاصل؟',
        'كيف أستخدم الكريم أو الزيت بالطريقة الصحيحة؟',
        'هل يناسب جميع الأعمار وأنواع البشرة؟',
        'متى أشعر بالتحسن؟',
        'ما الحل إذا لم أشعر بتحسن؟',
      ][i]),
    );

    final List<String> answers = List<String>.generate(
      _aKeys.length,
          (i) => AppStrings.ts(context, _aKeys[i], fallback: [
        'منتجات Sumifun مصممة بخبرة ألمانية ومكونة من خلاصة الأعشاب الطبيعية التي تخفف الالتهاب وتدعم حركة المفاصل. أثبتت فعاليتها مع آلاف المستخدمين الذين لاحظوا فرقًا واضحًا خلال فترة قصيرة.',
        'ضع كمية مناسبة من المنتج على المنطقة المصابة ودلك بلطف بحركات دائرية حتى تمتصه البشرة. استخدمه من 2 إلى 3 مرات يوميًا للحصول على أفضل النتائج، وخصوصًا قبل النوم أو بعد النشاط البدني.',
        'نعم، تركيبة Sumifun آمنة تمامًا ومناسبة لمعظم أنواع البشرة، ويمكن استخدامها من قِبل الرجال والنساء من مختلف الأعمار. ومع ذلك، يُفضّل تجنب الاستخدام على الجروح أو البشرة الحساسة جدًا.',
        'غالبًا يبدأ مفعول Sumifun خلال الأيام الأولى من الاستخدام المنتظم، حيث يقلّ الإحساس بالألم تدريجيًا وتتحسن مرونة الحركة. أما النتائج الطويلة الأمد فتظهر بعد أسبوعين إلى أربعة أسابيع حسب الحالة.',
        'نحن في Sumifun نؤمن بجودة منتجاتنا ونقدّم لك الضمان الذهبي. إذا لم تلاحظ أي تحسن بعد الاستخدام المنتظم، تواصل معنا وسنقوم بإرشادك أو استبدال المنتج وفق سياسة الرضا التام.',
      ][i]),
    );

    return Directionality(
      textDirection: textDir,
      child: Semantics(
        container: true,
        label: AppStrings.ts(context, 'sf_faq_semantics_list', fallback: 'قائمة الأسئلة الشائعة'),
        child: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(kRadius),
            border: Border.all(color: cardLine),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withOpacity(.06),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: titles.length,
            separatorBuilder: (_, __) => Divider(color: cardLine, height: 1),
            itemBuilder: (context, index) {
              final bool expanded = _expandedIndex.value == index;
              return _FaqTile(
                key: ValueKey('faq_$index'),
                title: titles[index],
                body: answers[index],
                expanded: expanded,
                onTap: () => _toggle(index),
                isLarge: isLarge,
                chipBg: chipBg,
                textDir: textDir,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({
    super.key,
    required this.title,
    required this.body,
    required this.expanded,
    required this.onTap,
    required this.isLarge,
    required this.chipBg,
    required this.textDir,
  });

  final String title;
  final String body;
  final bool expanded;
  final VoidCallback onTap;
  final bool isLarge;
  final Color chipBg;
  final TextDirection textDir;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = TextStyle(
      fontSize: isLarge ? 20 : 18,
      fontWeight: FontWeight.w800,
      color: theme.colorScheme.onSurface,
      height: 1.25,
    );
    final bodyStyle = TextStyle(
      fontSize: isLarge ? 16 : 14.5,
      height: 1.7,
      color: theme.colorScheme.onSurface.withOpacity(.9),
    );

    // دعم لوحة المفاتيح + Semantics
    return FocusableActionDetector(
      mouseCursor: SystemMouseCursors.click,
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<Intent>(onInvoke: (intent) {
          onTap();
          return null;
        }),
      },
      child: Semantics(
        button: true,
        container: true,
        expanded: expanded,
        label: title,
        hint: AppStrings.ts(context, 'sf_faq_semantics_toggle', fallback: 'اضغط للتوسيع أو الطي'),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: expanded ? chipBg.withOpacity(.35) : Colors.transparent,
            ),
            child: Column(
              crossAxisAlignment:
              textDir == TextDirection.rtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // العنوان + السهم
                Row(
                  children: [
                    AnimatedRotation(
                      turns: expanded ? .5 : 0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: isLarge ? 28 : 26,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        title,
                        style: titleStyle,
                        textAlign: textDir == TextDirection.rtl ? TextAlign.right : TextAlign.left,
                      ),
                    ),
                  ],
                ),

                // المحتوى
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 250),
                  crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: EdgeInsetsDirectional.only(
                      top: 10,
                      start: textDir == TextDirection.ltr ? 6 : 0,
                      end:   textDir == TextDirection.rtl ? 6 : 0,
                    ),
                    child: Text(
                      body,
                      style: bodyStyle,
                      textAlign: textDir == TextDirection.rtl ? TextAlign.right : TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
