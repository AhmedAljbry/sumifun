import 'package:flutter/material.dart';
import 'package:sumfiun/Core/AdaptiveLayout.dart';
import 'package:sumfiun/Sumifun/presentation/pages/RechargeScreen1.dart';
import 'package:sumfiun/Sumifun/presentation/pages/Tablet.dart';
import 'package:sumfiun/Sumifun/presentation/pages/UnderDevelopmentScreen.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Drawer/DrawerItem.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Drawer/DrawerItemModel.dart';

class DrawerItemsListView extends StatefulWidget {
  const DrawerItemsListView({super.key});

  @override
  State<DrawerItemsListView> createState() => _DrawerItemsListViewState();
}

class _DrawerItemsListViewState extends State<DrawerItemsListView> {
  int activeIndex = 0;

  final List<DrawerItemModel> items = [
    DrawerItemModel(title: 'الرئيسي', image: Icons.home, widget: Tablet()),
    const DrawerItemModel(
      title: 'المنتجات',
      image: Icons.production_quantity_limits,
      widget: UnderDevelopmentScreen(),
    ),
    DrawerItemModel(
      title: 'تحقق من المنتج',
      image: Icons.verified_user_outlined,
      widget: RechargeScreen1(),
    ),
    const DrawerItemModel(
      title: 'ماذا تعرف عنا',
      image: Icons.account_box_outlined,
      widget: UnderDevelopmentScreen(),
    ),
  ];

  void _navigateTo(int index) async {
    if (activeIndex == index) return;

    setState(() {
      activeIndex = index;
    });

    // إغلاق الدروار قبل التنقل
    Navigator.pop(context);

    // الانتقال إلى الصفحة المحددة
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => items[index].widget),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _navigateTo(index),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Draweritem(
              drawerItemModel: items[index],
              isActive: activeIndex == index,
            ),
          ),
        );
      },
    );
  }
}
