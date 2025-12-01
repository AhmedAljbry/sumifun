
import 'package:flutter/material.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Drawer/DrawerItemModel.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/Drawer/InActiveDrawerItem.dart';

class Draweritem extends StatelessWidget {
  const Draweritem({super.key, required this.drawerItemModel, required this.isActive});
  final DrawerItemModel drawerItemModel;
  final bool isActive;
  @override
  Widget build(BuildContext context) {
        return isActive
        ? ActiveDrawerItem(drawerItemModel: drawerItemModel)
        : InActiveDrawerItem(drawerItemModel: drawerItemModel);
  }
}
