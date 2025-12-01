import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sumfiun/Core/util/App_Stayles.dart';
import 'package:sumfiun/Core/util/App_String.dart';



class AnimatedImagesRow extends StatefulWidget {
  const AnimatedImagesRow({super.key});

  @override
  State<AnimatedImagesRow> createState() => _AnimatedImagesRowState();
}

class _AnimatedImagesRowState extends State<AnimatedImagesRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 تحديد نوع الجهاز
    final bool isWideScreen = MediaQuery.of(context).size.width > 600;

    // 🧩 نصوص مترجمة
    final String title  = AppStrings.t<String>(context, 'Animated_Images_Row_String');
    final String line1  = AppStrings.t<String>(context, 'Animated_Images_Row_String1');
    final String line2  = AppStrings.t<String>(context, 'Animated_Images_Row_String2');

    final Widget textBlockWide = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // لعرض يسار في الشاشات العريضة
        children: [
          Text(title, style: AppStyles.styleSemiBold20(context)),
          const SizedBox(height: 16),
          Text(line1, style: AppStyles.styleMedium16(context)),
          const SizedBox(height: 8),
          Text(line2, style: AppStyles.styleRegular14(context)),
        ],
      ),
    );

    final Widget textBlockNarrow = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: AppStyles.styleSemiBold20(context), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(line1, style: AppStyles.styleMedium16(context), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(line2, style: AppStyles.styleRegular14(context), textAlign: TextAlign.center),
        ],
      ),
    );

     Widget imagesRow(double sizeFactor, double gap) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedImageCard(
          controller: _controller,
          angleOffset: -0.08,
          translation: -10,
          sizeFactor: sizeFactor,
        ),
        SizedBox(width: gap),
        AnimatedImageCard(
          controller: _controller,
          angleOffset: 0.08,
          translation: 10,
          sizeFactor: sizeFactor,
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return isWideScreen
        // 📌 عرض أفقي للتابلت/الديسكتوب
            ? Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: imagesRow(1.2, 20),
            ),
            Expanded(
              flex: 3,
              child: textBlockWide,
            ),
          ],
        )
        // 📌 عرض رأسي للموبايل
            : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            imagesRow(1.0, 10),
            const SizedBox(height: 20),
            textBlockNarrow,
          ],
        );
      },
    );
  }
}

class AnimatedImageCard extends StatelessWidget {
  final AnimationController controller;
  final double angleOffset;
  final double translation;
  final double sizeFactor;

  const AnimatedImageCard({
    super.key,
    required this.controller,
    required this.angleOffset,
    required this.translation,
    required this.sizeFactor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final double angle = angleOffset * sin(controller.value * pi);
        final double moveY = 5 * sin(controller.value * pi);

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateZ(angle)
            ..translate(translation, moveY),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            shadowColor: Colors.black38,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                translation < 0
                    ? "https://image.made-in-china.com/2f0j00cQgChrKIqGbE/Sumifun-Bee-Venom-Knee-Pain-Relief-Cream-Meniscus-Injury-Ache-Plaster-Joint-Treatment-Muscle-Sprain-Arthritis-Ointment.jpg"
                    : "https://image.made-in-china.com/2f0j00stiBqMOlAUcP/Sumifun-Arthritis-Ointment-Treatment-of-Muscle-Strain-Cervical-Spondylosis-Knee-Pain-Meniscus-Repair-Cream-Pain-Relief-Plaster.webp",
                width: 160 * sizeFactor,
                height: 220 * sizeFactor,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
