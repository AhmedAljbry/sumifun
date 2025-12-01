import 'package:flutter/material.dart';
import 'package:sumfiun/Core/util/App_Color.dart';
import 'package:sumfiun/Core/util/App_Image.dart';
import 'package:sumfiun/Core/util/App_String.dart';

import 'package:sumfiun/Sumifun/presentation/pages/RechargeScreen1.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/AppBar/AppIconButten.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/AppBar/Appbar_Desktop_Item.dart';
import 'package:sumfiun/Sumifun/presentation/widgets/AppBar/LanguageIconButton.dart';


class AppbarDesktop extends StatelessWidget {
  AppbarDesktop({super.key});

  // بدل النصوص مباشرة بمفاتيح الترجمة
  final List<String> _titleKeys = const <String>[
    'appbar_home',
    'appbar_allprodct',
    'appbar_verification',
    'appbar_serach',   // تأكد أن المفتاح مطابق في AppStrings (عندك سابقًا appbar_search؟)
    'appbar_aboutus',
  ];

  // أيقونات الإجراءات (يمين)
  final List<IconData> _icons = const <IconData>[
    Icons.store,
    Icons.person,
    Icons.search,
  ];

  // الصفحات المقابلة لكل عنصر (يسار)
  final List<Widget> _pages = <Widget>[
     RechargeScreen1(),
     RechargeScreen1(),
     RechargeScreen1(),
     RechargeScreen1(),
     RechargeScreen1(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColor.primary)),
        color: AppColor.background,
      ),
      margin: const EdgeInsets.all(30),
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),

          // الشعار
          Image(image: AssetImage(AppImage.Icon_Image)),
          const SizedBox(width: 20),

          // قائمة العناوين (يسار)
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final title = AppStrings.t<String>(context, _titleKeys[index]);
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => _pages[index]),
                    );
                  },
                  child: AppbarDesktopItem(title: title),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemCount: _titleKeys.length,
            ),
          ),

          const Spacer(),

          // قائمة الأيقونات + زر تغيير اللغة (يمين)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 48,
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => AppIconButten(
                    icon: _icons[index],
                    onPressed: () {
                      // نتأكد من حدود الصفحات لو الأيقونات أقل من الصفحات
                      final targetIndex = index.clamp(0, _pages.length - 1);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => _pages[targetIndex]),
                      );
                    },
                  ),
                  separatorBuilder: (context, index) =>
                  const SizedBox(width: 10),
                  itemCount: _icons.length,
                ),
              ),
              const SizedBox(width: 12),

              // 👈 أيقونة تغيير اللغة (PopupMenu)
              const LanguageIconButton(),
            ],
          ),
        ],
      ),
    );
  }
}
