import 'package:flutter/material.dart';
import 'package:sumfiun/Core/util/App_String.dart';

class CustomText extends StatelessWidget {
  const CustomText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    final Color bgColor =
    theme.brightness == Brightness.dark ? const Color(0xFF0B2230) : const Color(0xFFEAF7FF);
    final Color titleColor =
    theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    final Color textColor =
    theme.brightness == Brightness.dark ? Colors.white70 : Colors.black87;

    // 🔤 نصوص مترجمة مع fallback آمن
    final String title   = AppStrings.ts(context, 'cta_title',    fallback: 'غير مقتنعة؟ 🤔');
    final String sub     = AppStrings.ts(context, 'cta_subtitle', fallback: 'خلينا نجاوب على أسئلتك بكل وضوح وثقة، فريقنا جاهز لمساعدتك ❤️');
    final String btnText = AppStrings.ts(context, 'cta_button',   fallback: 'تحدث معنا الآن');

    // اتجاه النص حسب الـ context الحالي
    final textDir = Directionality.of(context);

    return Directionality(
      textDirection: textDir,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        padding: EdgeInsets.symmetric(
          horizontal: isLargeScreen ? 30 : 20,
          vertical: isLargeScreen ? 40 : 25,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
          textDir == TextDirection.rtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // العنوان
            Text(
              title,
              style: TextStyle(
                fontSize: isLargeScreen ? 36 : 28,
                fontWeight: FontWeight.w900,
                color: titleColor,
                height: 1.2,
              ),
              textAlign: textDir == TextDirection.rtl ? TextAlign.right : TextAlign.left,
            ),
            const SizedBox(height: 12),

            // النص الفرعي
            Text(
              sub,
              style: TextStyle(
                fontSize: isLargeScreen ? 20 : 16,
                color: textColor,
                height: 1.6,
              ),
              textAlign: textDir == TextDirection.rtl ? TextAlign.right : TextAlign.left,
            ),

            const SizedBox(height: 20),

            // زر تفاعلي
            Align(
              alignment:
              textDir == TextDirection.rtl ? Alignment.centerLeft : Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: افتح نافذة الأسئلة أو انقل لقسم FAQ
                },
                icon: const Icon(Icons.chat_bubble_outline, size: 22),
                label: Text(
                  btnText,
                  style: TextStyle(
                    fontSize: isLargeScreen ? 18 : 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: isLargeScreen ? 28 : 22,
                    vertical: isLargeScreen ? 14 : 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: const Color(0xFF0EA5E9),
                  foregroundColor: Colors.white,
                  elevation: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
