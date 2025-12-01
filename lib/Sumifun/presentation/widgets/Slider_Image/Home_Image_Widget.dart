import 'package:flutter/material.dart';
import 'package:sumfiun/Core/AdaptiveLayout.dart';
import 'package:sumfiun/Core/util/App_Color.dart';
import 'package:sumfiun/Core/util/App_Image.dart';
import 'package:sumfiun/Core/util/App_Stayles.dart';
import 'package:sumfiun/Core/util/App_String.dart';
import 'package:sumfiun/Sumifun/presentation/pages/Home2.dart';
import 'package:sumfiun/Sumifun/presentation/pages/HomeTablet.dart';


import 'package:sumfiun/Sumifun/presentation/pages/RechargeScreen1.dart';
import 'package:sumfiun/Sumifun/presentation/pages/UnderDevelopmentScreen.dart';

class HomeImageWidget extends StatelessWidget {
  const HomeImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isMobile = screenSize.width < 600;
    final bool isTablet = screenSize.width >= 600 && screenSize.width < 1024;

    // 🧩 نصوص مترجمة
    final hometext1 = AppStrings.t<String>(context, 'Hometext1');
    final hometext2 = AppStrings.t<String>(context, 'Hometext2');
    final hometext3 = AppStrings.t<String>(context, 'Hometext3');
    final verifyCta  = AppStrings.t<String>(context, 'verify_cta');     // أضف في AppStrings
    final discoverCta= AppStrings.t<String>(context, 'discover_cta');   // أضف في AppStrings

    // اجعل المحاذاة تتبع اتجاه اللغة
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final cross = isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final mainButtonsAlign = isRTL ? MainAxisAlignment.end : MainAxisAlignment.start;

    return SizedBox(
      height: screenSize.height,
      width: double.infinity,
      child: Stack(
        children: [
          // الخلفية
          Positioned.fill(
            child: Image.asset(
              AppImage.Home_Image,
              fit: BoxFit.cover,
            ),
          ),

          // طبقة التعتيم والمحتوى
          Container(
            height: screenSize.height,
            width: double.infinity,
            color: Colors.black.withOpacity(0.3),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : (isTablet ? 80 : 150),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: cross,
              children: [
                Text(
                  hometext1,
                  textAlign: isRTL ? TextAlign.right : TextAlign.left,
                  style: AppStyles.styleSemiBold20(context).copyWith(
                    color: AppColor.background,
                    fontSize: isMobile ? 20 : (isTablet ? 28 : 32),
                  ),
                ),
                SizedBox(height: isMobile ? 20 : 30),
                Text(
                  hometext2,
                  textAlign: isRTL ? TextAlign.right : TextAlign.left,
                  style: AppStyles.styleMedium16(context).copyWith(
                    color: AppColor.background,
                    fontSize: isMobile ? 14 : (isTablet ? 18 : 20),
                  ),
                ),
                SizedBox(height: isMobile ? 20 : 30),
                Text(
                  hometext3, // ✅ كان مكرر Hometext2
                  textAlign: isRTL ? TextAlign.right : TextAlign.left,
                  style: AppStyles.styleMedium16(context).copyWith(
                    color: Colors.white,
                    fontSize: isMobile ? 14 : (isTablet ? 18 : 20),
                  ),
                ),
                SizedBox(height: isMobile ? 20 : 30),

                // الأزرار
                Row(
                  mainAxisAlignment: mainButtonsAlign,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 16 : 24,
                          vertical: isMobile ? 12 : 14,
                        ),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: TextStyle(
                          fontSize: isMobile ? 14 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RechargeScreen1()),
                        );
                      },
                      child: Text(verifyCta),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 16 : 24,
                          vertical: isMobile ? 12 : 14,
                        ),
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: TextStyle(
                          fontSize: isMobile ? 14 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdaptiveLayout(
                              mobileLayout: (context) =>  Hometabletr(),
                              tabletLayout: (context) =>  Hometabletr(),
                              desktopLayout: (context) =>  Home2(),
                            ),
                          ),
                        );
                      },
                      child: Text(discoverCta),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
