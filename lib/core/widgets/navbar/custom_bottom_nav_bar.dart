import 'package:flutter/material.dart';
import 'package:transmirror/core/utils/constants/colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? MyColors.primaryBackground,
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            offset: Offset(0, -4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            height: 60,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == currentIndex;
              final color = isSelected
                  ? (selectedItemColor ?? MyColors.primary)
                  : (unselectedItemColor ?? MyColors.textSecondary);
          
              return InkWell(
                onTap: () => onTap(index),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: SizedBox(
                  width: 80,
                  height: 60,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 2,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: isSelected ? 40 : 0,
                          height: isSelected ? 2 : 0,
                          decoration: BoxDecoration(
                            color: isSelected ? (selectedItemColor ?? MyColors.textPrimary) : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconTheme(
                            data: IconThemeData(
                              color: color,
                              size: isSelected ? 20 : 22,
                            ),
                            child: isSelected
                                ? (item.activeIcon)
                                : item.icon,
                          ),
                          if (item.label != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              item.label!,
                              style: TextStyle(
                                color: color,
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
                ),
        ),
    ),
    );
  }
}
