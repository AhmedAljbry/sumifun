import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sumfiun/Core/util/App_Stayles.dart';
import 'package:sumfiun/Core/util/App_String.dart';

class AnimatedImagesRowTablet extends StatefulWidget {
  const AnimatedImagesRowTablet({super.key});

  @override
  State<AnimatedImagesRowTablet> createState() => _AnimatedImagesRowTabletState();
}

class _AnimatedImagesRowTabletState extends State<AnimatedImagesRowTablet>
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
    final bool isWideScreen = MediaQuery.of(context).size.width > 600;

    // 🧩 نصوص مترجمة
    final String title    = AppStrings.t<String>(context, 'Animated_Images_Row_String');
    final String line1    = AppStrings.t<String>(context, 'Animated_Images_Row_String1');
    final String line2    = AppStrings.t<String>(context, 'Animated_Images_Row_String2');

    final Widget textsBlock = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
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

    final Widget imagesRow = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedImageCard(
          controller: _controller,
          angleOffset: -0.08,
          translation: -10,
          sizeFactor: isWideScreen ? 1.2 : 1.0,
        ),
        SizedBox(width: isWideScreen ? 20 : 10),
        AnimatedImageCard(
          controller: _controller,
          angleOffset: 0.08,
          translation: 10,
          sizeFactor: isWideScreen ? 1.2 : 1.0,
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            imagesRow,
            SizedBox(height: isWideScreen ? 30 : 20),
            textsBlock,
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
