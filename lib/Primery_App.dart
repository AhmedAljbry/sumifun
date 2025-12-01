import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:sumfiun/Core/AdaptiveLayout.dart';
import 'package:sumfiun/Core/LocaleProvider.dart';
import 'package:sumfiun/Sumifun/presentation/pages/Home.dart';
import 'package:sumfiun/Sumifun/presentation/pages/Tablet.dart';
import 'package:sumfiun/Core/util/App_Color.dart';
import 'package:sumfiun/Sumifun/presentation/pages/policy/PrivacyPolicyPage.dart';
import 'package:sumfiun/Sumifun/presentation/pages/policy/about_us.dart';

class PrimaryApp extends StatelessWidget {
  const PrimaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocaleProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: provider.locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
        Locale('zh'),
      ],
      theme: ThemeData(
        scaffoldBackgroundColor: AppColor.background,
        primaryColor: AppColor.primary,
        colorScheme: ColorScheme.light(
          primary: AppColor.background,
          secondary: AppColor.primary,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          backgroundColor: AppColor.background,
        ),
      ),
      home: FlutterSplashScreen(
        useImmersiveMode: true,
        duration: const Duration(milliseconds: 2000),
        nextScreen: Directionality(
          // يستخدم اتجاه اللغة الحالية
          textDirection: provider.textDirection,
          child: AdaptiveLayout(
            mobileLayout: (context) =>  Tablet(),
            tabletLayout: (context) =>  Tablet(),
            desktopLayout: (context) =>  Home(),
          ),
        ),
        backgroundColor: Colors.white,
        splashScreenBody: Center(
          child: Lottie.asset("image/LottieLogo2.json", repeat: true),
        ),
      ),
    );
  }
}
