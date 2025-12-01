import 'package:flutter/material.dart';
import 'package:sumfiun/Core/util/App_Color.dart';

class AppbarDesktopItem extends StatelessWidget {
  const AppbarDesktopItem({super.key, required this.title, });
  final String title;


  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Navigator.of(context).push(MaterialPageRoute(builder: ))
      },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.blue.withOpacity(0.1)), // تأثير عند الضغط
      ),
      child:  Text(
        title,
        style: TextStyle(
          color: AppColor.primary,
          decoration: TextDecoration.underline, // تحتها خط
          decorationColor: AppColor.primary, // لون الخط السفلي

          decorationThickness: 2, // سمك الخط
        ),
      ),
    );
  }
}