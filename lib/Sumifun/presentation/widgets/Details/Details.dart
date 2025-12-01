import 'package:flutter/material.dart';
import 'package:sumfiun/Core/util/App_Stayles.dart';
import 'package:sumfiun/Core/util/App_String.dart';


class Details extends StatelessWidget {
  const Details({
    super.key,
    required this.title,
    required this.details,
    required this.image,
    required this.onpressed,
  });

  final String title;
  final String details;
  final String image;       // يمكن أن يكون URL أو Asset
  final VoidCallback onpressed;

  @override
  Widget build(BuildContext context) {
    // نص الزر مترجم وآمن
    final String btnText = AppStrings.ts(context, 'details_button', fallback: '');

    return Container(
      padding: const EdgeInsets.all(30),
      margin: const EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // النص
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          title,
                          style: AppStyles.styleSemiBold20(context),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        details,
                        style: AppStyles.styleMedium16(context),
                        textAlign: TextAlign.end,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: onpressed,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          textStyle: AppStyles.styleMedium16(context).copyWith(color: Colors.white),
                        ),
                        child: Text(btnText),
                      ),
                    ],
                  ),
                ),
              ),

              // الصورة (ذكية: URL أو Asset)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  constraints: BoxConstraints(
                    minHeight: 150,
                    maxHeight: MediaQuery.sizeOf(context).height * 0.6,
                  ),
                  child: _buildSmartImage(
                    image,
                    width: MediaQuery.sizeOf(context).width,
                    fit: BoxFit.contain,
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

class DetailsTablet extends StatelessWidget {
  const DetailsTablet({
    super.key,
    required this.title,
    required this.details,
    required this.image,
    required this.onpressed,
  });

  final String title;
  final String details;
  final String image;     // يمكن أن يكون URL أو Asset
  final VoidCallback onpressed;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= 600;

    final horizontalPadding = isTablet ? 50.0 : 20.0;
    final verticalPadding = isTablet ? 40.0 : 20.0;

    // نص الزر مترجم وآمن
    final String btnText = AppStrings.ts(context, 'details_button', fallback: '');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding / 1.5, vertical: verticalPadding / 1.5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // الصورة (ذكية: URL أو Asset)
          Container(
            padding: const EdgeInsets.all(10),
            constraints: BoxConstraints(
              minHeight: 150,
              maxHeight: screenSize.height * 0.4,
            ),
            child: _buildSmartImage(
              image,
              width: screenSize.width * (isTablet ? 0.7 : 0.9),
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 20),

          // النصوص
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    style: AppStyles.styleSemiBold20(context).copyWith(fontSize: isTablet ? 26 : 22),
                    textAlign: TextAlign.end,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  details,
                  style: AppStyles.styleRegular16(context),
                  textAlign: TextAlign.end,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onpressed,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: AppStyles.styleMedium16(context).copyWith(color: Colors.white),
                  ),
                  child: Text(btnText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// صورة ذكية: تختار تلقائيًا بين Network و Asset وتتعامل مع الأخطاء
Widget _buildSmartImage(
    String src, {
      double? width,
      BoxFit fit = BoxFit.contain,
      Widget? error,
    }) {
  final isNetwork = src.startsWith('http://') || src.startsWith('https://');
  final errorWidget = error ?? const Icon(Icons.error, color: Colors.red, size: 50);

  return isNetwork
      ? Image.network(
    src,
    width: width,
    fit: fit,
    errorBuilder: (_, __, ___) => errorWidget,
  )
      : Image.asset(
    src,
    width: width,
    fit: fit,
    errorBuilder: (_, __, ___) => errorWidget,
  );
}
