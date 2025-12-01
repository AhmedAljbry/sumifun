import 'package:flutter/material.dart';
import 'package:sumfiun/Core/util/App_Color.dart';
import 'package:sumfiun/Core/util/App_Image.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/AppBar/Appbar_Desktop.dart';

class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  ResponsiveAppBar({required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // إذا كان العرض أكبر من 900، نعتبره ديسكتوب
    if (screenWidth > 900) {
      return AppbarDesktop();
    } else {
      // هاتف أو تابلت
      return AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Image(
            image: AssetImage(AppImage.Icon_Image),
            fit: BoxFit.scaleDown,
            height: 100,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
          icon: Icon(Icons.menu, color: AppColor.primary),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Container(
            color: AppColor.primary,
            height: 2,
          ),
        ),
      );
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
