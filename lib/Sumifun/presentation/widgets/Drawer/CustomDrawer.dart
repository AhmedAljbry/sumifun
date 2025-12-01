
import 'package:flutter/material.dart';
import 'package:sumfiun/Sumifun/presentation/pages/UnderDevelopmentScreen.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Drawer/DrawerItemModel.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Drawer/DrawerItemsListView.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Drawer/InActiveDrawerItem.dart';


class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * .7,
      color: const Color.fromRGBO(255, 255, 255, 1),
      child: const CustomScrollView(
        slivers: [

          SliverToBoxAdapter(
            child: SizedBox(
              height: 8,
            ),
          ),
          DrawerItemsListView(),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                Expanded(
                    child: SizedBox(
                      height: 20,
                    )),
                Center(
                  child: InActiveDrawerItem(
                    drawerItemModel: DrawerItemModel(
                        title: 'الضبط', image: Icons.settings, widget: UnderDevelopmentScreen ()),
                  ),
                ),
                InActiveDrawerItem(
                  drawerItemModel: DrawerItemModel(
                      title: 'الخروج', image: Icons.login_outlined, widget: UnderDevelopmentScreen ()),
                ),
                SizedBox(
                  height: 48,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}