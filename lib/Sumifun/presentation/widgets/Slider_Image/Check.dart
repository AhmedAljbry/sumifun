import 'package:flutter/material.dart';
import 'package:sumfiun/Core/util/App_Color.dart';
import 'package:sumfiun/Core/util/App_String.dart';

class Check extends StatelessWidget {
  const Check({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        "icon": Icons.energy_savings_leaf_outlined,
        "title": AppStrings.t(context, 'check_item1_title'),
        "subtitle": AppStrings.t(context, 'check_item1_subtitle'),
      },
      {
        "icon": Icons.star_border,
        "title": AppStrings.t(context, 'check_item2_title'),
        "subtitle": AppStrings.t(context, 'check_item2_subtitle'),
      },
      {
        "icon": Icons.accessibility,
        "title": AppStrings.t(context, 'check_item3_title'),
        "subtitle": AppStrings.t(context, 'check_item3_subtitle'),
      },
      {
        "icon": Icons.check_circle,
        "title": AppStrings.t(context, 'check_item4_title'),
        "subtitle": AppStrings.t(context, 'check_item4_subtitle'),
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        int crossAxisCount = 2;
        double aspectRatio = 0.9;

        if (width > 900) {
          crossAxisCount = 3;
          aspectRatio = 1.3;
        } else if (width > 600) {
          crossAxisCount = 3;
          aspectRatio = 1.1;
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: aspectRatio,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      items[index]["icon"],
                      size: 40,
                      color: AppColor.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      items[index]["title"],
                      style: TextStyle(
                        fontSize: width > 600 ? 20 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: Text(
                        items[index]["subtitle"],
                        style: TextStyle(
                          fontSize: width > 600 ? 16 : 13,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
