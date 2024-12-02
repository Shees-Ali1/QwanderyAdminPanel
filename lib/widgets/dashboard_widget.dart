import 'package:flutter/material.dart';
import 'package:iw_admin_panel/colors.dart';

class DashboardWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final VoidCallback onPressed;
  final IconData iconData;
  final bool isSelected;
  final bool isDrawer;

  DashboardWidget({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.onPressed,
    required this.iconData,
    required this.isSelected,
    required this.isDrawer,
  }) : super(key: key);

  double getFontSize(double width) {
    if (width <= 430 && width > 300) return 14.0;
    if (width <= 768 && width > 430) return 14.0;
    if (width <= 1024 && width > 768) return 13.0;
    if (width <= 1440 && width > 1024) return 15.0;
    if (width <= 1600 && width > 1440) return 20.0;
    if (width <= 3000  && width > 1600) return 30.0;
    return 15.0;
  }

  double getIconSize(double width, bool isDrawer) {
    if (isDrawer) return 15.0;
    if (width <= 3000 && width > 1440) return 40.0;
    if (width <= 1440 && width > 1024) return 20.0;
    if (width <= 1024 && width > 768) return 18.0;
    return 20.0;
  }

  double getVerticalPadding(double width) {
    if (width <= 3000 && width > 1600 ) return 20.0;
    if (width <= 1600 && width > 1440 ) return 15.0;
    if (width <= 1440 && width > 1024) return 10.0;
    if (width <= 1024 && width > 768) return 10.0;
    return 10.0;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final containerColor =
    isSelected ? AppColors.blueColor : AppColors.secondaryColor;

    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: getVerticalPadding(width),
        ),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.secondaryColor,
            width: 2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              iconData,
              color: isSelected ? Colors.white : AppColors.blueColor,
              size: getIconSize(width, isDrawer),
            ),
            const SizedBox(width: 14),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                fontSize: isDrawer ? 15 : getFontSize(width),
                color: isSelected ? Colors.white : AppColors.blueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
